#!/bin/bash
SCREENSHOT_DIR=~/Pictures/screens
mkdir -p "$SCREENSHOT_DIR"
FILENAME="screenshot-$(date +'%Y-%m-%d-%H%M%S').png"
FILEPATH="$SCREENSHOT_DIR/$FILENAME"
pre_size=0
if [ -f "$FILEPATH" ]; then
    pre_size=$(stat -c%s "$FILEPATH")
fi
grim -g "$(slurp)" "$FILEPATH" 2>/dev/null
if [ -f "$FILEPATH" ]; then
    post_size=$(stat -c%s "$FILEPATH")
    
    if [ $post_size -gt 0 ] && [ $post_size -ne $pre_size ]; then
        wl-copy < "$FILEPATH"
        echo "$FILEPATH" | cliphist encode
        
        notify-send "Скриншот сохранен" "Путь: $FILEPATH" -i "$FILEPATH"
    else
        rm -f "$FILEPATH"
    fi
f
