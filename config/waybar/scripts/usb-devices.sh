#!/bin/bash

# Front USB ports (Bus 1, Ports 3 and 4)
FRONT_PORTS=("1-3" "1-4")
count=0
devices=()

for port in "${FRONT_PORTS[@]}"; do
    if [ -d "/sys/bus/usb/devices/$port" ]; then
        ((count++))
        product=$(cat "/sys/bus/usb/devices/$port/product" 2>/dev/null)
        if [ -n "$product" ]; then
            devices+=("$product")
        else
            vendor=$(cat "/sys/bus/usb/devices/$port/idVendor" 2>/dev/null)
            prodid=$(cat "/sys/bus/usb/devices/$port/idProduct" 2>/dev/null)
            if [ -n "$vendor" ] && [ -n "$prodid" ]; then
                name=$(lsusb -d "$vendor:$prodid" 2>/dev/null | sed 's/.*ID [0-9a-f:]\+ //')
                devices+=("${name:-Unknown Device}")
            else
                devices+=("Unknown Device")
            fi
        fi
    fi
done

if [ "$count" -eq 0 ]; then
    echo '{"text": "", "tooltip": "", "class": "empty"}'
    exit 0
fi

tooltip=$(printf '%s\n' "${devices[@]}")
tooltip=${tooltip%\n}

echo "{\"text\": \"󰕓 $count\", \"tooltip\": \"$tooltip\", \"class\": \"connected\"}"
