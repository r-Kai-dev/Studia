# This container is NOT for the product itself, but to use the Pi Coding Agent
# Build: at project root, `podman build --no-cache -t pi-agent:studia .`
# Clean: After rebuild, clean the dangling images with `podman image prune`

# Use a slim LTS version of Node
FROM docker.io/library/node:24-bookworm-slim

# 1. Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    ca-certificates \
    fd-find \
    ripgrep \
    && rm -rf /var/lib/apt/lists/*

# 2. Install uv (and uvx) from the official image. These are standalone
# binaries, so uv needs no system Python to run.
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /usr/local/bin/

# Install the agent globally using npm
# Doing this as root ensures it is placed in /usr/local/bin
RUN npm install -g --ignore-scripts @earendil-works/pi-coding-agent

# Create the workspace as root
RUN mkdir -p /workspace && chown node:node /workspace

# Switch to the non-root user
USER node
WORKDIR /workspace

# 3. Install a self-contained, uv-managed Python. only-managed ensures uv never
# falls back to a system Python (there is none in this image). copy avoids
# hardlink failures when uv materialises packages into a venv on another mount.
# UV_PROJECT_ENVIRONMENT keeps the venv outside /workspace so the project bind
# mount in run-pi.sh does not hide it (and no host-side volume copy is needed).
ENV UV_PYTHON_PREFERENCE=only-managed \
    UV_LINK_MODE=copy \
    UV_PROJECT_ENVIRONMENT=/home/node/.venv
RUN uv python install 3.12

# 4. Optionally pre-install dependencies from pyproject.toml / uv.lock. The
# build context is bind-mounted so this step can inspect the project without a
# COPY layer. If pyproject.toml is absent (the current state), skip it and keep
# building the remaining layers. uv.lock, when present, is preferred.
RUN --mount=type=bind,source=.,target=/ctx,ro \
    if [ -f /ctx/pyproject.toml ]; then \
        cp /ctx/pyproject.toml /workspace/; \
        [ -f /ctx/uv.lock ] && cp /ctx/uv.lock /workspace/; \
        if [ -f /workspace/uv.lock ]; then \
            uv sync --frozen; \
        else \
            uv sync; \
        fi; \
    else \
        echo "No pyproject.toml in build context; skipping uv sync."; \
    fi

ENTRYPOINT ["pi"]
