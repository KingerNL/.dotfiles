#!/usr/bin/env bash
set -euo pipefail

OUTDIR="${XDG_PICTURES_DIR:-$HOME/Pictures}/screenshots"
RUNDIR="${XDG_RUNTIME_DIR:-/tmp}"
mkdir -p -- "$OUTDIR"

need() {
  command -v "$1" >/dev/null 2>&1 || { printf 'Missing: %s\n' "$1" >&2; exit 1; }
}

have() {
  command -v "$1" >/dev/null 2>&1
}

cleanup() {
  [[ -n "${FIFO_PATH:-}" ]] && rm -f -- "$FIFO_PATH" 2>/dev/null || true
  if [[ -n "${SATYY_PID:-}" ]]; then
    kill "$SATYY_PID" 2>/dev/null || true
  fi
}
trap cleanup EXIT

need hyprshot
need satty
need mkfifo

ts="$(date '+%Y%m%d-%H%M%S')"
out="$OUTDIR/satty-$ts.png"
FIFO_PATH="$RUNDIR/satty-$ts.fifo"

mkfifo -- "$FIFO_PATH"

# Start satty reading the image from stdin (the FIFO)
satty --filename - --output-filename "$out" <"$FIFO_PATH" &
SATYY_PID=$!

# Capture (Esc cancels: hyprshot exits nonzero -> we quit cleanly)
if have wl-copy; then
  hyprshot --freeze -m region --raw | tee >(wl-copy --type image/png) >"$FIFO_PATH" || exit 0
else
  hyprshot --freeze -m region --raw >"$FIFO_PATH" || exit 0
fi

# Close the FIFO so satty sees EOF after the image is delivered
rm -f -- "$FIFO_PATH"
FIFO_PATH=""

# Wait until the user saves from satty (Ctrl+S) and then close satty automatically
prev_size=""
stable_ticks=0

while kill -0 "$SATYY_PID" 2>/dev/null; do
  if [[ -s "$out" ]]; then
    size="$(stat -c '%s' -- "$out" 2>/dev/null || true)"
    if [[ -n "$size" && "$size" == "$prev_size" ]]; then
      stable_ticks=$((stable_ticks + 1))
    else
      stable_ticks=0
      prev_size="$size"
    fi

    # Size stable for ~0.4s -> assume write finished
    if (( stable_ticks >= 2 )); then
      kill "$SATYY_PID" 2>/dev/null || true
      break
    fi
  fi
  sleep 0.2
done

wait "$SATYY_PID" 2>/dev/null || true

