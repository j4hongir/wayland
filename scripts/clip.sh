#!/bin/bash

selected=$(cliphist list | tofi --auto-accept-single false --prompt-text "> " 2>/dev/null)

[[ -z "$selected" ]] && exit 0

# Проверяем — это текст или бинарь
if echo "$selected" | grep -qE '\[(image|binary)'; then
    # Для картинок — декодируем напрямую без промежуточного pipe
    cliphist decode <<< "$selected" | wl-copy --type image/png
else
    cliphist decode <<< "$selected" | wl-copy
fi
