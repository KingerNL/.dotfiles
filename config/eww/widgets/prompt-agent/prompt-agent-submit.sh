#!/usr/bin/env bash
set -euo pipefail

BASE="$HOME/.config/eww/widgets/prompt-agent"
EWW="${EWW:-$HOME/.local/bin/eww}"
CONFIG="$HOME/.config/eww"
prompt=${*:-}

"$BASE/prompt-agent-ask.sh" "$prompt"
"$EWW" --force-wayland -c "$CONFIG" update PROMPT_AGENT_INPUT="" >/dev/null 2>&1 || true
