# syntax=docker/dockerfile:1

# --- build stage: compile deps with a full toolchain, discard it after -----
FROM python:3.12-slim AS builder
WORKDIR /build
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

# --- runtime stage: minimal image, no compilers, no package manager cache --
FROM python:3.12-slim
LABEL org.opencontainers.image.source="https://github.com/YOUR_ORG/aks-cosmosdb-workload-identity"

# Non-root, fixed UID (matches k8s securityContext.runAsUser in deployment.yaml)
RUN groupadd -g 10001 appgroup && \
    useradd -u 10001 -g appgroup -s /usr/sbin/nologin -M appuser

COPY --from=builder /root/.local /home/appuser/.local
WORKDIR /app
COPY main.py models.py cosmos_client.py ./

ENV PATH="/home/appuser/.local/bin:${PATH}" \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

USER 10001:10001
EXPOSE 8000

# No secrets in ENV, no ARG for credentials, nothing to leak via `docker history`.
ENTRYPOINT ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
