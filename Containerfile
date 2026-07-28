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

# Install the agent globally using npm
# Doing this as root ensures it is placed in /usr/local/bin
RUN npm install -g --ignore-scripts @earendil-works/pi-coding-agent

# Create the workspace as root
RUN mkdir -p /workspace && chown node:node /workspace

# Switch to the non-root user
USER node
WORKDIR /workspace

ENTRYPOINT ["pi"]
