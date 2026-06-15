#!/usr/bin/env bash
set -euo pipefail

RESPONSE_FILE="/tmp/eww-falcon-${UID}.response"
STATE_FILE="/tmp/eww-falcon-${UID}.state"

state="idle"
if [[ -r "$STATE_FILE" ]]; then
  read -r state < "$STATE_FILE" || state="idle"
fi

if [[ "$state" == "talking" ]]; then
  case $(( ($(date +%s%3N) / 500) % 3 )) in
    0) printf 'Thinking.\n' ;;
    1) printf 'Thinking..\n' ;;
    *) printf 'Thinking...\n' ;;
  esac
  exit 0
fi

if [[ -s "$RESPONSE_FILE" ]]; then
  fold -s -w 46 "$RESPONSE_FILE" | sed -n '1,8p'
else
  printf 'Ask Pigma.\n'
fi
