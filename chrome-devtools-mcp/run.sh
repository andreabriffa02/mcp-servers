#!/bin/bash
# Chrome DevTools MCP - Docker Run Script
# Usage: ./run.sh [port] [image]
# Examples:
#   ./run.sh                    # Uses default port 9223 and local image
#   ./run.sh 9221               # Custom port
#   ./run.sh 9223 briffa/chrome-devtools-mcp  # Custom image

set -e

PORT="${1:-9223}"
IMAGE="${2:-chrome-devtools-mcp:latest}"
CONTAINER_NAME="chrome-devtools-mcp"

# Stop and remove existing container if running
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo "Stopping and removing existing container..."
    docker stop "$CONTAINER_NAME" 2>/dev/null || true
    docker rm "$CONTAINER_NAME" 2>/dev/null || true
fi

echo "Starting Chrome DevTools MCP on port $PORT..."

docker run -d \
    --name "$CONTAINER_NAME" \
    -p "${PORT}:${PORT}" \
    -e CHROME_DEVTOOLS_MCP_NO_USAGE_STATISTICS=1 \
    -e DOCKER_CHROME_DEVTOOLS_PORT="$PORT" \
    --restart unless-stopped \
    "$IMAGE"

echo "Container started! MCP endpoint: http://localhost:${PORT}/sse"
