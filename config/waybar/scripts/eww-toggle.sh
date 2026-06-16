#!/usr/bin/env bash
set -euo pipefail

EWW="${EWW:-$HOME/.local/bin/eww}"
CONFIG="$HOME/.config/eww"
WINDOW="desktop-widget"
STATE_FILE="/tmp/eww-${UID}.state"

json_escape() {
  local value=${1:-}
  value=${value//\\/\\\\}
  value=${value//"/\\"}
  value=${value//$'\n'/\\n}
  printf '%s' "$value"
}

get_state() {
  if [[ -r "$STATE_FILE" ]]; then
    read -r state < "$STATE_FILE" || state="on"
  else
    state="on"
  fi

  case "$state" in
    off) printf 'off\n' ;;
    *) printf 'on\n' ;;
  esac
}

set_state() {
  printf '%s\n' "$1" > "$STATE_FILE"
}

status() {
  local text tooltip class

  if [[ "$(get_state)" == "on" ]]; then
    text="󰕮"
    tooltip=$'Eww widgets: on\nleft: hide\nright: reload/reset'
    class="on"
  else
    text="󰜬"
    tooltip=$'Eww widgets: off\nleft: show\nright: reload/reset'
    class="off"
  fi

  printf '{"text":"%s","tooltip":"%s","class":"%s"}\n' \
    "$(json_escape "$text")" \
    "$(json_escape "$tooltip")" \
    "$(json_escape "$class")"
}

case "${1:-status}" in
  status)
    status
    ;;
  toggle)
    if [[ "$(get_state)" == "on" ]]; then
      "$EWW" --force-wayland -c "$CONFIG" close "$WINDOW" >/dev/null 2>&1 || true
      "$EWW" --force-wayland -c "$CONFIG" kill >/dev/null 2>&1 || true
      set_state off
    else
      "$EWW" --force-wayland -c "$CONFIG" daemon >/dev/null 2>&1 || true
      "$EWW" --force-wayland -c "$CONFIG" open "$WINDOW" >/dev/null 2>&1 || true
      set_state on
    fi
    ;;
  reload|reset)
    "$CONFIG/reload.sh" >/dev/null 2>&1 || true
    set_state on
    ;;
  *)
    status
    ;;
esac
