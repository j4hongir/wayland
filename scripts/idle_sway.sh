#!/bin/bash
swayidle -w \
     timeout 290 'notify-send "Блокировка через 10 секунд"' \
     timeout 300 'swaylock -f  --show-keyboard-layout  -i ~/wayland/walls/gruvwall.png --inside-color 282828 --ring-color b8bb26 --text-color ebdbb2 --line-color 928374' \
     timeout 350 'swaymsg "output * dpms off"' resume 'swaymsg "output * dpms on"' \
     before-sleep 'swaylock -f -i ~/wayland/walls/gruvwall.png'



swaylock -f  --show-keyboard-layout  -i ~/wayland/walls/gruvwall.png --inside-color 282828 --ring-color b8bb26 --text-color ebdbb2 --line-color 928374
