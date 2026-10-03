# plori

plori (plori.ai): a cloud AI agent with its own persistent environment - durable
disk, real CLI tools, and memory.

This plugin adds three things to Claude Code:

- **The plori MCP server** (`.mcp.json`): the remote server at
  `https://api.plori.ai/mcp`, so `create_agent`, `invoke_agent`, `schedule_run`, and
  the other plori tools are available in your session. Authentication is OAuth 2.1
  (sign in with an email code) or an API key.
- **The plori skill** (`skills/plori/SKILL.md`): tells Claude how to connect, create
  agents, invoke them and read replies, answer human-in-the-loop requests, and
  schedule runs. It is the same file that plori serves at
  `https://plori.ai/.well-known/agent-skills/plori/SKILL.md`.
- **A background monitor** (`monitors/monitors.json`): tells Claude when one of your
  runs finishes or stops for an answer. It runs `scripts/plori-watch.sh`, which calls
  the plori CLI if you installed it, and exits when the CLI is not installed.

The plugin installs no third-party software. Running an agent uses your prepaid plori
balance.

Install, connection, and timeout details: see the
[repository README](https://github.com/plori-ai/claude-plugin#readme) and the
[connection guide](https://plori.ai/mcp). Questions: dev@plori.ai.

## License

MIT
