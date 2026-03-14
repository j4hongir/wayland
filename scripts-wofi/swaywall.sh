#!/bin/bash
# Путь к директории с обоями
WALLPAPER_DIR="$HOME/wayland/walls"

# Выбор обоев через wofi
selected_wallpaper=$(ls "$WALLPAPER_DIR" | wofi --dmenu -p "Выберите обои")

if [ -n "$selected_wallpaper" ]; then
    # Полный путь к выбранному изображению
    wallpaper_path="$WALLPAPER_DIR/$selected_wallpaper"
    
    # Установка обоев через swaybg
    pkill swaybg
    swaybg -i "$wallpaper_path" -m fill &
    
    # Обновление конфигурации Sway
    # Сначала создаём временный файл
    sed '1{/^output \* bg/d}' ~/.config/sway/config > temp.conf
    
    # Добавляем новую строку в начало файла
    echo "output * bg $wallpaper_path fill" | cat - temp.conf > ~/.config/sway/config
    
    # Удаляем временный файл
    rm temp.conf
    
    echo "Обои успешно изменены и конфигурация обновлена!"
else
    echo "Отмена выбора обоев"
fi
