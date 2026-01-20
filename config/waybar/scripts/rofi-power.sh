#!/bin/sh
options="Shutdown\nReboot\nSuspend\nLogout\nLock"
choice=$(printf "%b" "$options" | rofi -dmenu -i -p "Power")
case "$choice" in
  Shutdown) systemctl poweroff ;;
  Reboot) systemctl reboot ;;
  Suspend) systemctl suspend ;;
  Logout) hyprctl dispatch exit ;;
  Lock) hyprlock ;;
esac
