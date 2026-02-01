# Chrome DevTools MCP Server Docker Image
# Connects to Chrome running on host machine via debugging port
# Works on both AMD64 and ARM64 (Apple Silicon)
FROM node:24-alpine

# Install curl for healthchecks
RUN apk add --no-cache curl

# Create app directory
WORKDIR /app

# Install chrome-devtools-mcp and supergateway (stdio to SSE bridge)
RUN npm install -g chrome-devtools-mcp@latest supergateway@latest

# Create startup script
COPY --chmod=755 start.sh /app/start.sh

# Expose ports
# 9223 - SSE endpoint for MCP client connection (default, configurable via DOCKER_CHROME_DEVTOOLS_PORT)
EXPOSE 9223

CMD ["/app/start.sh"]
