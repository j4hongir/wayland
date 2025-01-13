#!/bin/sh

chosen=$(printf "Restart \nQuit \nLock Session\nSuspend\nReboot\nShutdown" | dmenu -b -l 10 -i -p "What are we doing?" -fn "MartianMono NFM Cond Med:14" \
-nb "#282828" -nf "#ebdbb2" -sb "#fabd2f" -sf "#282828")

if [ -z "$chosen" ]; then
    exit 0
else
    case $chosen in
        Restart*) systemctl reboot ;;
        
        Quit*)
            if [[ "$(echo $DESKTOP_SESSION)" == "hyprland" ]]; then
                # Если это Hyprland
                hyprctl dispatch exit
            elif [[ "$(echo $DESKTOP_SESSION)" == "sway" ]]; then
                # Если это Sway
                swaymsg exit
            else
                # Для других случаев
                notify-send "Неизвестный оконный менеджер"
            fi
            ;;
        
        Lock*) hyprlock ;;
        
        Suspend) systemctl suspend ;;
        
        Reboot) systemctl reboot ;;
        
        Shutdown) systemctl poweroff ;;
    esac
fi
