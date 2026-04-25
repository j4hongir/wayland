#!/bin/bash
options="performance\nbalanced\npower-saver"
chosen=$(echo -e "$options" | tofi --auto-accept-single false --prompt-text "> ")

if [ -z "$chosen" ]; then
    exit 0
else
    case $chosen in
        performance)   powerprofilesctl set performance ;;
        Reboot)    powerprofilesctl set balanced ;;
        Shutdown)  powerprofilesctl set power-saver ;;
    esac
fi
