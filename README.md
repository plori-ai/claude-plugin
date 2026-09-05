# plori Claude Code plugin

A one-install plugin for [plori](https://plori.ai): AI agents in persistent cloud
environments with durable disks, real tools, and memory.

Installing this plugin gives Claude Code two things at once:

- **The plori MCP server** (`.mcp.json`): the remote server at `https://api.plori.ai/mcp`,
  so `create_agent`, `invoke_agent`, `schedule_run`, and the rest become tools in your
  session. Authentication is OAuth 2.1 (sign in once with an email code) or an API key.
- **The plori skill** (`skills/plori/SKILL.md`): teaches Claude how to connect, create
  agents, invoke them and read replies, answer human-in-the-loop requests, and schedule
  deferred runs. Its content is the same one served at
  `https://plori.ai/.well-known/agent-skills/plori/SKILL.md`.

## Install

In a Claude Code conversation, add this marketplace and install the plugin:

```text
/plugin marketplace add plori-ai/claude-plugin
/plugin install plori@plori
/reload-plugins
```

The reload command applies the plugin in the current session. Then ask Claude to
connect Plori. It follows the bundled skill and shows a short pairing code when the
client supports it. Open the verification page on your computer or phone, sign in,
and approve the connection. Running an agent spends your prepaid balance.

For installation from a shell, run:

```sh
claude plugin marketplace add plori-ai/claude-plugin && claude plugin install plori@plori --scope user
```

Then type `/reload-plugins` in the Claude Code conversation.

## Connect without installing a plugin

Paste this into your Claude Code conversation:

> Read https://plori.ai/.well-known/agent-skills/plori/SKILL.md and install/connect Plori over MCP.

Claude reads the setup instructions and configures MCP if needed. If the new server
has not loaded, type `/reload-plugins` when Claude asks, then continue in the same
conversation. With pairing, open the short address Claude shows, enter the code,
sign in, and approve. You can use a phone while Claude Code runs on a remote machine.
No installed skill or plugin is required.

Other MCP clients keep their ordinary OAuth or API-key authentication. See the
[connection guide](https://plori.ai/mcp) for per-client setup.

## What is inside

```
.claude-plugin/marketplace.json     # this marketplace, lists the plori plugin
plugins/plori/
  .claude-plugin/plugin.json        # the plugin manifest
  .mcp.json                         # remote MCP server (api.plori.ai/mcp)
  skills/plori/SKILL.md             # the plori skill
```

Nothing here runs local code or installs third-party software: the plugin only points
Claude Code at the hosted plori MCP server and adds the skill text.

## Links

- Site: https://plori.ai
- MCP connect guide: https://plori.ai/mcp
- Integration front door: https://plori.ai/agents.md
- CLI on npm: https://www.npmjs.com/package/@plori/cli
- Questions: dev@plori.ai

## License

MIT
