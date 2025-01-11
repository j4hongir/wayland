#!/bin/sh

chosen=$(printf "Restart \nQuit \nLock Session\nSuspend\nReboot\nShutdown" | dmenu -b -l 10 -i -p "What are we doing?" -fn "MartianMono NFM Cond Med:14" \
-nb "#282828" -nf "#ebdbb2" -sb "#fabd2f" -sf "#282828")

if [ -z "$chosen" ]; then
	exit 0
else
	case $chosen in
        Restart*) systemctl reboot ;;
        Quit*) hyprctl dispatch exit ;;
        # Quit*) swaymsg exit ;; for sway 
        Lock*) swaylock -i ~/Pictures/gruv-focus.png --no-unlock-indicator ;; #for hypr
        Suspend) systemctl suspend ;;
        Reboot) systemctl reboot ;;
        Shutdown) systemctl poweroff ;;
	esac
fi
