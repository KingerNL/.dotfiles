#!/usr/bin/env bash
set -euo pipefail

config_file="$HOME/.config/waybar/scripts/robot-eth.conf"

if [[ -r "$config_file" ]]; then
  source "$config_file"
fi

ROBOT_IP="${ROBOT_IP:-192.168.42.1}"
IFACES="${IFACES:-${IFACE:-enp0s31f6}}"
counters_file="/tmp/eww-robot-link-${UID}.state"
cache_file="/tmp/eww-robot-link-${UID}.cache"
lock_dir="/tmp/eww-robot-link-${UID}.lock"
refresh_interval=5

if [[ "${1:-}" != "--refresh" ]]; then
  if [[ -r "$cache_file" ]]; then
    cat "$cache_file"
  else
    printf 'ROBOT LINK\n'
    printf 'host  %s\n' "$ROBOT_IP"
    printf 'eth   -\n'
    printf 'ping  --\n'
    printf 'link  ↓ - | ↑ -\n'
    printf 'state offline\n'
  fi

  now=$(date +%s)
  cache_mtime=0
  if [[ -r "$cache_file" ]]; then
    cache_mtime=$(stat -c %Y "$cache_file" 2>/dev/null || printf '0')
  fi

  if (( now - cache_mtime >= refresh_interval )) && mkdir "$lock_dir" 2>/dev/null; then
    (
      trap 'rmdir "$lock_dir" 2>/dev/null || true' EXIT
      tmp_file="${cache_file}.$$"
      if "$0" --refresh > "$tmp_file"; then
        mv "$tmp_file" "$cache_file"
      else
        rm -f "$tmp_file"
      fi
    ) >/dev/null 2>&1 &
  fi

  exit 0
fi

robot_route=$(ip route get "$ROBOT_IP" 2>/dev/null || true)
robot_iface=""
state="offline"
ping_ms="--"
rx_rate="-"
tx_rate="-"

human_rate() {
  local bytes=${1:-0}
  local whole decimal

  if (( bytes < 1024 )); then
    printf '%dB/s' "$bytes"
  elif (( bytes < 1048576 )); then
    whole=$((bytes / 1024))
    decimal=$(((bytes * 10 / 1024) % 10))
    if (( whole < 100 )); then
      printf '%d.%dKB/s' "$whole" "$decimal"
    else
      printf '%dKB/s' "$whole"
    fi
  else
    whole=$((bytes / 1048576))
    decimal=$(((bytes * 10 / 1048576) % 10))
    if (( whole < 100 )); then
      printf '%d.%dMB/s' "$whole" "$decimal"
    else
      printf '%dMB/s' "$whole"
    fi
  fi
}

for iface in $IFACES; do
  if printf '%s' "$robot_route" | grep -q "dev $iface"; then
    robot_iface="$iface"
    break
  fi
done

if [[ -z "$robot_iface" ]]; then
  for iface in $IFACES; do
    if [[ -d "/sys/class/net/$iface" ]]; then
      robot_iface="$iface"
      break
    fi
  done
fi

if ping_out=$(timeout 0.35s ping -c 1 -W 1 "$ROBOT_IP" 2>/dev/null); then
  state="online"
  ping_ms=$(printf '%s\n' "$ping_out" | awk -F'time=' '/time=/ {split($2,a," "); print a[1] "ms"; exit}')
fi

if [[ -n "$robot_iface" && -r "/sys/class/net/$robot_iface/statistics/rx_bytes" && -r "/sys/class/net/$robot_iface/statistics/tx_bytes" ]]; then
  now=$(date +%s)
  read -r rx < "/sys/class/net/$robot_iface/statistics/rx_bytes"
  read -r tx < "/sys/class/net/$robot_iface/statistics/tx_bytes"

  prev_iface=""
  prev_rx=$rx
  prev_tx=$tx
  prev_time=$now

  if [[ -r "$counters_file" ]]; then
    read -r prev_iface prev_rx prev_tx prev_time < "$counters_file" || true
  fi

  elapsed=$((now - prev_time))
  (( elapsed > 0 )) || elapsed=1

  if [[ "$prev_iface" == "$robot_iface" ]]; then
    rx_delta=$((rx - prev_rx))
    tx_delta=$((tx - prev_tx))
    (( rx_delta >= 0 )) || rx_delta=0
    (( tx_delta >= 0 )) || tx_delta=0
    rx_rate=$(human_rate $((rx_delta / elapsed)))
    tx_rate=$(human_rate $((tx_delta / elapsed)))
  else
    rx_rate="0B/s"
    tx_rate="0B/s"
  fi

  printf '%s %s %s %s\n' "$robot_iface" "$rx" "$tx" "$now" > "$counters_file"
fi

printf 'ROBOT LINK\n'
printf 'host  %s\n' "$ROBOT_IP"
printf 'eth   %s\n' "${robot_iface:--}"
printf 'ping  %s\n' "$ping_ms"
printf 'link  ↓ %s | ↑ %s\n' "$rx_rate" "$tx_rate"
printf 'state %s\n' "$state"
