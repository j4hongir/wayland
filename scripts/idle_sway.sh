#!/bin/bash
swayidle -w \
     timeout 500 'notify-send "Блокировка через 10 секунд"' \
     timeout 515 'swaylock -i ~/wayland/walls/gruvwall.png' \
     timeout 520 'swaymsg "output * dpms off"; systemctl suspend' resume 'swaymsg "output * dpms on"' \
     before-sleep 'swaylock -i ~/wayland/walls/gruvwall.png'
