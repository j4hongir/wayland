#!/bin/bash

# Получение текущей даты и времени
date_time=$(date '+%Y-%m-%d %H:%M:%S')

# Получение данных о нагрузке процессора
cpu_load=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5); printf "%.1f", usage}')
cpu_info="CPU Usage: $cpu_load%"

# Получение данных о памяти
mem_info=$(free -h | awk '/^Mem:/ {printf "Memory: %s / %s", $3, $2}')

# Получение данных о свободном месте на диске
disk_info=$(df -h --output=avail,size / | tail -n 1 | awk '{printf "Disk: %s / %s", $1, $2}')

# Получение текущей громкости
volume=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}')
volume_info="Volume: $volume"

# Получение текущей яркости экрана
brightness=$(brightnessctl get)
max_brightness=$(brightnessctl max)
brightness_percent=$((brightness * 100 / max_brightness))
brightness_info="Brightness: $brightness_percent%"

# Получение данных о заряде батареи
battery_info="Battery: Not Available"
battery_status=$(upower -i $(upower -e | grep BAT) 2>/dev/null)
if [ -n "$battery_status" ]; then
    battery_percentage=$(echo "$battery_status" | grep -E "percentage" | awk '{print $2}')
    battery_info="Battery: $battery_percentage"
fi

# Объединяем информацию, добавляя время в первую строку
output="Time: $date_time\n$cpu_info\n$mem_info\n$disk_info\n$battery_info\n$brightness_info\n$volume_info"

# Отображение информации в dmenu
chosen=$(echo -e "$output" | dmenu -i -b -p "󰣇 " -fn "MartianMono NFM Cond Med:14" -nb "#282828" -nf "#ebdbb2" -sb "#fabd2f" -sf "#282828")

# Выполнение действия в зависимости от выбора
if [ -z "$chosen" ]; then
    exit 0
else
    case $chosen in
        # Открытие btop для CPU, GPU, или памяти
        *"CPU Usage"*) kitty -e btop ;;
        *"Memory"*) kitty -e btop ;;
        *"Disk"*) kitty -e btop ;;
        
        # Открытие скрипта с временем
        *"Time"*) kitty -e ~/./clock ;;
        
        # Открытие настройки громкости
        *"Volume"*) pavucontrol ;;
        
        # Открытие скрипта для яркости
        *"Brightness"*) ~/./brightness.sh ;;

        # Открытие информации о батарее
        *"Battery"*)  ;;
        
        # При желании можно добавить дополнительные действия
        *)
            echo "Selected option: $chosen"
            ;;
    esac
fi

