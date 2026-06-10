#!/bin/bash
# session-end.sh - clean up all temp files
INPUT=$(cat)
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id')

if [ -z "$SESSION_ID" ]; then
  exit 0
fi

# Kill caffeinate if still running (safety net)
PIDFILE="/tmp/claude-clamshell-${SESSION_ID}.pid"
if [ -f "$PIDFILE" ]; then
  kill "$(cat "$PIDFILE")" 2>/dev/null
  rm -f "$PIDFILE"
fi

# Clean up cached Claude PID
rm -f "/tmp/claude-clamshell-${SESSION_ID}.cpid"

exit 0