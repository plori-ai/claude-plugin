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
- **A background monitor** (`monitors/monitors.json`): tells Claude when one of your
  runs finishes or pauses for an answer, without you asking. See
  [Background runs](#background-runs).

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

## Background runs

A plori run often takes longer than the tool call that started it. Two parts of this
plugin deal with that.

### The run monitor

The plugin declares one background monitor, `plori-runs`. It runs
`plori watch --events terminal,input`, and Claude Code delivers one JSON line to Claude
for every run on your account that ended or paused for a human answer:

```json
{"event":"run.completed","status":"completed","run_id":"…","agent_name":"mate","url":"https://plori.ai/agent/…"}
{"event":"run.awaiting_input","status":"awaiting_input","run_id":"…","pending_inputs":[{"tool_call_id":"…","kind":"approval","prompt":"…"}]}
```

On a `run.completed`, `run.error`, or `run.cancelled` line, Claude reads the reply with
`get_run_result` (or `plori result <agent> <run-id>`). On a `run.awaiting_input` line,
Claude shows you the request and sends your decision with `answer_pending_input` (or
`plori answer <run-id> <tool-call-id> --approve`).

The monitor needs the plori CLI, version 0.4.0 or later:

```sh
curl -fsSL https://plori.ai/install.sh | sh
plori login
```

Without the CLI on `PATH`, or without stored credentials, the monitor writes one line
to stderr and exits; nothing else about the plugin changes. Monitors run only in
interactive Claude Code CLI sessions, and they run unsandboxed at the same trust level
as hooks.

### Two timeout settings

`.mcp.json` sets `"timeout": 1800000` for the plori server. One `invoke_agent` or
`get_run_result` call may then run for up to 30 minutes, which matches how long the
server holds a call open. A per-server timeout of at least 1000 also raises that
server's idle window to the same value, so a run that sends no progress for five
minutes no longer aborts the call. This field needs Claude Code 2.1.203 or later.

Claude Code moves an MCP call that is still running after two minutes into a
background task, so a long call stops blocking the conversation. To move calls sooner,
set `CLAUDE_CODE_MCP_AUTO_BACKGROUND_MS` in `~/.claude/settings.json`:

```json
{
  "env": {
    "CLAUDE_CODE_MCP_AUTO_BACKGROUND_MS": "20000"
  }
}
```

The plugin cannot set that for you: a plugin's `settings.json` supports only the
`agent` and `subagentStatusLine` keys. Automatic backgrounding needs Claude Code
2.1.212 or later.

## What is inside

```
.claude-plugin/marketplace.json     # this marketplace, lists the plori plugin
plugins/plori/
  .claude-plugin/plugin.json        # the plugin manifest
  .mcp.json                         # remote MCP server (api.plori.ai/mcp), 30-minute tool timeout
  skills/plori/SKILL.md             # the plori skill
  monitors/monitors.json            # the plori-runs background monitor
  scripts/plori-watch.sh            # what that monitor runs
```

The plugin installs no third-party software. It points Claude Code at the hosted plori
MCP server, adds the skill text, and runs one shell script that calls the plori CLI you
installed yourself. That script starts nothing when the CLI is missing.

## Links

- Site: https://plori.ai
- MCP connect guide: https://plori.ai/mcp
- Integration front door: https://plori.ai/agents.md
- CLI on npm: https://www.npmjs.com/package/@plori/cli
- Questions: dev@plori.ai

## License

MIT
