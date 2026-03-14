#!/bin/bash
WALLPAPER_DIR="$HOME/wayland/walls"
CONFIG_FILE="$HOME/.config/hypr/wallpaper.conf"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "# auto-generated wallpaper config" > "$CONFIG_FILE"
fi

selected_wallpaper=$(ls "$WALLPAPER_DIR" | tofi --auto-accept-single false --prompt-text "> ")

if [ -n "$selected_wallpaper" ]; then
    wallpaper_path="$WALLPAPER_DIR/$selected_wallpaper"

    if [ -f "$wallpaper_path" ]; then
        pkill swaybg
        sleep 0.2

        swaybg -i "$wallpaper_path" -m fill &

        relative_path="~/wayland/walls/$selected_wallpaper"
        echo "exec-once = swaybg -i $relative_path -m fill" > "$CONFIG_FILE"

        notify-send "wallpaper changed" "$selected_wallpaper" -i "$wallpaper_path"
    else
        notify-send "error" "file not found: $selected_wallpaper" -u critical
    fi
else
    echo "canceled"
fi
