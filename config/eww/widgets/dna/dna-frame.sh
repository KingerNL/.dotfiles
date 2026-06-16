#!/usr/bin/env bash
set -euo pipefail

FRAMES_DIR="$HOME/ZAPP/ZAPP/config/eww/scripts/animations/dna/frames"
FRAME_DELAY_MS=90
FRAME_COUNT=91

now_us=${EPOCHREALTIME/.}
frame_index=$(( (10#$now_us / 1000 / FRAME_DELAY_MS) % FRAME_COUNT + 1 ))
frame_path=$(printf '%s/%04d' "$FRAMES_DIR" "$frame_index")

if [ ! -r "$frame_path" ]; then
  exit 0
fi

sed 's/[ ⠀]*$//' "$frame_path"
