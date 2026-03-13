#!/bin/bash
# ss-search — search screenshots by ocr text
#
# usage:
#   ss-search              fzf tui with image preview
#   ss-search --wofi       wofi launcher with thumbnails
#   ss-search --index      build txt sidecars for existing pngs
#   ss-search --list       print tsv to stdout (used internally by fzf reload)
#   ss-search "query"      open fzf with pre-filled query
#
# deps:
#   required   : ripgrep fzf tesseract tesseract-data-rus
#   fzf preview: chafa
#   wofi mode  : wofi imagemagick

set -euo pipefail

SCREENSHOT_DIR="${SCREENSHOT_DIR:-$HOME/Pictures/screens}"
export SCREENSHOT_DIR  # needed when fzf reload calls $0 --list in a new shell

OCR_LANG="${OCR_LANG:-rus+eng}"
THUMBS_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/ss-search/thumbs"

die()  { printf 'ss-search: %s\n' "$*" >&2; exit 1; }
need() { command -v "$1" &>/dev/null || die "missing: $1  (pacman -S $2)"; }

run_ocr() {
    tesseract "$1" - -l "$OCR_LANG" --psm 3 2>/dev/null \
        | grep -v '^[[:space:]]*$' \
        | sed 's/[[:space:]]\+/ /g; s/^ //; s/ $//'
}

# returns path to cached 300x200 thumbnail, creates if missing
thumb() {
    local hash; hash=$(printf '%s' "$1" | md5sum | cut -d' ' -f1)
    local out="$THUMBS_DIR/${hash}.jpg"
    [[ -f "$out" ]] || convert "$1" -resize 300x200^ -gravity center \
        -extent 300x200 -quality 75 "$out" 2>/dev/null
    printf '%s' "$out"
}

# --index: ocr all pngs that have no txt sidecar yet
if [[ "${1:-}" == "--index" ]]; then
    need tesseract tesseract
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

# --list: emit tsv for fzf — called directly and via fzf reload
if [[ "${1:-}" == "--list" ]]; then
    while IFS= read -r txt; do
        png="${txt%.txt}.png"
        [[ -f "$png" ]] || continue
        # parse date/time from filename without spawning grep
        base=$(basename "$txt" .txt)  # screenshot-2026-01-19-214210
        dt="${base#screenshot-}"      # 2026-01-19-214210
        stamp="${dt:0:10} ${dt:11:2}:${dt:13:2}:${dt:15:2}"
        snippet=$(head -3 "$txt" | tr '\n' ' ' | cut -c1-80)
        printf '%s\t%s\t%s\n' "$png" "$stamp" "$snippet"
    done < <(find "$SCREENSHOT_DIR" -name "screenshot-*.txt" -type f | sort -r)
    exit 0
fi

# --wofi: graphical launcher with thumbnails
if [[ "${1:-}" == "--wofi" ]]; then
    need wofi wofi
    need convert imagemagick
    mkdir -p "$THUMBS_DIR"

    # wofi --allow-images expects "img:PATH:text:LABEL" format
    # embed png path inside the label (after a tab) so we can extract it after selection
    declare -a lines=()
    while IFS=$'\t' read -r png stamp snippet; do
        t=$(thumb "$png")
        lines+=( "img:${t}:text:${stamp}	${png}" )
    done < <("$0" --list)

    [[ ${#lines[@]} -eq 0 ]] && {
        notify-send "ss-search" "no indexed screenshots — run: ss-search --index" -t 4000
        exit 0
    }

    selected=$(printf '%s\n' "${lines[@]}" \
        | wofi --dmenu \
               --prompt "screenshots" \
               --insensitive \
               --allow-images \
               --cache-file /dev/null \
               --width 640 \
               --height 520) || exit 0

    [[ -z "$selected" ]] && exit 0

    # extract the embedded png path (after the tab in the label portion)
    png=$(printf '%s' "$selected" | awk -F'\t' '{print $NF}')
    [[ -f "$png" ]] && xdg-open "$png"
    exit 0
fi

# default: fzf tui
need fzf fzf
need rg ripgrep

[[ -d "$SCREENSHOT_DIR" ]] || die "directory not found: $SCREENSHOT_DIR"

txt_count=$(find "$SCREENSHOT_DIR" -name "screenshot-*.txt" -type f 2>/dev/null | wc -l)
if (( txt_count == 0 )); then
    printf 'no indexed screenshots found — running indexer...\n'
    "$0" --index
fi

# fzf preview script — uses {1} (first tsv field = png path) directly
# chafa renders the image in-terminal; falls back to plain text
read -r -d '' PREVIEW <<'EOF' || true
png={1}
txt="${png%.png}.txt"
if command -v chafa &>/dev/null; then
    chafa --size="${FZF_PREVIEW_COLUMNS}x$(( FZF_PREVIEW_LINES - 6 ))" \
          --stretch "$png" 2>/dev/null
    printf '\n%.0s─' $(seq 1 "${FZF_PREVIEW_COLUMNS}")
    printf '\n'
fi
cat "$txt" 2>/dev/null | head -30
EOF

selected=$("$0" --list \
    | fzf \
        --delimiter=$'\t' \
        --with-nth='2,3' \
        --prompt='screenshots > ' \
        --preview="$PREVIEW" \
        --preview-window='right:45%:wrap' \
        --header='enter: open  c-t: copy text  c-y: copy image  c-x: delete' \
        --bind="ctrl-t:execute-silent(cat {1/.}.txt 2>/dev/null | wl-copy)+abort" \
        --bind="ctrl-y:execute-silent(wl-copy < {1})+abort" \
        --bind="ctrl-o:execute-silent(xdg-open {1})+abort" \
        --bind="ctrl-x:execute-silent(rm -f {1} {1/.}.txt)+reload($0 --list)" \
        --height=90% \
        --info=inline \
        --query="${1:-}") || exit 0

[[ -z "$selected" ]] && exit 0
xdg-open "$(printf '%s' "$selected" | cut -f1)"

