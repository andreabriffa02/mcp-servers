# Chrome DevTools MCP Server Docker Image
# Uses Node.js 24 LTS and exposes MCP via SSE for remote IDE connection
# Works on both AMD64 and ARM64 (Apple Silicon)
FROM node:24-bookworm

# Install Chromium and dependencies (works on ARM64 and AMD64)
RUN apt-get update && apt-get install -y \
    chromium \
    curl \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Create app directory
WORKDIR /app

# Install chrome-devtools-mcp and supergateway (stdio to SSE bridge)
RUN npm install -g chrome-devtools-mcp@latest supergateway@latest

# Create startup script
COPY --chmod=755 start.sh /app/start.sh

# Expose ports
# 9223 - SSE endpoint for MCP client connection (default, configurable via DOCKER_CHROME_DEVTOOLS_PORT)
# 9222 - Chrome DevTools debugging port (optional, for direct access)
EXPOSE 9223 9223

CMD ["/app/start.sh"]
