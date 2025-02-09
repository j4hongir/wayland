#!/bin/bash

# Проверяем, установлен ли fzf
if ! command -v fzf >/dev/null 2>&1; then
    echo "Ошибка: fzf не установлен. Установите его с помощью вашего пакетного менеджера."
    exit 1
fi

# Проверяем, запущен ли tmux
if [ -z "$TMUX" ]; then
    # Если tmux не запущен, получаем список сессий и подключаемся к выбранной
    selected_session=$(tmux list-sessions -F "#{session_name}: #{session_windows} окон#{?session_attached, (подключена),}" 2>/dev/null | \
        fzf --reverse --header="Выберите сессию для подключения" --header-first | \
        cut -d':' -f1)
    
    if [ -n "$selected_session" ]; then
        # Если сессия выбрана, подключаемся к ней
        tmux attach-session -t "$selected_session"
    else
        echo "Сессия не выбрана"
        exit 0
    fi
else
    # Если уже в tmux, переключаемся между сессиями
    selected_session=$(tmux list-sessions -F "#{session_name}: #{session_windows} окон#{?session_attached, (подключена),}" | \
        fzf --reverse --header="Выберите сессию для переключения" --header-first | \
        cut -d':' -f1)
    
    if [ -n "$selected_session" ]; then
        # Если сессия выбрана, переключаемся на неё
        tmux switch-client -t "$selected_session"
    else
        echo "Сессия не выбрана"
        exit 0
    fi
fi
