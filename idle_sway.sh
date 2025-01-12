#!/bin/bash
swayidle -w \
     timeout 280 'notify-send "Блокировка через 10 секунд"' \
     timeout 300 'swaylock -f -i ~/wayland/gruvwall.png' \
     timeout 350 'swaymsg "output * power off"' resume 'swaymsg "output * power on"' \
     before-sleep 'swaylock -f -i ~/wayland/gruvwall.png'

