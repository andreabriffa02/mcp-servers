# Chrome DevTools MCP Server

Run Chrome DevTools MCP in Docker and connect it to your IDE.

### Important Information

- `<host-port>` - The port on your machine (e.g., 9223, 9221). This is what you'll use in your IDE's MCP config URL.
- `9223` - The port the MCP server exposes inside the container. This stays fixed.
- `<docker-username>` - The Docker Hub username the image is published under (e.g., `briffa`).
- `192.168.65.1` - Default common IP address of Docker on host machine.
- `9222` - Chrome debugging port (chosen arbitrarily by me)

## Pull Docker Image

Command: `docker pull briffa/chrome-devtools-mcp`

Link: https://hub.docker.com/r/briffa/chrome-devtools-mcp

![img_1.png](img_1.png)

## Run Docker Container

### From docker hub (desktop application)

- ALWAYS Specify host port (default. 9223)
- [PREFERRED] Specify name i.e. `chrome-devtools-mcp`

![img_2.png](img_2.png)

### or connect from terminal
```bash
docker run -d --name chrome-devtools-mcp -p 9223:9223 <docker-username>/chrome-devtools-mcp:latest
```

## Connect your MCP Client (kiro, claude etc.)

Add to your MCP config i.e. `mcp.json`:

```json
{
  "mcpServers": {
    "chrome-devtools": {
      "url": "http://localhost:<mounted-host-port>/sse"
    }
  }
}
```

## Open Chrome tab with debugging port

```open -n -a /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --args --user-data-dir="/tmp/chrome_dev_test" --profile-directory="Default" --no-first-run --no-default-browser-check --remote-debugging-port=9222 --remote-debugging-address=192.168.65.1```

## Change Host Port

```bash
docker stop chrome-devtools-mcp
docker rm chrome-devtools-mcp
docker run -d --name chrome-devtools-mcp -p <new-host-port>:9223 <docker-username>/chrome-devtools-mcp:latest
```

Update your IDE's MCP config to use the new port (e.g., `http://localhost:9221/sse`).

## Useful Commands

```bash
docker logs chrome-devtools-mcp    # View logs
docker stop chrome-devtools-mcp    # Stop
docker start chrome-devtools-mcp   # Start again
```

## Alias setup ~/.zshrc

Notes:
- Do not use the default chrome profile directory, as it will potentially conflict
- Passing the `--incognito` flag will not work with the MCP server
- For the "incognito" debugging script below, `$(mktemp -d -p $CHROME_TMP_FOLDER)` creates a temporary directory each time (mimics incognito mode)

```
export DOCKER_LOCAL_ADDRESS="192.168.65.1"
export CHROME="Google Chrome" 
export CHROME_DEBUG_FOLDER="$HOME/chrome-debug-profile"
export CHROME_DEBUGGING_PORT=9222
export CHROME_TMP_FOLDER="$HOME/tmp"

alias chrome-debugging='open -n -a "$CHROME" --args --user-data-dir=$CHROME_DEBUG_FOLDER --profile-directory="Default" --disable-web-security --no-first-run --no-default-browser-check --remote-debugging-port="$CHROME_DEBUGGING_PORT" --remote-debugging-address="$DOCKER_LOCAL_ADDRESS"'

alias chrome-incognito-debugging='rm -rf "$CHROME_TMP_FOLDER" && mkdir -p "$CHROME_TMP_FOLDER" && open -n -a "$CHROME" --args --user-data-dir="$(mktemp -d -p $CHROME_TMP_FOLDER)" --profile-directory="Default" --disable-web-security --no-first-run --no-default-browser-check --remote-debugging-port="$CHROME_DEBUGGING_PORT" --remote-debugging-address="$DOCKER_LOCAL_ADDRESS"'
```
