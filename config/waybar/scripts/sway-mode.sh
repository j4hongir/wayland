#!/bin/sh

# Функция для форматирования вывода в JSON для waybar
format_output() {
    local mode="$1"
    if [ "$mode" = "resize" ]; then
        echo "{\"text\": \" 󰩨 \", \"class\": \"$mode\"}"
    else
        echo "{\"text\": \"  \", \"class\": \"$mode\"}"
    fi
}

# Получаем начальный режим
current_mode=$(swaymsg -t get_binding_state | jq -r '.mode')
[ -z "$current_mode" ] && current_mode="default"
format_output "$current_mode"

# Слушаем изменения режима
swaymsg -t subscribe -m '["mode"]' | while read -r line; do
    mode=$(echo "$line" | jq -r '.change')
    [ -z "$mode" ] && mode="default"
    format_output "$mode"
done
