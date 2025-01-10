#!/bin/bash

# Получаем список истории буфера обмена
SELECTION=$(cliphist list | dmenu -i -l 10 -p "Clipboard history:")

# Если выбрано, вставляем в буфер обмена
if [ -n "$SELECTION" ]; then
    echo "$SELECTION" | wl-copy
fi
