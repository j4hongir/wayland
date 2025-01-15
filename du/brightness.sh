#!/bin/bash

chose=$(printf "100 \n90 \n80 \n70 \n60 \n50 \n40 \n30 \n20" | dmenu -b -l 11 -i -p "Brightness " -fn "MartianMono NFM Cond Med:14" \
-nb "#282828" -nf "#ebdbb2" -sb "#fabd2f" -sf "#282828")

if [ -z "$chose" ]
then
    exit 0
else
    case $chose in
        10*) brightnessctl set 100% ;;
        9*) brightnessctl set 90% ;;
        8*) brightnessctl set 80% ;;
        7*) brightnessctl set 70% ;;
        6*) brightnessctl set 60% ;;
        5*) brightnessctl set 50% ;;
        4*) brightnessctl set 40% ;;
        3*) brightnessctl set 30% ;;
        2*) brightnessctl set 20% ;;
        1*) brightnessctl set 10% ;;
    esac
fi

