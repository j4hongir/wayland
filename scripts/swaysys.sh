#!/bin/bash
options="Restart\nQuit\nLock Session\nSuspend\nReboot\nShutdown"
chosen=$(echo -e "$options" | tofi --prompt-text "> ")

if [ -z "$chosen" ]; then
    exit 0
else
    case $chosen in
        Restart*)  swaymsg reload ;;
        Quit*)     swaymsg exit ;;
        Lock*)     swaylock -i ~/wayland/walls/trees.png ;;
        Suspend)   systemctl suspend ;;
        Reboot)    systemctl reboot ;;
        Shutdown)  systemctl poweroff ;;
    esac
fi
