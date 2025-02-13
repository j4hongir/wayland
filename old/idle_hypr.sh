#!/bin/bash
swayidle -w \
     timeout 290 'notify-send "Блокировка через 10 секунд"' \
     timeout 300 'swaylock -f -i ~/wayland/walls/gruvwall.png' \
     timeout 350 'hyprctl dispatch dpms off; systemctl suspend' resume 'hyprctl dispatch dpms on' \
     before-sleep 'swaylock -f -i ~/wayland/walls/gruvwall.png'
