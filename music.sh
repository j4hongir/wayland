#!/bin/bash

# Получаем текущую музыку
current_track=$(playerctl metadata --format '{{ artist }} - {{ title }}')

# Если музыка не играет, выводим "Нет воспроизведения"
if [ -z "$current_track" ]; then
  current_track="no"
  options="Нет"
else
  options="KJ $current_track\n>> \n<< \n "
fi

# Запускаем dmenu с вариантами
selected_option=$(echo -e "$options" | dmenu  -b -l 10 -i -p "󰎆 " -fn "MartianMono NFM Cond Med:14" -nb "#282828" -nf "#ebdbb2" -sb "#fabd2f" -sf "#282828" )

# Обрабатываем выбор
case "$selected_option" in
  ">> ")
    playerctl next
    ;;
  "<< ")
    playerctl previous
    ;;
  "")
    exit 0
    ;;
  *)
    # Если выбрана музыка, показываем ее снова
    current_track=$(playerctl metadata --format '{{ artist }} - {{ title }}')
    echo "$current_track" | dmenu 
    ;;
esac

