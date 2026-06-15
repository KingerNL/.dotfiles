#!/usr/bin/env bash
set -euo pipefail

BASE="$HOME/.config/eww-background/widgets/falcon"
EWW="${EWW:-$HOME/.local/bin/eww}"
CONFIG="$HOME/.config/eww-background"
prompt=${*:-}

"$BASE/falcon-ask.sh" "$prompt"
"$EWW" --force-wayland -c "$CONFIG" update FALCON_INPUT="" >/dev/null 2>&1 || true
