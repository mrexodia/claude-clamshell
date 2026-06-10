# Claude Clamshell

Prevents your Mac from sleeping while Claude Code is actively working. Close the lid and walk away - your Mac stays awake during Claude's turn and sleeps when it's waiting for your input.

## Requirements

- macOS 15+ (uses the built-in `caffeinate` and `jq` commands)
- Claude Code

## Installation

```bash
claude plugin marketplace add mrexodia/claude-marketplace
claude plugin install claude-clamshell@mrexodia
```

## How it works

Four lifecycle hooks coordinate `caffeinate`:

| Hook | What it does |
|---|---|
| **SessionStart** | Walks the process tree to find the Claude Code PID and caches it |
| **UserPromptSubmit** | Starts `caffeinate -s -w <claude-pid>` at the beginning of every turn |
| **Stop** | Kills caffeinate when Claude finishes, so your Mac can sleep between turns |
| **StopFailure** | Same cleanup when a turn ends due to an API error |

The `-w <claude-pid>` flag is a safety net: if Claude Code crashes, is force-killed, or exits unexpectedly, `caffeinate` dies automatically because the watched PID no longer exists. No orphan processes, no stale PID files.

## Notes

- Multiple Claude Code instances are handled via per-session PID files (`/tmp/claude-clamshell-<session-id>.pid`)
- The `-s` flag on caffeinate prevents system sleep (keeps the system awake even on AC power with the lid closed)
- Worst case on unclean exit: your Mac stays awake until the caffeinate process notices Claude's PID is gone, which is near-instant
- When Claude Code runs background processes the `Stop` will not kill caffeinate until after they finish
