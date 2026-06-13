#!/bin/bash
set -euo pipefail

SQUARE="■"
GREEN1="#1b4721"
GREEN2="#2b6a30"
GREEN3="#46954a"
GREEN4="#6bc46d"
BLACK="#313244"

TOKEN_FILE="$HOME/.config/waybar/scripts/token.txt"
CACHE_FILE="$HOME/.cache/weekly_commits_cache.txt"
FROM_DATE=$(date -u -d '2 days ago' +"%Y-%m-%dT00:00:00Z")
TO_DATE=$(date -u +"%Y-%m-%dT23:59:59Z")

json() {
  jq -cn --arg text "$1" --arg tooltip "${2:-$1}" --arg class "${3:-}" \
    '{text: $text, tooltip: $tooltip} + if $class == "" then {} else {class: $class} end'
}

render_cache() {
  local output=""
  local tooltip="GitHub contributions"

  while read -r line; do
    [ -n "$line" ] || continue
    local date count color
    date=${line%%:*}
    count=${line##* }

    if ! [[ "$count" =~ ^[0-9]+$ ]]; then
      continue
    fi

    if [ "$count" -eq 0 ]; then
      color="$BLACK"
    elif [ "$count" -le 2 ]; then
      color="$GREEN1"
    elif [ "$count" -le 4 ]; then
      color="$GREEN2"
    elif [ "$count" -le 6 ]; then
      color="$GREEN3"
    else
      color="$GREEN4"
    fi

    output+="<span color='$color'>$SQUARE</span> "
    tooltip+="\n$date: $count"
  done < <(tail -n 3 "$CACHE_FILE")

  if [ -n "$output" ]; then
    json "$output" "$tooltip" "ok"
    return 0
  fi

  return 1
}

mkdir -p "$(dirname "$CACHE_FILE")"

if [ ! -s "$TOKEN_FILE" ]; then
  json " auth" "Missing GitHub token at $TOKEN_FILE" "error"
  exit 0
fi

if ! command -v jq >/dev/null 2>&1 || ! command -v curl >/dev/null 2>&1; then
  json " deps" "Missing jq or curl" "error"
  exit 0
fi

TOKEN=$(head -n 1 "$TOKEN_FILE")
CURR_DATE=$(date +%s)
LAST_EDIT=0
LINE_COUNT=0

if [ -f "$CACHE_FILE" ]; then
  LAST_EDIT=$(stat --format=%Y "$CACHE_FILE")
  LINE_COUNT=$(wc -l <"$CACHE_FILE" 2>/dev/null || echo 0)
fi

CONNECTED=0
if nmcli device status 2>/dev/null | grep -E "(wifi|ethernet)" | grep -q "connected"; then
  CONNECTED=1
fi

if { [ ! -s "$CACHE_FILE" ] || [ $((CURR_DATE - LAST_EDIT)) -gt 600 ] || [ "$LINE_COUNT" -lt 3 ]; } && [ "$CONNECTED" -eq 1 ]; then
  QUERY='query($from: DateTime!, $to: DateTime!) {
  viewer {
    contributionsCollection(from: $from, to: $to) {
      contributionCalendar {
        weeks {
          contributionDays {
            date
            contributionCount
          }
        }
      }
    }
  }
}'

  TMP_FILE=$(mktemp)
  if curl -fsS https://api.github.com/graphql \
    -H "Authorization: bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d "$(jq -n --arg q "$QUERY" --arg from "$FROM_DATE" --arg to "$TO_DATE" '{ query: $q, variables: { from: $from, to: $to } }')" |
    jq -er '.data.viewer.contributionsCollection.contributionCalendar.weeks[].contributionDays[] | "\(.date): \(.contributionCount)"' >"$TMP_FILE"; then
    mv "$TMP_FILE" "$CACHE_FILE"
  else
    rm -f "$TMP_FILE"
  fi
fi

if [ -s "$CACHE_FILE" ] && render_cache; then
  exit 0
fi

if [ "$CONNECTED" -eq 0 ]; then
  json " offline" "No network and no usable GitHub cache" "offline"
else
  json " api" "GitHub API failed or returned no contribution data" "error"
fi
