#!/usr/bin/env sh
set -e

export UV_CACHE_DIR="${UV_CACHE_DIR:-/home/node/.cache/uv}"

if [ -f "pyproject.toml" ] || [ -f "uv.lock" ]; then
    echo "Syncing Python dependencies with uv..."
    uv sync
fi

if [ -d "/home/node/.venv/bin" ]; then
    export PATH="/home/node/.venv/bin:$PATH"
fi

exec "$@"
