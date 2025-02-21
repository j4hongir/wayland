#!/bin/bash

STATUS=$(systemctl is-active bluetooth.service)

if [[ $STATUS == "active" ]]; then
    # Отключить Bluetooth
    pkill blueman-applet
    systemctl stop bluetooth.service
    notify-send "Bluetooth" "Bluetooth отключен"
else
    # Включить Bluetooth
    systemctl start bluetooth.service
    notify-send "Bluetooth" "Bluetooth включен"
    blueman-applet &
fi

