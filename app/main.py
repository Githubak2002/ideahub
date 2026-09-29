import logging
import time
from contextlib import asynccontextmanager

from fastapi import FastAPI, HTTPException, Request
from fastapi.responses import JSONResponse

import cosmos_client
from logging_config import setup_logging
from models import Idea, IdeaCreate

setup_logging()
logger = logging.getLogger("ideahub")
access_logger = logging.getLogger("ideahub.access")


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


@app.middleware("http")
async def log_requests(request: Request, call_next):
    """
    One line per request, success or failure - this replaces uvicorn's
    default access log (silenced in logging_config.py). Level tracks status
    code so a clean run stays at INFO and only 4xx/5xx show up louder,
    which is what actually makes logs scannable in prod.
    """
    start = time.perf_counter()
    response = await call_next(request)
    duration_ms = round((time.perf_counter() - start) * 1000, 1)

    if response.status_code >= 500:
        log = access_logger.error
    elif response.status_code >= 400:
        log = access_logger.warning
    else:
        log = access_logger.info

    log(
        "%s %s -> %s (%.1fms)",
        request.method,
        request.url.path,
        response.status_code,
        duration_ms,
        extra={
            "method": request.method,
            "path": request.url.path,
            "status_code": response.status_code,
            "duration_ms": duration_ms,
        },
    )
    return response


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