# docker build --no-cache -t pi-agent:studia .

FROM docker.io/library/node:24-trixie-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    ca-certificates \
    fd-find \
    ripgrep \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g --ignore-scripts @earendil-works/pi-coding-agent

RUN mkdir -p /workspace && chown node:node /workspace

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

USER node
WORKDIR /workspace

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/
ENV UV_PYTHON_PREFERENCE=only-managed \
    UV_CACHE_DIR=/home/node/.cache/uv \
    UV_LINK_MODE=copy \
    UV_PROJECT_ENVIRONMENT=/home/node/.venv
RUN uv python install 3.12

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["pi"]
