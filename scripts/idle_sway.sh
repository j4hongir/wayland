#!/bin/bash
swayidle -w \
     timeout 500 'notify-send "Блокировка через 10 секунд"' \
     timeout 515 'swaylock -f  --show-keyboard-layout  -i ~/wayland/walls/gruvwall.png --inside-color 282828 --ring-color b8bb26 --text-color ebdbb2 --line-color 928374' \
     timeout 520 'swaymsg "output * dpms off"; systemctl suspend' resume 'swaymsg "output * dpms on"' \
     before-sleep 'swaylock -f -i ~/wayland/walls/gruvwall.png'
