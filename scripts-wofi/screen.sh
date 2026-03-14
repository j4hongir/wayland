#!/bin/bash
# screen.sh — screenshot + ocr | wayland (grim · slurp · tesseract)
#
# usage:
#   screen.sh        capture area → save png + txt sidecar → notify
#   screen.sh --ocr  capture area → ocr → clipboard (no file)
#
# env:
#   SCREENSHOT_DIR   save location   (default: ~/Pictures/screens)
#   OCR_LANG         tesseract langs  (default: rus+eng)
#   EDITOR_APP       image editor     (default: swappy → gimp → xdg-open)

set -euo pipefail

SCREENSHOT_DIR="${SCREENSHOT_DIR:-$HOME/Pictures/screens}"
OCR_LANG="${OCR_LANG:-rus+eng}"
SLURP_ARGS=(-d -b 1B1F2866 -c 89b4faff -w 1)
GRIM_ARGS=(-t png -l 3)

die()  { notify-send "screen.sh" "$1" -i dialog-error -t 4000; exit 1; }
need() { for cmd in "$@"; do command -v "$cmd" &>/dev/null || die "missing: $cmd"; done; }

open_folder() {
    local f="$1"
    if   command -v nautilus &>/dev/null; then nautilus  --select "$f" &
    elif command -v thunar   &>/dev/null; then thunar    "$(dirname "$f")" &
    elif command -v dolphin  &>/dev/null; then dolphin   --select "$f" &
    elif command -v nemo     &>/dev/null; then nemo      "$(dirname "$f")" &
    elif command -v pcmanfm  &>/dev/null; then pcmanfm   "$(dirname "$f")" &
    else xdg-open "$(dirname "$f")" &
    fi
}

open_editor() {
    local f="$1"
    if   [[ -n "${EDITOR_APP:-}" ]];    then $EDITOR_APP "$f" &
    elif command -v swappy &>/dev/null; then swappy -f "$f" &
    elif command -v gimp   &>/dev/null; then gimp   "$f" &
    else xdg-open "$f" &
    fi
}

trim_geometry() {
    awk 'BEGIN{FS="[ ,x]";OFS=""}{
        x=$1+1; y=$2+1; w=$3-2; h=$4-2
        if(w<1)w=1; if(h<1)h=1
        print x","y" "w"x"h
    }' <<< "$1"
}

run_ocr() {
    tesseract "$1" - -l "$OCR_LANG" --psm 3 2>/dev/null \
        | grep -v '^[[:space:]]*$' \
        | sed 's/[[:space:]]\+/ /g; s/^ //; s/ $//'
}

ocr_to_clipboard() {
    command -v tesseract &>/dev/null \
        || die "tesseract not found — sudo pacman -S tesseract tesseract-data-rus"

    local text
    text=$(run_ocr "$1") || true
    [[ -z "$text" ]] && { notify-send "ocr" "no text found" -i dialog-warning -t 3000; return 1; }

    printf '%s' "$text" | wl-copy
    local words; words=$(printf '%s' "$text" | wc -w)
    notify-send "ocr" "copied ${words} words" -t 2000
}

save_sidecar() {
    # always write (even if empty) so --index skips this file on re-run
    run_ocr "$1" > "${1%.png}.txt" 2>/dev/null || true
}

need grim slurp wl-copy notify-send

# --ocr: region select → clipboard, no file written
if [[ "${1:-}" == "--ocr" ]]; then
    need tesseract

    RAW=$(slurp "${SLURP_ARGS[@]}" 2>/dev/null) || exit 0
    [[ -z "$RAW" ]] && exit 0

    TMPFILE=$(mktemp /tmp/ocr-XXXXXX.png)
    trap 'rm -f "$TMPFILE"' EXIT

    grim "${GRIM_ARGS[@]}" -g "$(trim_geometry "$RAW")" "$TMPFILE" 2>/dev/null
    [[ -s "$TMPFILE" ]] || die "ocr: capture failed"

    ocr_to_clipboard "$TMPFILE"
    exit 0
fi

# default: capture → png + txt sidecar → clipboard → notify
mkdir -p "$SCREENSHOT_DIR"
FILENAME="screenshot-$(date +'%Y-%m-%d-%H%M%S').png"
FILEPATH="$SCREENSHOT_DIR/$FILENAME"

RAW=$(slurp "${SLURP_ARGS[@]}" 2>/dev/null) || exit 0
[[ -z "$RAW" ]] && exit 0

grim "${GRIM_ARGS[@]}" -g "$(trim_geometry "$RAW")" "$FILEPATH" 2>/dev/null
[[ -s "$FILEPATH" ]] || { rm -f "$FILEPATH"; die "capture failed"; }

wl-copy < "$FILEPATH"
{ wl-paste | cliphist store; } 2>/dev/null || true

# sidecar in background — does not delay the notification
command -v tesseract &>/dev/null && { save_sidecar "$FILEPATH" & disown; }

ACTION=$(notify-send "screenshot saved" "$FILENAME" \
    -i "$FILEPATH" \
    -t 7000 \
    -A "default=open folder" \
    -A "edit=edit" \
    -A "ocr=copy text")

case "${ACTION:-}" in
    default) open_folder "$FILEPATH" ;;
    edit)    open_editor "$FILEPATH" ;;
    ocr)     ocr_to_clipboard "$FILEPATH" ;;
esac

exit 0
