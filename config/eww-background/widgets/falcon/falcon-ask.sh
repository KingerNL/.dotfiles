#!/usr/bin/env bash
set -euo pipefail

prompt=${*:-}
prompt=${prompt//$'\n'/ }

STATE_FILE="/tmp/eww-falcon-${UID}.state"
RESPONSE_FILE="/tmp/eww-falcon-${UID}.response"
LOCK_DIR="/tmp/eww-falcon-${UID}.lock"
OPENCODE="${OPENCODE:-$HOME/.opencode/bin/opencode}"
PERSONA_FILE="$HOME/.config/eww-background/widgets/falcon/pigma-persona.txt"

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

  answer=$("$OPENCODE" run --dir "$HOME" "$persona

Operational constraints:
- Do not modify files.
- Do not run tools unless absolutely necessary.
- Answer the user's prompt directly.

User asks: $prompt" 2>&1 || true)

  if [[ -z "${answer// }" ]]; then
    answer="No response."
  fi

  printf '%s\n' "$answer" \
    | sed -r 's/\x1B\[[0-9;?]*[ -\/]*[@-~]//g' \
    | sed -E '/^[[:space:]]*>[[:space:]]*(build|plan|ask|run)[[:space:]]*(·|\\.)?[[:space:]]*/Id; /^[[:space:]]*$/d' \
    > "$RESPONSE_FILE"
) >/dev/null 2>&1 &
