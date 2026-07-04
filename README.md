# plori Claude Code plugin

A one-install plugin for [plori](https://plori.ai): cloud computers for AI agents, with
persistent disks, real tools, and memory that survives between sessions.

Installing this plugin gives Claude Code two things at once:

- **The plori MCP server** (`.mcp.json`): the remote server at `https://api.plori.ai/mcp`,
  so `create_agent`, `invoke_agent`, `schedule_run`, and the rest become tools in your
  session. Authentication is OAuth 2.1 (sign in once with an email code) or an API key.
- **The plori skill** (`skills/plori/SKILL.md`): teaches Claude how to connect, create
  agents, invoke them and read replies, answer human-in-the-loop requests, and schedule
  deferred runs. Its content is the same one served at
  `https://plori.ai/.well-known/agent-skills/plori/SKILL.md`.

## Install

From the official directory (auto-available in Claude Code):

```
/plugin install plori@plori
```

Or add this marketplace directly, then install:

```
/plugin marketplace add plori-ai/claude-plugin
/plugin install plori@plori
```

The first call to a plori tool triggers the OAuth sign-in; or set `PLORI_API_KEY` for a
key-based flow. Running an agent spends credits on your plori account.

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
