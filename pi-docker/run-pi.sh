# run script should be in a subdir of the work dir
SCRIPT_DIR=$(cd "$(dirname "$(readlink -f "$0")")" && pwd)
PROJ_PATH=$(realpath "$SCRIPT_DIR/..")

PI_CONFIG_PATH=$(dirname "$(readlink -f "$HOME/.pi/agent")")

echo "--- Pi Agent Persistent Session ---"
echo "Project: $PROJ_PATH"
echo "Config:  $PI_CONFIG_PATH"
echo "-----------------------------------"

# Add --entrypoint /bin/bash \ if bash session is needed
docker run -it --rm \
    --name "pi-agent-studia" \
    --user $(id -u):$(id -g) \
    -v "$PROJ_PATH:/workspace" \
    -v "$PI_CONFIG_PATH:/home/node/.pi" \
    -v "/workspace/.venv" \
    -v "/workspace/pi-docker" \
    -v "node-uv-cache:/home/node/.cache/uv" \
    -e PI_CODING_AGENT_DIR="/home/node/.pi/agent" \
    --security-opt no-new-privileges:true \
    --cap-drop ALL \
    --pids-limit 512 \
    --memory 8g \
    --init \
    pi-agent:studia
