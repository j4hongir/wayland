#!/bin/bash

# Опции для меню
options="Restart\nQuit\nLock Session\nSuspend\nReboot\nShutdown"

# Вызов wofi
chosen=$(echo -e "$options" | wofi --dmenu --prompt "What are we doing?" --style ~/.config/wofi/style.css)

# Если ничего не выбрано, выйти
if [ -z "$chosen" ]; then
    exit 0
else
    case $chosen in
        Restart*) systemctl reboot ;;
        
        Quit*)
            if [[ "$DESKTOP_SESSION" == "hyprland" ]]; then
                # Если это Hyprland
                hyprctl dispatch exit
            elif [[ "$DESKTOP_SESSION" == "sway" ]]; then
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
