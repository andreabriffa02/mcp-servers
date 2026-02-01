# Chrome DevTools MCP Server in Docker

Run Chrome DevTools MCP server in a Docker container and connect to it from your Mac IDE.

## Quick Start

1. **Build and run the container:**
   ```bash
   cd chrome-devtools-mcp
   docker compose up -d --build
   ```

2. **Verify it's running:**
   ```bash
   # Check container logs
   docker logs chrome-devtools-mcp
   
   # Test the SSE endpoint
   curl http://localhost:9223/sse
   ```

3. **Configure your IDE** (see below)

## IDE Configuration

### Kiro

Add to your `~/.kiro/settings/mcp.json` or workspace `.kiro/settings/mcp.json`:

```json
{
  "mcpServers": {
    "chrome-devtools": {
      "url": "http://localhost:9223/sse"
    }
  }
}
```

### VS Code / Cursor

Add to your MCP settings:

```json
{
  "mcpServers": {
    "chrome-devtools": {
      "url": "http://localhost:9223/sse"
    }
  }
}
```

### Claude Desktop

Add to `~/Library/Application Support/Claude/claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "chrome-devtools": {
      "url": "http://localhost:9223/sse"
    }
  }
}
```

## Ports

- **9223** - MCP SSE endpoint (connect your IDE here, configurable)
- **9222** - Chrome DevTools debugging port (optional, for direct browser access)

### Custom Port

Override the default SSE port (9223) using the `DOCKER_CHROME_DEVTOOLS_PORT` environment variable:

```bash
# Option 1: Inline
DOCKER_CHROME_DEVTOOLS_PORT=8080 docker compose up -d

# Option 2: Export
export DOCKER_CHROME_DEVTOOLS_PORT=8080
docker compose up -d

# Option 3: .env file
echo "DOCKER_CHROME_DEVTOOLS_PORT=8080" > .env
docker compose up -d
```

Then update your IDE mcp config to use the new port (e.g., `http://localhost:8080/sse`).

### Changing Port (Docker Hub Image)

If you pulled the image from Docker Hub and want to change the host port:

```bash
docker stop chrome-devtools-mcp
docker rm chrome-devtools-mcp
docker run -d --name chrome-devtools-mcp -p <new-host-port>:9223 <docker-tagged-username>/chrome-devtools-mcp:latest
```

Replace `<new-host-port>` with your desired port and `<username>` with the Docker Hub username (e.g., `vibe-coder-404`).

Then update your IDE mcp config to use the new port.

## Commands

```bash
# Start the container
docker compose up -d

# View logs
docker logs -f chrome-devtools-mcp

# Stop the container
docker compose down

# Rebuild after changes
docker compose up -d --build
```

## Troubleshooting

### Container won't start
Check if ports 9223 or 9222 are already in use:
```bash
lsof -i :9223
lsof -i :9222
```

### Connection refused from IDE
1. Ensure container is running: `docker ps`
2. Check logs: `docker logs chrome-devtools-mcp`
3. Test endpoint: `curl http://localhost:9223/sse`

### Chrome crashes
The container needs sufficient shared memory. The `shm_size: '2gb'` in docker-compose.yml should handle this, but you can increase it if needed.

### Run chrome command

Note: `192.168.65.1` is default IP address of the Docker on host machine

```open -n -a /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --args --user-data-dir="/tmp/chrome_dev_test" --profile-directory="Default" --disable-web-security --no-first-run --no-default-browser-check --remote-debugging-port=9222 --remote-debugging-address=192.168.65.1```
