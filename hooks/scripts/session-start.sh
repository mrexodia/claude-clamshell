#!/bin/bash
# session-start.sh - find the Claude Code process and cache its PID
INPUT=$(cat)
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id')

if [ -z "$SESSION_ID" ]; then
  exit 0
fi

pid=$PPID
while [ "$pid" -gt 1 ] 2>/dev/null; do
  if ps -p "$pid" -o args= 2>/dev/null | grep -q claude; then
    echo "$pid" > "/tmp/claude-clamshell-${SESSION_ID}.cpid"
    exit 0
  fi
  pid=$(ps -o ppid= -p "$pid" 2>/dev/null | tr -d ' ')
done

exit 0