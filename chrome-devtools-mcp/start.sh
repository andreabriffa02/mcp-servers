#!/bin/bash
set -e

# Configurable port (default: 9223)
DOCKER_CHROME_DEVTOOLS_PORT="${DOCKER_CHROME_DEVTOOLS_PORT:-9223}"

# Resolve host.docker.internal to its IPv4 address
# Chrome rejects non-IP/localhost Host headers for security
# Use -4 flag to force IPv4 resolution
HOST_IP=$(getent ahostsv4 host.docker.internal | head -1 | awk '{ print $1 }')

if [ -z "$HOST_IP" ]; then
    echo "ERROR: Could not resolve host.docker.internal to IPv4"
    exit 1
fi

BROWSER_URL="http://${HOST_IP}:9222"

echo "Starting MCP server with SSE transport on port $DOCKER_CHROME_DEVTOOLS_PORT..."
echo "Connecting to browser at: $BROWSER_URL (host.docker.internal resolved to $HOST_IP)"

# Use supergateway to expose chrome-devtools-mcp over SSE
exec npx supergateway \
    --stdio "npx chrome-devtools-mcp --browser-url=$BROWSER_URL --no-usage-statistics" \
    --port "$DOCKER_CHROME_DEVTOOLS_PORT" \
    --host 0.0.0.0
