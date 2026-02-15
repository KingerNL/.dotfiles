#!/usr/bin/env bash
set -u

CONFIG_FILE="$HOME/.config/waybar/scripts/cava_config.conf"

bars="▁▂▃▅▆▇"
dict='s/;//g;'
for ((i=0; i<${#bars}; i++)); do
  dict+="s/$i/${bars:i:1}/g;"
done

wait_for_audio() {
  # pipewire-pulse exposes pactl; this becomes ready slightly after login sometimes
  for _ in {1..80}; do
    if command -v pactl >/dev/null 2>&1 && pactl info >/dev/null 2>&1; then
      return 0
    fi
    sleep 0.25
  done
  return 1
}

# Don’t die if audio isn’t ready yet
wait_for_audio || true

# Keep trying forever; if cava crashes early, restart it.
while true; do
  /usr/bin/cava -p "$CONFIG_FILE" 2>/tmp/waybar-cava.err | sed -u "$dict"
  sleep 1
done

