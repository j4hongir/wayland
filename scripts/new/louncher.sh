#!/bin/bash

# Путь к директории с обоями
WALLPAPER_DIR="$HOME/wayland/walls"

# Выбор обоев через tofi с вертикальным списком
selected_wallpaper=$(ls "$WALLPAPER_DIR" | tofi --horizontal=false --result-spacing=10 )

# Если выбраны обои
if [ -n "$selected_wallpaper" ]; then
    # Полный путь к выбранному изображению
    wallpaper_path="$WALLPAPER_DIR/$selected_wallpaper"
    
    # Установка обоев через swaybg
    swaybg -i "$wallpaper_path" -m fill &
    
    # Обновление hyprland.conf
    # Сначала создаём временный файл
    sed -i '/^exec-once = swaybg/d' ~/.config/hypr/hyprland.conf
    
    # Добавляем новую строку в начало файла
    sed -i '1i exec-once = swaybg -i '"$wallpaper_path"' -m fill' ~/.config/hypr/hyprland.conf
    
    echo "Обои успешно изменены и конфигурация обновлена!"
else
    echo "Отмена выбора обоев"
fi
