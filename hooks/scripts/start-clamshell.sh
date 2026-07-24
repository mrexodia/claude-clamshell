#!/bin/bash
# start-clamshell.sh - start caffeinate if not already running
INPUT=$(cat)
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id')

if [ -z "$SESSION_ID" ]; then
  exit 0
fi

CPID=$(cat "/tmp/claude-clamshell-${SESSION_ID}.cpid" 2>/dev/null)
PIDFILE="/tmp/claude-clamshell-${SESSION_ID}.pid"

if [ -n "$CPID" ] && { [ ! -f "$PIDFILE" ] || ! kill -0 "$(cat "$PIDFILE")" 2>/dev/null; }; then
  nohup caffeinate -d -s -w "$CPID" >/dev/null 2>&1 &
  echo $! > "$PIDFILE"
fi

exit 0