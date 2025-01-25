# Опции для меню
options="Restart\nQuit\nLock Session\nSuspend\nReboot\nShutdown"

# Вызов wofi
chosen=$(echo -e "$options" | wofi --dmenu --prompt "What are we doing?" --style ~/.config/wofi/style.css)

# Если ничего не выбрано, выйти
if [ -z "$chosen" ]; then
    exit 0
else
    case $chosen in
        Restart*) hyprctl reload ;;
        
        Quit*) hyprctl dispatch exit ;;
        
        Lock*) hyprlock ;;
        
        Suspend) systemctl suspend ;;
        
        Reboot) systemctl reboot ;;
        
        Shutdown) systemctl poweroff ;;
    esac
fi
