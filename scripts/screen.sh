#!/bin/bash
# ─────────────────────────────────────────────────────────────────────────────
# screen.sh — скриншот + OCR | Wayland (grim · slurp · tesseract)
#
# Использование:
#   screen.sh          — скриншот → уведомление с кнопками
#   screen.sh --ocr    — захват области → OCR → текст в буфер (без файла)
#
# Переменные окружения (опционально):
#   SCREENSHOT_DIR     — куда сохранять (default: ~/Pictures/screens)
#   OCR_LANG           — языки Tesseract  (default: rus+eng)
#   EDITOR_APP         — редактор         (default: swappy → gimp → xdg-open)
# ─────────────────────────────────────────────────────────────────────────────

set -euo pipefail

# ── конфиг ───────────────────────────────────────────────────────────────────
SCREENSHOT_DIR="${SCREENSHOT_DIR:-$HOME/Pictures/screens}"
OCR_LANG="${OCR_LANG:-rus+eng}"
SLURP_ARGS=(-d -b 1B1F2866 -c 89b4faff -w 1)
GRIM_ARGS=(-t png -l 3)

# ── хелперы ──────────────────────────────────────────────────────────────────
die() { notify-send "screen.sh" "$1" -i dialog-error -t 4000; exit 1; }

need() {
    for cmd in "$@"; do
        command -v "$cmd" &>/dev/null || die "Не найден: $cmd"
    done
}

# открыть папку с выделенным файлом (перебираем файловые менеджеры)
open_folder() {
    local file="$1"
    if   command -v nautilus  &>/dev/null; then nautilus  --select "$file" &
    elif command -v thunar    &>/dev/null; then thunar    "$(dirname "$file")" &
    elif command -v dolphin   &>/dev/null; then dolphin   --select "$file" &
    elif command -v nemo      &>/dev/null; then nemo      "$(dirname "$file")" &
    elif command -v pcmanfm   &>/dev/null; then pcmanfm   "$(dirname "$file")" &
    else xdg-open "$(dirname "$file")" &
    fi
}

open_editor() {
    local file="$1"
    if   [[ -n "${EDITOR_APP:-}" ]];       then $EDITOR_APP "$file" &
    elif command -v swappy &>/dev/null;    then swappy -f "$file" &
    elif command -v gimp   &>/dev/null;    then gimp   "$file" &
    else xdg-open "$file" &
    fi
}

# убираем 1px-артефакт рамки slurp
trim_geometry() {
    awk 'BEGIN{FS="[ ,x]";OFS=""}{
        x=$1+1; y=$2+1; w=$3-2; h=$4-2
        if(w<1)w=1; if(h<1)h=1
        print x","y" "w"x"h
    }' <<< "$1"
}

ocr_to_clipboard() {
    local file="$1"
    command -v tesseract &>/dev/null \
        || die "Tesseract не установлен → sudo pacman -S tesseract tesseract-data-rus"

    local text
    text=$(tesseract "$file" - -l "$OCR_LANG" 2>/dev/null \
           | grep -v '^[[:space:]]*$') || true

    if [[ -z "$text" ]]; then
        notify-send "OCR" "Текст не найден" -i dialog-warning -t 3000
        return 1
    fi

    printf '%s' "$text" | wl-copy
}

# ── базовые зависимости ───────────────────────────────────────────────────────
need grim slurp wl-copy notify-send

# ─────────────────────────────────────────────────────────────────────────────
# РЕЖИМ --ocr: выделяем → OCR → текст в буфер, файл не создаётся
# ─────────────────────────────────────────────────────────────────────────────
if [[ "${1:-}" == "--ocr" ]]; then
    need tesseract

    RAW=$(slurp "${SLURP_ARGS[@]}" 2>/dev/null) || exit 0
    [[ -z "$RAW" ]] && exit 0

    TMPFILE=$(mktemp /tmp/ocr-XXXXXX.png)
    trap 'rm -f "$TMPFILE"' EXIT

    grim "${GRIM_ARGS[@]}" -g "$(trim_geometry "$RAW")" "$TMPFILE" 2>/dev/null
    [[ -s "$TMPFILE" ]] || die "OCR: ошибка захвата области"

    ocr_to_clipboard "$TMPFILE"
    exit 0
fi

# ─────────────────────────────────────────────────────────────────────────────
# РЕЖИМ обычный: скриншот → сохранить → уведомление
# ─────────────────────────────────────────────────────────────────────────────
mkdir -p "$SCREENSHOT_DIR"
FILENAME="screenshot-$(date +'%Y-%m-%d-%H%M%S').png"
FILEPATH="$SCREENSHOT_DIR/$FILENAME"

RAW=$(slurp "${SLURP_ARGS[@]}" 2>/dev/null) || exit 0
[[ -z "$RAW" ]] && exit 0

grim "${GRIM_ARGS[@]}" -g "$(trim_geometry "$RAW")" "$FILEPATH" 2>/dev/null

if [[ ! -s "$FILEPATH" ]]; then
    rm -f "$FILEPATH"
    die "Скриншот: ошибка захвата"
fi

# изображение → буфер + cliphist
wl-copy < "$FILEPATH"
{ wl-paste | cliphist store; } 2>/dev/null || true

# ── уведомление ──────────────────────────────────────────────────────────────
ACTION=$(notify-send "Скриншот сохранён" "$FILENAME" \
    -i "$FILEPATH" \
    -t 7000 \
    -A "default=Открыть папку" \
    -A "edit=Редактировать" \
    -A "ocr=Копировать текст")

case "${ACTION:-}" in
    default) open_folder "$FILEPATH" ;;
    edit)    open_editor "$FILEPATH" ;;
    ocr)     ocr_to_clipboard "$FILEPATH" ;;
esac

exit 0
