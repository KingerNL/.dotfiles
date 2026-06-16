#!/usr/bin/env bash
set -euo pipefail

state_file="/tmp/eww-proc-radar-${UID}.mode"
mode=${1:-}

case "$mode" in
  cpu|mem) printf '%s\n' "$mode" > "$state_file" ;;
  *)
    current="cpu"
    if [[ -r "$state_file" ]]; then
      read -r current < "$state_file" || current="cpu"
    fi

    if [[ "$current" == "mem" ]]; then
      printf 'cpu\n' > "$state_file"
    else
      printf 'mem\n' > "$state_file"
    fi
    ;;
esac
