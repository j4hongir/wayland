#!/bin/bash

# Задаем параметры dmenu и команду
DMENU_CMD=( dmenu -b -l 10 -i -p '>> ' -fn 'MartianMono NFM Cond Med:14' -nb '#282828' -nf '#ebdbb2' -sb '#fabd2f' -sf '#282828' )

# Получаем список доступных приложений
apps=$(compgen -c | sort -u)

# Показываем меню и сохраняем выбранное приложение
selection=$(echo "$apps" | $DMENU_CMD)

# Если приложение выбрано, запускаем его
if [ -n "$selection" ]; then
    $selection &
fi
