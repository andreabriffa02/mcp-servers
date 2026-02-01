# Chrome DevTools MCP Server in Docker

Run Chrome DevTools MCP server in a Docker container and connect to it from your Mac IDE.

## Quick Start

1. **Build the image:**
   ```bash
   cd chrome-devtools-mcp
   docker build -t chrome-devtools-mcp:latest .
   ```

2. **Run the container:**
   ```bash
   ./run.sh
   ```
   
   Or manually:
   ```bash
   docker run -d \
       --name chrome-devtools-mcp \
       -p 9223:9223 \
       -e CHROME_DEVTOOLS_MCP_NO_USAGE_STATISTICS=1 \
       -e DOCKER_CHROME_DEVTOOLS_PORT=9223 \
       --restart unless-stopped \
       chrome-devtools-mcp:latest
   ```

3. **Verify it's running:**
   ```bash
   # Check container logs
   docker logs chrome-devtools-mcp
   
   # Test the SSE endpoint
   curl http://localhost:9223/sse
   ```

4. **Configure your IDE** (see below)

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

Use the run script with a custom port:

```bash
./run.sh 8080
```

Or manually:

```bash
docker run -d \
    --name chrome-devtools-mcp \
    -p 8080:8080 \
    -e CHROME_DEVTOOLS_MCP_NO_USAGE_STATISTICS=1 \
    -e DOCKER_CHROME_DEVTOOLS_PORT=8080 \
    --restart unless-stopped \
    chrome-devtools-mcp:latest
```

Then update your IDE mcp config to use the new port (e.g., `http://localhost:8080/sse`).

### Changing Port (Docker Hub Image)

If you pulled the image from Docker Hub and want to change the host port:

```bash
docker stop chrome-devtools-mcp
docker rm chrome-devtools-mcp
./run.sh <new-port> briffa/chrome-devtools-mcp:latest
```

Or manually:

```bash
docker run -d \
    --name chrome-devtools-mcp \
    -p <new-port>:<new-port> \
    -e CHROME_DEVTOOLS_MCP_NO_USAGE_STATISTICS=1 \
    -e DOCKER_CHROME_DEVTOOLS_PORT=<new-port> \
    --restart unless-stopped \
    briffa/chrome-devtools-mcp:latest
```

Then update your IDE mcp config to use the new port.

## Commands

```bash
# Build the image
docker build -t chrome-devtools-mcp:latest .

# Start the container
./run.sh

# View logs
docker logs -f chrome-devtools-mcp

# Stop the container
docker stop chrome-devtools-mcp

# Remove the container
docker rm chrome-devtools-mcp

# Rebuild and restart
docker build -t chrome-devtools-mcp:latest .
./run.sh
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
If Chrome on your host machine crashes, ensure you have enough memory available and that no other processes are consuming excessive resources.

### Run chrome command

Note: `192.168.65.1` is default IP address of the Docker on host machine

```open -n -a /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --args --user-data-dir="/tmp/chrome_dev_test" --profile-directory="Default" --disable-web-security --no-first-run --no-default-browser-check --remote-debugging-port=9222 --remote-debugging-address=192.168.65.1```
