# --- build stage: compile deps, discard it after -----
FROM python:3.12-slim AS builder
WORKDIR /build
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

# --no-cache-dir : prevents pip from caching packages at /root/.cache/pip, to keep the image size small
# --user : installs packages to /root/.local, which is copied to the runtime image in the next stage

# --- runtime stage: minimal image, no compilers, no package manager cache --
FROM python:3.12-slim
LABEL org.opencontainers.image.source="https://github.com/githubak2002/aks-workload-identity"

# Non-root, fixed UID (matches k8s securityContext.runAsUser in deployment.yaml)
RUN groupadd -g 10001 appgroup && \
    useradd -u 10001 -g appgroup -s /usr/sbin/nologin -M appuser

# groupadd : creates a new group with GID 10001 named appgroup
# useradd : creates a new user (appuser) with UID 10001, belonging to the appgroup
# -s /usr/sbin/nologin : prevents the user from logging in interactively
# -M : do not create a home directory for the user (/home/appuser)

COPY --from=builder /root/.local /home/appuser/.local 
# The above line copies the installed Python packages from the builder stage to the runtime image, specifically to the appuser's local directory.

WORKDIR /app
COPY main.py models.py cosmos_client.py logging_config.py ./

ENV PATH="/home/appuser/.local/bin:${PATH}" \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

# PATH : 
# PYTHONUNBUFFERED : ensures that Python output is sent straight to the terminal without being buffered, which is useful for logging in Docker containers.
# PYTHONDONTWRITEBYTECODE : prevents Python from writing .pyc bytecode files to disk

USER 10001:10001
EXPOSE 8000

# No secrets in ENV, no ARG for credentials, nothing to leak via `docker history`.
ENTRYPOINT ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
