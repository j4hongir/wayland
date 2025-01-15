#!/bin/bash

SCREENSHOT_DIR=~/Pictures/screens
mkdir -p "$SCREENSHOT_DIR"

FILENAME="screenshot-$(date +'%Y-%m-%d-%H%M%S').png"
FILEPATH="$SCREENSHOT_DIR/$FILENAME"

grim -g "$(slurp)" "$FILEPATH"
wl-copy < "$FILEPATH"

echo "$FILEPATH" | cliphist encode
notify-send "Screenshot taken"
