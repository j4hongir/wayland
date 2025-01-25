#!/bin/bash

# Путь к директории с обоями
WALLPAPER_DIR="$HOME/wayland/walls"

# Выбор обоев через wofi
selected_wallpaper=$(ls "$WALLPAPER_DIR" | wofi --dmenu -p "Выберите обои")

if [ -n "$selected_wallpaper" ]; then
    # Полный путь к выбранному изображению
    wallpaper_path="$WALLPAPER_DIR/$selected_wallpaper"
    
    # Установка обоев через swaybg
    swaybg -i "$wallpaper_path" -m fill &
    
    # Обновление hyprland.conf
    # Сначала создаём временный файл
    sed '1{/^exec-once = swaybg/d}' ~/.config/hypr/hyprland.conf > temp.conf
    
    # Добавляем новую строку в начало файла
    echo "exec-once = swaybg -i $wallpaper_path -m fill" | cat - temp.conf > ~/.config/hypr/hyprland.conf
    
    # Удаляем временный файл
    rm temp.conf
    
    echo "Обои успешно изменены и конфигурация обновлена!"
else
    echo "Отмена выбора обоев"
fi
