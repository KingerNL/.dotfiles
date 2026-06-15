#!/usr/bin/env bash
set -euo pipefail

state_file="/tmp/eww-proc-radar-${UID}.mode"

if [[ -r "$state_file" ]]; then
  read -r mode < "$state_file" || mode="cpu"
else
  mode="cpu"
fi

case "$mode" in
  mem) printf 'MEM\n' ;;
  *) printf 'CPU\n' ;;
esac
