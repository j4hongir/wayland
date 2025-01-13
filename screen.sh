#!/bin/bash

# Папка для сохранения скриншотов
SCREENSHOT_DIR=~/Pictures/screens
mkdir -p "$SCREENSHOT_DIR"

# Снимок экрана с текущей датой и временем
FILENAME="screenshot-$(date +'%Y-%m-%d-%H%M%S').png"
FILEPATH="$SCREENSHOT_DIR/$FILENAME"

# Сделать снимок экрана
grim -g "$(slurp)" "$FILEPATH"

# Копировать в буфер обмена
wl-copy < "$FILEPATH"

# Добавить в историю cliphist
echo "$FILEPATH" | cliphist encode
