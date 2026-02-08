#!/bin/bash

# Enable error handling and pipefail
set -euo pipefail

# Trap to clean up processes when the script exits
trap 'pkill cava; exit' EXIT

bar="▁▂▃▅▆▇"
dict="s/;//g;"

# Create "dictionary" to replace char with bar
i=0
while [ $i -lt ${#bar} ]
do
    dict="${dict}s/$i/${bar:$i:1}/g;"
    i=$((i + 1))
done

# Write cava config
config_file="/home/murt/.config/waybar/scripts/cava_config.conf"

# Run cava and process the output
cava -p $config_file | while IFS= read -r line; do
    # Process each line using sed and handle the output
    echo "$line" | sed "$dict"
done

