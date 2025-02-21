#!/bin/sh

# Проверка наличия Sway
if ! pgrep -x "sway" > /dev/null; then
    # Если Sway не запущен, выводим базовый статус
    echo '{"text": "  ", "class": "default"}'
    exit 0
fi

# Функция для форматирования вывода в JSON для waybar
format_output() {
    local mode="$1"
    if [ "$mode" = "resize" ]; then
        echo "{\"text\": \" 󰩨 \", \"class\": \"$mode\"}"
    else
        echo "{\"text\": \"  \", \"class\": \"$mode\"}"
    fi
}

# Проверяем доступность сокета Sway
if ! swaymsg -t get_binding_state >/dev/null 2>&1; then
    echo '{"text": "  ", "class": "default"}'
    exit 0
fi

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
