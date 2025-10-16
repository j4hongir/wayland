#!/bin/bash
WALLPAPER_DIR="$HOME/wayland/walls"
CONFIG_FILE="$HOME/.config/hypr/wallpaper.conf"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "# Автоматически сгенерированный конфиг обоев" > "$CONFIG_FILE"
fi

selected_wallpaper=$(ls "$WALLPAPER_DIR" | wofi --dmenu -p "Выберите обои")

if [ -n "$selected_wallpaper" ]; then
    wallpaper_path="$WALLPAPER_DIR/$selected_wallpaper"
    
    if [ -f "$wallpaper_path" ]; then
        # Убиваем старый процесс
        pkill swaybg
        sleep 0.2
        
        # Запускаем новый
        swaybg -i "$wallpaper_path" -m fill &
        
        # Сохраняем ОТНОСИТЕЛЬНЫЙ путь (с ~)
        relative_path="~/wayland/walls/$selected_wallpaper"
        echo "exec-once = swaybg -i $relative_path -m fill" > "$CONFIG_FILE"
        
        notify-send "Обои изменены" "$selected_wallpaper" -i "$wallpaper_path"
    else
        notify-send "Ошибка" "Файл не найден: $selected_wallpaper" -u critical
    fi
fi
