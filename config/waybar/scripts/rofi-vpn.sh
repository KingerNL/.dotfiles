#!/bin/bash

# Define menu options
options="Connect\nStatus\nDisconnect"

# Use rofi to display the menu
action=$(echo -e "$options" | rofi -dmenu -i -p "VPN Action:")

case "$action" in
    "Connect")
        # Fetch available countries and connect
        countries=$(nordvpn countries | awk '{print $1}')
        chosen=$(echo "$countries" | rofi -dmenu -i -p "Select Country:")
        if [ -n "$chosen" ]; then
            nordvpn connect "$chosen"
        fi
        ;;
    "Status")
        # Show VPN status
        status=$(nordvpn status)
        echo "$status" | rofi -dmenu -i -p "VPN Status:"
        ;;
    "Disconnect")
        # Disconnect VPN
        response=$(echo -e "Yes\nNo" | rofi -dmenu -i -p "Disconnect VPN?")
        if [ "$response" == "Yes" ]; then
            nordvpn disconnect
        fi
        ;;
esac

