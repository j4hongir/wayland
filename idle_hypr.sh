#!/bin/bash
swayidle -w \
     timeout 290 'notify-send "Блокировка через 10 секунд"' \
     timeout 300 'swaylock -f -i ~/wayland/gruvwall.png' \
     timeout 350 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on' \
     before-sleep 'swaylock -f -i ~/wayland/gruvwall.png'
