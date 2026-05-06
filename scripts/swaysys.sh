#!/bin/bash
options="Restart\nQuit\nLock\nSuspend\nReboot\nShutdown"
chosen=$(echo -e "$options" | tofi --auto-accept-single false --prompt-text "> ")

if [ -z "$chosen" ]; then
    exit 0
else
    case $chosen in
        Restart*)  swaymsg reload ;;
        Quit*)     swaymsg exit ;;
        Lock*)     swaylock -f -i ~/wayland/walls/nasa.png ;;
        Suspend)   systemctl suspend ;;
        Reboot)    systemctl reboot ;;
        Shutdown)  systemctl poweroff ;;
    esac
fi
