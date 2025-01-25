#!/bin/bash
swayidle -w \
     timeout 290 'notify-send "Блокировка через 10 секунд"' \
     timeout 300 'swaylock -f -i ~/wayland/walls/gruvwall.png' \
     timeout 350 'swaymsg "output * dpms off"' resume 'swaymsg "output * dpms on"' \
     before-sleep 'swaylock -f -i ~/wayland/walls/gruvwall.png'
