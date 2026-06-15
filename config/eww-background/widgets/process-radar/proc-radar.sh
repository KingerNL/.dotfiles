#!/usr/bin/env bash
set -euo pipefail

state_file="/tmp/eww-proc-radar-${UID}.mode"
cache_seconds=4
mode="cpu"

if [[ -r "$state_file" ]]; then
  read -r mode < "$state_file" || mode="cpu"
fi

normalize_name() {
  local comm=${1,,}

  case "$comm" in
    *isolated*web*co*) comm="zen-web" ;;
    zen-bin) comm="zen" ;;
  esac

  printf '%s' "$comm"
}

cache_file="/tmp/eww-proc-radar-${UID}.${mode}.cache"
cache_tmp="${cache_file}.$$"
now=$(date +%s)

if [[ -r "$cache_file" ]]; then
  cache_mtime=$(stat -c %Y "$cache_file" 2>/dev/null || printf '0')
  if (( now - cache_mtime < cache_seconds )); then
    while IFS= read -r line; do
      printf '%s\n' "$line"
    done < "$cache_file"
    exit 0
  fi
fi

if [[ "$mode" == "mem" ]]; then
  {
    count=0
    while read -r mem comm; do
      [[ -n "${comm:-}" ]] || continue
      [[ "$comm" == "ps" ]] && continue
      comm=$(normalize_name "$comm")

      printf '%-9.9s %5.1f%%\n' "$comm" "$mem"
      count=$((count + 1))
      (( count >= 7 )) && break
    done < <(ps -eo pmem=,comm= --sort=-pmem 2>/dev/null)
  } > "$cache_tmp"

  mv "$cache_tmp" "$cache_file"
  while IFS= read -r line; do
    printf '%s\n' "$line"
  done < "$cache_file"
  exit 0
fi

{
  count=0
  while read -r cpu comm; do
    [[ -n "${comm:-}" ]] || continue
    [[ "$comm" == "ps" ]] && continue
    comm=$(normalize_name "$comm")

    printf '%-9.9s %5.1f%%\n' "$comm" "$cpu"
    count=$((count + 1))
    (( count >= 7 )) && break
  done < <(ps -eo pcpu=,comm= --sort=-pcpu 2>/dev/null)
} > "$cache_tmp"

mv "$cache_tmp" "$cache_file"
while IFS= read -r line; do
  printf '%s\n' "$line"
done < "$cache_file"
