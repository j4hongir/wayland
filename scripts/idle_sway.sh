#!/bin/bash

swayidle -w \
    timeout 590 'notify-send "lockscreen" "10 секунд" -u critical -t 9000' \
    timeout 600 'swaylock -f -i ~/wayland/walls/nasa.png' \
    timeout 615 'swaymsg "output * dpms off"' \
        resume 'swaymsg "output * dpms on"' \
    timeout 620 'systemctl suspend' \
    before-sleep 'swaylock -f -i ~/wayland/walls/nasa.png'
