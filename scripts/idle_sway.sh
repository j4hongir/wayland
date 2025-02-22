#!/bin/bash
swayidle -w \
     timeout 500 'notify-send "Locking after 10 seconds"' \
     timeout 515 'swaylock -i ~/wayland/walls/trees.jpg' \
     timeout 520 'swaymsg "output * dpms off"; systemctl suspend' resume 'swaymsg "output * dpms on"' \
     before-sleep 'swaylock ~/wayland/walls/gruvwall.png'
