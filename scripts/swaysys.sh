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
        Restart*) swaymsg reload ;;
        
        Quit*) swaymsg exit ;;
        
        Lock*) swaylock -i ~/wayland/walls/gruvwall.png ;;
        
        Suspend) systemctl suspend ;;
        
        Reboot) systemctl reboot ;;
        
        Shutdown) systemctl poweroff ;;
    esac
fi
