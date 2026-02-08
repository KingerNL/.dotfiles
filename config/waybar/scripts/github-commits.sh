#!/bin/bash

SQUARE="■"
# colors for "gradient", green1 is the darkest green4 is the lightest
GREEN1="#1b4721"
GREEN2="#2b6a30"
GREEN3="#46954a"
GREEN4="#6bc46d"
BLACK="#313244"

# get dates
FROM_DATE=$(date -u -d '2 days ago' +"%Y-%m-%dT%H:%M:%SZ")
TO_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

#read token from first line of file, token file MUST be on the same path
TOKEN=$(head -n 1 $HOME/.config/waybar/scripts/token.txt)
#cache file
CACHE_FILE=$HOME/.cache/weekly_commits_cache.txt

# make sure last edit was more that 5 hours ago
CURR_DATE=$(date +%s)
if [ -f $CACHE_FILE ]; then
  LAST_EDIT=$(stat --format=%Y $CACHE_FILE)
  FILE_EXISTS=1
else
  LAST_EDIT=0
  FILE_EXISTS=0
fi
#make sure there is a cache file path
mkdir -p $(dirname "$CACHE_FILE")

#check for network connection
if nmcli device status | grep -E "(wifi|ethernet)" | grep -q "connected"; then
  CONNECTED=1
else
  CONNECTED=0
fi

#make sure file has 7 line, somehow sometimes it gets empty, idk why yet
LINE_COUNT=$(wc -l <"$CACHE_FILE" 2>/dev/null || echo 0)

if { [ $FILE_EXISTS -eq 0 ] || [ $((CURR_DATE - LAST_EDIT)) -gt 600 ] || [ $LINE_COUNT -lt 7 ]; } && [ $CONNECTED -eq 1 ]; then
  # graphql query
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

  #pull from api
  curl -s https://api.github.com/graphql \
    -H "Authorization: bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d "$(jq -n \
      --arg q "$QUERY" \
      --arg from "$FROM_DATE" \
      --arg to "$TO_DATE" \
      '{ query: $q, variables: { from: $from, to: $to } }')" |
    jq -r '.data.viewer.contributionsCollection.contributionCalendar.weeks[].contributionDays[] | "\(.date): \(.contributionCount)"' >"$CACHE_FILE"

fi

if [ -f "$CACHE_FILE" ]; then

  output=""

  #read the file
  while read -r line; do
    val=$(echo "$line" | awk '{print $NF}')

    if [ "$val" -eq 0 ]; then
      output+="<span color='$BLACK'>$SQUARE</span> "
    elif [ "$val" -le 2 ]; then
      output+="<span color='$GREEN1'>$SQUARE</span> "
    elif [ "$val" -le 4 ]; then
      output+="<span color='$GREEN2'>$SQUARE</span> "
    elif [ "$val" -le 6 ]; then
      output+="<span color='$GREEN3'>$SQUARE</span> "
    else
      output+="<span color='$GREEN4'>$SQUARE</span> "
    fi
  done <"$CACHE_FILE"

  echo "{\"text\": \"$output\"}"

fi
