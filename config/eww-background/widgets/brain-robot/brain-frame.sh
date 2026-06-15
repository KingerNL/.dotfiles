#!/usr/bin/env bash
set -euo pipefail

FRAMES_DIR="$HOME/.config/eww-background/widgets/brain-robot/brain-frames"
FRAME_DELAY_MS=60
FRAME_COUNT=160

now_us=${EPOCHREALTIME/.}
frame_index=$(( (10#$now_us / 1000 / FRAME_DELAY_MS) % FRAME_COUNT + 1 ))
frame_path=$(printf '%s/%04d' "$FRAMES_DIR" "$frame_index")

if [[ ! -r "$frame_path" ]]; then
  printf 'BRAIN\nUNAVAILABLE\n'
  exit 0
fi

cat "$frame_path"
