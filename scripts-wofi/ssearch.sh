#!/bin/bash
set -euo pipefail

SCREENSHOT_DIR="${SCREENSHOT_DIR:-$HOME/Pictures/screens}"
export SCREENSHOT_DIR
OCR_LANG="${OCR_LANG:-rus+eng}"

die() { printf 'ss-search: %s\n' "$*" >&2; exit 1; }

run_ocr() {
    tesseract "$1" - -l "$OCR_LANG" --psm 3 2>/dev/null \
        | grep -v '^[[:space:]]*$' \
        | sed 's/[[:space:]]\+/ /g; s/^ //; s/ $//'
}

# --index
if [[ "${1:-}" == "--index" ]]; then
    declare -i total=0 done=0
    total=$(find "$SCREENSHOT_DIR" -name "screenshot-*.png" -type f | wc -l)
    while IFS= read -r png; do
        txt="${png%.png}.txt"
        [[ -f "$txt" ]] && continue
        (( done++ )) || true
        printf '\r[%d/%d] %s' "$done" "$total" "$(basename "$png")"
        run_ocr "$png" > "$txt" 2>/dev/null || true
    done < <(find "$SCREENSHOT_DIR" -name "screenshot-*.png" -type f | sort)
    printf '\ndone. indexed %d new files out of %d total\n' "$done" "$total"
    exit 0
fi

# --list
if [[ "${1:-}" == "--list" ]]; then
    while IFS= read -r txt; do
        png="${txt%.txt}.png"
        [[ -f "$png" ]] || continue
        base=$(basename "$txt" .txt)
        dt="${base#screenshot-}"
        stamp="${dt:0:10} ${dt:11:2}:${dt:13:2}:${dt:15:2}"
        snippet=$(head -3 "$txt" | tr '\n' ' ' | cut -c1-120)
        printf '%s\t%s\t%s\n' "$png" "$stamp" "$snippet"
    done < <(find "$SCREENSHOT_DIR" -name "screenshot-*.txt" -type f | sort -r)
    exit 0
fi

# default: tofi
[[ -d "$SCREENSHOT_DIR" ]] || die "directory not found: $SCREENSHOT_DIR"

txt_count=$(find "$SCREENSHOT_DIR" -name "screenshot-*.txt" -type f 2>/dev/null | wc -l)
if (( txt_count == 0 )); then
    printf 'no indexed screenshots — running indexer...\n'
    "$0" --index
fi

selected=$(
    "$0" --list | while IFS=$'\t' read -r png stamp snippet; do
        clean=$(printf '%s' "$snippet" | iconv -f utf-8 -t utf-8 -c 2>/dev/null | tr '\t\n' '  ')
        printf '%s  |  %s\t%s\n' "$stamp" "$clean" "$png"
    done \
    | tofi --prompt-text "> " \
           --fuzzy-match true \
           --auto-accept-single false \
           --width 1100 \
           --height 600
) || exit 0

[[ -z "$selected" ]] && exit 0

png=$(printf '%s' "$selected" | awk -F'\t' '{print $NF}')
if [[ -f "$png" ]]; then
    txt="${png%.png}.txt"
    [[ -f "$txt" ]] && cat "$txt" | iconv -f utf-8 -t utf-8 -c | wl-copy
    xdg-open "$png"
fi
