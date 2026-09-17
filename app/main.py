import logging
from contextlib import asynccontextmanager

from fastapi import FastAPI, HTTPException
from fastapi.responses import JSONResponse

import cosmos_client
from models import Idea, IdeaCreate

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("ideahub")


@asynccontextmanager
async def lifespan(app: FastAPI):
    yield
    await cosmos_client.close()


app = FastAPI(
    title="IdeaHub",
    description="Minimal API demonstrating AKS -> Cosmos DB via Workload Identity + UAMI (no keys)",
    version="1.0.0",
    lifespan=lifespan,
)


@app.get("/healthz")
async def healthz():
    """Liveness only - process is up. Deliberately does not touch Cosmos DB."""
    return {"status": "ok"}


@app.get("/readyz")
async def readyz():
    """
    Readiness - proves the pod can actually authenticate to Cosmos DB via
    Workload Identity right now, not just that the process started. A stuck
    federated credential / RBAC misconfiguration shows up here as NotReady,
    not as a 500 on the first real user request.
    """
    try:
        await cosmos_client.list_ideas(limit=1)
        return {"status": "ready"}
    except Exception:
        logger.exception("readiness check failed")
        # DevSecOps: no exception detail (account names, error internals) in
        # the response body - only in server-side logs.
        return JSONResponse(status_code=503, content={"status": "not-ready"})


@app.post("/ideas", response_model=Idea, status_code=201)
async def create_idea(payload: IdeaCreate):
    idea = Idea(idea=payload.idea, description=payload.description)
    try:
        await cosmos_client.create_idea(idea.model_dump())
    except Exception:
        logger.exception("failed to write idea to Cosmos DB")
        raise HTTPException(status_code=502, detail="could not save idea")
    return idea


@app.get("/ideas", response_model=list[Idea])
async def get_ideas(limit: int = 50):
    limit = max(1, min(limit, 200))
    try:
        return await cosmos_client.list_ideas(limit=limit)
    except Exception:
        logger.exception("failed to list ideas from Cosmos DB")
        raise HTTPException(status_code=502, detail="could not list ideas")


@app.get("/ideas/{idea_id}", response_model=Idea)
async def get_idea(idea_id: str):
    try:
        item = await cosmos_client.get_idea(idea_id)
    except Exception:
        logger.exception("failed to read idea from Cosmos DB")
        raise HTTPException(status_code=502, detail="could not read idea")
    if item is None:
        raise HTTPException(status_code=404, detail="idea not found")
    return item
