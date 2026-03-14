#!/bin/bash
WALLPAPER_DIR="$HOME/wayland/walls"

selected_wallpaper=$(ls "$WALLPAPER_DIR" | tofi --auto-accept-single false --prompt-text "> ")

if [ -n "$selected_wallpaper" ]; then
    wallpaper_path="$WALLPAPER_DIR/$selected_wallpaper"
    
    pkill swaybg
    swaybg -i "$wallpaper_path" -m fill &
    
    sed '1{/^output \* bg/d}' ~/.config/sway/config > temp.conf
    echo "output * bg $wallpaper_path fill" | cat - temp.conf > ~/.config/sway/config
    rm temp.conf
    
    echo "wallpaper successfully changed"
else
    echo "canceled"
fi
