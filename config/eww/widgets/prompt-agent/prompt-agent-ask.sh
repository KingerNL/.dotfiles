#!/usr/bin/env bash
set -euo pipefail

prompt=${*:-}
prompt=${prompt//$'\n'/ }

STATE_FILE="/tmp/eww-prompt-agent-${UID}.state"
RESPONSE_FILE="/tmp/eww-prompt-agent-${UID}.response"
LOCK_DIR="/tmp/eww-prompt-agent-${UID}.lock"
OPENCODE="${OPENCODE:-$HOME/.opencode/bin/opencode}"
PERSONA_FILE="$HOME/.config/eww/widgets/prompt-agent/pigma-persona.txt"
STREAM_FILTER="$HOME/.config/eww/widgets/prompt-agent/prompt-agent-stream-filter.py"

if [[ -z "${prompt// }" ]]; then
  exit 0
fi

if ! mkdir "$LOCK_DIR" 2>/dev/null; then
  printf 'Pigma is still talking.\n' > "$RESPONSE_FILE"
  exit 0
fi

printf 'talking\n' > "$STATE_FILE"
printf 'Thinking.\n' > "$RESPONSE_FILE"

(
  trap 'printf "idle\n" > "$STATE_FILE"; rmdir "$LOCK_DIR" 2>/dev/null || true' EXIT

  if [[ ! -x "$OPENCODE" ]]; then
    OPENCODE=$(command -v opencode || true)
  fi

  if [[ -z "$OPENCODE" || ! -x "$OPENCODE" ]]; then
    printf 'opencode unavailable\n' > "$RESPONSE_FILE"
    exit 0
  fi

  persona=""
  if [[ -r "$PERSONA_FILE" ]]; then
    persona=$(<"$PERSONA_FILE")
  fi

  "$OPENCODE" run --dir "$HOME" "$persona

Operational constraints:
- Do not modify files.
- Do not run tools unless absolutely necessary.
- Answer the user's prompt directly.

User asks: $prompt" 2>&1 | "$STREAM_FILTER" "$RESPONSE_FILE" || true
) >/dev/null 2>&1 &
