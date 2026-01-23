#!/usr/bin/env bash
set -euo pipefail

OUTDIR="${XDG_PICTURES_DIR:-$HOME/Pictures}/screenshots"
TMPDIR="${XDG_RUNTIME_DIR:-/tmp}"
mkdir -p "$OUTDIR"

need() {
  command -v "$1" >/dev/null 2>&1 || { echo "Missing: $1" >&2; exit 1; }
}

need hyprshot
need satty

ts="$(date '+%Y%m%d-%H%M%S')"
out="$OUTDIR/satty-$ts.png"
tmp="$TMPDIR/hyprshot-$ts.png"

# Take region screenshot to a temp file (Esc cancels → nonzero)
hyprshot --freeze -m region -o "$TMPDIR" >/dev/null 2>&1 || exit 0

# Find the newest hyprshot file in TMPDIR (since hyprshot controls name)
shot_path="$(ls -t "$TMPDIR"/* 2>/dev/null | head -n 1 || true)"
[[ -n "${shot_path:-}" && -f "$shot_path" ]] || exit 0

# Run satty, saving to final output. Close satty as soon as the file is created.
satty --filename "$shot_path" --output-filename "$out" &
pid=$!

while kill -0 "$pid" 2>/dev/null; do
  if [[ -s "$out" ]]; then
    kill "$pid" 2>/dev/null || true
    break
  fi
  sleep 0.2
done

wait "$pid" 2>/dev/null || true

# Clean up the temp capture
rm -f -- "$shot_path"

