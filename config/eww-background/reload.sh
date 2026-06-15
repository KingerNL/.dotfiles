#!/usr/bin/env bash
set -euo pipefail

EWW="${EWW:-$HOME/.local/bin/eww}"
CONFIG="$HOME/.config/eww-background"
STATE_FILE="/tmp/eww-background-${UID}.state"

"$EWW" --force-wayland -c "$CONFIG" daemon >/dev/null 2>&1 || true
"$EWW" --force-wayland -c "$CONFIG" close desktop-widget >/dev/null 2>&1 || true
"$EWW" --force-wayland -c "$CONFIG" close hippo-widget >/dev/null 2>&1 || true
"$EWW" --force-wayland -c "$CONFIG" reload >/dev/null 2>&1 || true
"$EWW" --force-wayland -c "$CONFIG" open desktop-widget
printf 'on\n' > "$STATE_FILE"
