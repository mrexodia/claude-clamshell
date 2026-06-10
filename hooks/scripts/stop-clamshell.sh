#!/bin/bash
# stop-clamshell.sh - kill caffeinate when Claude finishes a turn,
# but only if there are no background tasks still running.
INPUT=$(cat)
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id')

if [ -z "$SESSION_ID" ]; then
  exit 0
fi

# If background tasks are active, keep caffeinate alive
BG_COUNT=$(echo "$INPUT" | jq -r '.background_tasks | length // 0')
if [ "$BG_COUNT" -gt 0 ]; then
  exit 0
fi

PIDFILE="/tmp/claude-caffeinate-${SESSION_ID}.pid"

if [ -f "$PIDFILE" ]; then
  kill "$(cat "$PIDFILE")" 2>/dev/null
  rm -f "$PIDFILE"
fi

exit 0