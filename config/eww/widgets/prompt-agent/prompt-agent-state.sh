#!/usr/bin/env bash
set -euo pipefail

STATE_FILE="/tmp/eww-prompt-agent-${UID}.state"

if [[ -r "$STATE_FILE" ]]; then
  read -r state < "$STATE_FILE" || state="idle"
else
  state="idle"
fi

case "$state" in
  talking) printf 'TALKING\n' ;;
  *) printf 'IDLE\n' ;;
esac
