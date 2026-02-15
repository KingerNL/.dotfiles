#!/usr/bin/env bash
set -euo pipefail

require_cmd() {
  local cmd="$1"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Error: Required command '$cmd' not found in PATH." >&2
    exit 1
  fi
}

require_cmd rofi
require_cmd awk

if ! command -v wl-copy >/dev/null 2>&1 && ! command -v xclip >/dev/null 2>&1; then
  echo "Warning: Neither wl-copy nor xclip found; clipboard copy will fall back to stdout." >&2
fi

# Handle command line arguments
if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  echo "Nerd Font Rofi Picker"
  echo "A simple rofi-based picker for Nerd Font icons."
  echo ""
  echo "Usage: $(basename "$0") [options]"
  echo ""
  echo "Options:"
  echo "  --help      Show this help message"
  echo "  --update    Force update Nerd Font data"
  echo ""
  echo "Keybindings:"
  echo "  Enter       Copy selected icon(s) (Glyph) and exit"
  echo "  Alt+n       Copy Name (e.g., nf-fa-home)"
  echo "  Alt+h       Copy Hex Code (e.g., f015)"
  echo "  Alt+c       Copy CSS Class (e.g., .nf-fa-home)"
  echo "  Left/Right  Navigate between columns"
  echo "  Ctrl+b      Move cursor backward"
  echo "  Ctrl+f      Move cursor forward"
  echo "  Esc         Exit"
  echo ""
  echo "Repository: https://github.com/aaronedev/nerdfont-icon-rofi-picker"
  exit 0
fi

if [[ "${1:-}" == "--update" ]]; then
  echo "Force updating NerdFont data..."
  FORCE_UPDATE=true
  shift
else
  FORCE_UPDATE=false
fi

# CONFIG: Paths and settings
get_script_dir() {
  local script_path="${BASH_SOURCE[0]}"
  if command -v readlink >/dev/null 2>&1; then
    if SCRIPT_REALPATH=$(readlink -f "$script_path" 2>/dev/null); then
      script_path="$SCRIPT_REALPATH"
    fi
  fi
  while [ -h "$script_path" ]; do
    local script_dir="$(cd -P "$(dirname "$script_path")" && pwd)"
    script_path="$(readlink "$script_path")"
    [[ $script_path != /* ]] && script_path="$script_dir/$script_path"
  done
  echo "$(cd -P "$(dirname "$script_path")" && pwd)"
}

# CONFIG: Paths and settings
SCRIPT_DIR=$(get_script_dir)
DATA_DIR="$SCRIPT_DIR/data"
NERD_TXT_FILE="$DATA_DIR/nerdfont.txt"
CACHE_DIR="$HOME/.cache/nerd-rofi"
PROCESSED_CACHE="$CACHE_DIR/nerdfont_processed.txt"
STYLE_FILE="$SCRIPT_DIR/nerd_rofi_picker.rasi"
# STYLE_FILE="$HOME/.config/rofi/config.rasi"
CONFIG_FILE="$SCRIPT_DIR/rofi_config"
mkdir -p "$CACHE_DIR"

# Initialize or update submodule if needed
DATA_URL="https://raw.githubusercontent.com/8bitmcu/NerdFont-Cheat-Sheet/master/nerdfont.txt"

download_data() {
  echo "Downloading NerdFont data from upstream..."
  mkdir -p "$DATA_DIR"
  if command -v curl >/dev/null 2>&1; then
    curl -fLo "$NERD_TXT_FILE" "$DATA_URL"
  elif command -v wget >/dev/null 2>&1; then
    wget -O "$NERD_TXT_FILE" "$DATA_URL"
  else
    return 1
  fi
}

if [ ! -f "$NERD_TXT_FILE" ]; then
  # Try git submodule first if available
  if [ -d "$SCRIPT_DIR/.git" ] && command -v git >/dev/null 2>&1; then
    echo "Initializing NerdFont data submodule..."
    (cd "$SCRIPT_DIR" && git submodule update --init --recursive) || true
  fi

  # Fallback to direct download
  if [ ! -f "$NERD_TXT_FILE" ]; then
    if ! download_data; then
      echo "Error: NerdFont data missing. Clone recursively or install curl/wget to download." >&2
      exit 1
    fi
  fi
fi

# Check if we should update (once every 7 days)
LAST_UPDATE_FILE="$CACHE_DIR/last_update"
SHOULD_UPDATE=false

if [ ! -f "$LAST_UPDATE_FILE" ] || [ $(($(date +%s) - $(cat "$LAST_UPDATE_FILE" 2>/dev/null || echo 0))) -gt $((7 * 24 * 3600)) ]; then
  SHOULD_UPDATE=true
fi

if [ "$SHOULD_UPDATE" = true ] || [ "$FORCE_UPDATE" = true ]; then
  echo "Checking for NerdFont data updates..."
  UPDATED=false

  if [ -d "$SCRIPT_DIR/.git" ] && command -v git >/dev/null 2>&1; then
    if (cd "$SCRIPT_DIR" && git submodule update --remote --merge data 2>/dev/null); then
      UPDATED=true
    fi
  fi

  if [ "$UPDATED" = false ]; then
    if download_data; then
      UPDATED=true
    fi
  fi

  if [ "$UPDATED" = true ]; then
    date +%s >"$LAST_UPDATE_FILE"
    rm -f "$PROCESSED_CACHE"
  else
    echo "Warning: Failed to update NerdFont data, using existing version" >&2
  fi
fi

if [ ! -f "$NERD_TXT_FILE" ]; then
  echo "Critical: Nerd Font data missing." >&2
  exit 1
fi

# Pre-process data for better performance if not already done
if [ ! -f "$PROCESSED_CACHE" ] || [ "$NERD_TXT_FILE" -nt "$PROCESSED_CACHE" ]; then
  echo "Processing NerdFont data for better performance..."
  awk '{
    glyph = $1
    $1 = ""
    desc = $0
    gsub(/^[ \t]+/, "", desc)
    # Add consistent spacing to handle double-width icons
    printf "%-4s %s\n", glyph, desc
  }' "$NERD_TXT_FILE" >"$PROCESSED_CACHE"
fi

# Determine optimal lines based on terminal height
LINES=$(($(tput lines 2>/dev/null || echo 40) / 2))
LINES=$((LINES > 15 ? LINES : 15))
LINES=$((LINES < 40 ? LINES : 40))

# Show via rofi with isolated configuration
ROFI_ARGS=(
  -dmenu
  -i
  -lines "$LINES"
  -p "󰣇 "
  -matching fuzzy
  -sort
  -no-custom
  -format "s"
  -markup-rows
  -kb-row-left "Left"
  -kb-row-right "Right"
  -kb-move-char-back "Control+b"
  -kb-move-char-forward "Control+f"
  -kb-custom-1 "Alt+n"
  -kb-custom-2 "Alt+h"
  -kb-custom-3 "Alt+c"
  # -no-config  # Skip system config to avoid theme conflicts
)

# Use isolated config and theme files
if [ -f "$CONFIG_FILE" ]; then
  ROFI_ARGS+=(-config "$CONFIG_FILE")
fi

if [ -f "$STYLE_FILE" ]; then
  ROFI_ARGS+=(-theme "$STYLE_FILE")
fi

# Run rofi with clean environment to avoid config conflicts
declare -a CLEAN_ENV=()
declare -A CLEAN_ENV_SEEN=()

add_env_var() {
  local name="$1"
  local value="${2-}"
  if [[ -n "${CLEAN_ENV_SEEN[$name]:-}" ]]; then
    return
  fi
  CLEAN_ENV+=("$name=$value")
  CLEAN_ENV_SEEN[$name]=1
}

add_env_var HOME "${HOME-}"
add_env_var PATH "${PATH-}"
add_env_var DISPLAY "${DISPLAY-}"
add_env_var WAYLAND_DISPLAY "${WAYLAND_DISPLAY-}"
add_env_var XDG_RUNTIME_DIR "${XDG_RUNTIME_DIR-}"

add_env_var LANG "${LANG-}"
add_env_var LC_ALL "${LC_ALL-}"
add_env_var LC_CTYPE "${LC_CTYPE-}"

while IFS= read -r env_name; do
  [[ $env_name == LC_* ]] || continue
  add_env_var "$env_name" "${!env_name-}"
done < <(compgen -e)

set +e
CHOICE=$(cat "$PROCESSED_CACHE" | env -i "${CLEAN_ENV[@]}" rofi "${ROFI_ARGS[@]}")
ROFI_STATUS=$?
set -e

# Exit code 10 = custom-1 (Alt+n), 11 = custom-2 (Alt+h), 12 = custom-3 (Alt+c)
# Standard success = 0

if [[ $ROFI_STATUS -ne 0 && $ROFI_STATUS -ne 10 && $ROFI_STATUS -ne 11 && $ROFI_STATUS -ne 12 ]]; then
  exit 1
fi

# Extract glyphs and descriptions based on selection
FINAL_TEXT=""
DESC=""

case "$ROFI_STATUS" in
0) # Enter -> Glyph
  FINAL_TEXT=$(awk '{printf "%s", $1}' <<<"$CHOICE")
  DESC=$(awk '{$1=""; sub(/^ /,""); print}' <<<"$CHOICE" | paste -sd ", " -)
  ;;
10) # Alt+n -> Name
  # Extract name parts and join with hyphens
  # Input: "    nf fa fa" -> Output: "nf-fa-fa"
  FINAL_TEXT=$(awk '{
      s = ""
      for (i=2; i<=NF; i++) s = s (i==2 ? "" : "-") $i
      print s
    }' <<<"$CHOICE" | paste -sd " " -)
  DESC="Names: $FINAL_TEXT"
  ;;
11) # Alt+h -> Hex
  # We use python3 for reliable unicode->hex conversion if available
  FINAL_TEXT=""
  if command -v python3 >/dev/null 2>&1; then
    while IFS= read -r line; do
      glyph=$(echo "$line" | awk '{print $1}')
      # Convert char to hex code point
      code=$(python3 -c "print(f'{ord(\"$glyph\"):x}')")
      FINAL_TEXT+="${code} "
    done <<<"$CHOICE"
  else
    # Fallback: Just return names and warn
    FINAL_TEXT=$(awk '{
          s = ""
          for (i=2; i<=NF; i++) s = s (i==2 ? "" : "-") $i
          print s
       }' <<<"$CHOICE" | paste -sd " " -)
    DESC="Warning: Python3 missing for Hex. Copied Names: $FINAL_TEXT"
  fi
  FINAL_TEXT=${FINAL_TEXT%" "} # Trim trailing space
  [ -z "$DESC" ] && DESC="Hex: $FINAL_TEXT"
  ;;
12) # Alt+c -> CSS Class
  # Join with hyphens and prepend dot
  FINAL_TEXT=$(awk '{
      s = ""
      for (i=2; i<=NF; i++) s = s (i==2 ? "" : "-") $i
      print "."s
    }' <<<"$CHOICE" | paste -sd " " -)
  DESC="CSS: $FINAL_TEXT"
  ;;
esac

# Function to copy text to the system clipboard
copy_to_clipboard() {
  local text="$1"
  if command -v wl-copy >/dev/null 2>&1; then
    printf "%s" "$text" | wl-copy
  elif command -v xclip >/dev/null 2>&1; then
    printf "%s" "$text" | xclip -selection clipboard
  else
    echo "Warning: wl-copy and xclip not found; falling back to stdout." >&2
    printf "%s\n" "$text"
    CLIPBOARD_FALLBACK=1
  fi
}

copy_to_clipboard "$FINAL_TEXT"

if [[ ${CLIPBOARD_FALLBACK:-0} -eq 1 ]]; then
  echo "Copied (stdout fallback): $DESC"
else
  echo "Copied: $DESC"
fi
exit 0
