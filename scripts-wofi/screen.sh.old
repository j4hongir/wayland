#!/bin/bash

SCREENSHOT_DIR="${SCREENSHOT_DIR:-$HOME/Pictures/screens}"
mkdir -p "$SCREENSHOT_DIR"

FILENAME="screenshot-$(date +'%Y-%m-%d-%H%M%S').png"
FILEPATH="$SCREENSHOT_DIR/$FILENAME"

GEOMETRY=$(slurp -d -b 1B1F2866 -c 89b4faff -w 1 2>/dev/null)

# пользователь нажал Esc или закрыл
[[ -z "$GEOMETRY" ]] && exit 0

GEOMETRY_TRIMMED=$(echo "$GEOMETRY" | awk '
  BEGIN { FS="[ ,x]"; OFS="" }
  {
    x=$1+1; y=$2+1
    w=$3-2; h=$4-2
    if (w < 1) w=1
    if (h < 1) h=1
    print x","y" "w"x"h
  }
')

grim -g "$GEOMETRY_TRIMMED" -t png -l 3 "$FILEPATH" 2>/dev/null

if [[ ! -f "$FILEPATH" || ! -s "$FILEPATH" ]]; then
    [[ -f "$FILEPATH" ]] && rm -f "$FILEPATH"
    notify-send "Скриншот" "Ошибка захвата" -i dialog-error -t 3000
    exit 1
fi

wl-copy < "$FILEPATH"

wl-paste | cliphist store 2>/dev/null || true

ACTION=$(notify-send "Скриншот сохранён" "$FILENAME" \
    -i "$FILEPATH" \
    -t 6000 \
    -A "open=Открыть" \
    -A "edit=Редактировать")

case "$ACTION" in
    open)   xdg-open "$FILEPATH" & ;;
    folder) xdg-open "$SCREENSHOT_DIR" & ;;
    edit)
        # попробуем swappy, затем gimp, затем любой image viewer
        if command -v swappy &>/dev/null; then
            swappy -f "$FILEPATH" &
        elif command -v gimp &>/dev/null; then
            gimp "$FILEPATH" &
        else
            xdg-open "$FILEPATH" &
        fi
        ;;
esac

exit 0
