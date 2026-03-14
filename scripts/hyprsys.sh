#!/bin/bash
options="Restart\nQuit\nLock Session\nSuspend\nReboot\nShutdown"
chosen=$(echo -e "$options" | tofi --prompt-text ">")

if [ -z "$chosen" ]; then
    exit 0
else
    case $chosen in
        Restart*)  hyprctl reload ;;
        Quit*)     hyprctl dispatch exit ;;
        Lock*)     hyprlock ;;
        Suspend)   systemctl suspend ;;
        Reboot)    systemctl reboot ;;
        Shutdown)  systemctl poweroff ;;
    esac
fi
