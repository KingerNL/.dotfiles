#!/usr/bin/env bash
set -euo pipefail

BASE="$HOME/.config/eww/widgets/prompt-agent"
FRAMES_DIR="$BASE/frames"
IDLE_FRAME="$BASE/idle"
STATE_FILE="/tmp/eww-prompt-agent-${UID}.state"
FRAME_DELAY_MS=40
FRAME_COUNT=22

state="idle"
if [[ -r "$STATE_FILE" ]]; then
  read -r state < "$STATE_FILE" || state="idle"
fi

if [[ "$state" != "talking" ]]; then
  cat "$IDLE_FRAME"
  exit 0
fi

now_us=${EPOCHREALTIME/.}
frame_index=$(( (10#$now_us / 1000 / FRAME_DELAY_MS) % FRAME_COUNT + 1 ))
frame_path=$(printf '%s/%04d' "$FRAMES_DIR" "$frame_index")

if [[ -r "$frame_path" ]]; then
  cat "$frame_path"
else
  cat "$IDLE_FRAME"
fi
