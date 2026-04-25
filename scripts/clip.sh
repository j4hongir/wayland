#!/bin/bash

selected=$(cliphist list | tofi --auto-accept-single false --prompt-text "> " 2>/dev/null)

[[ -z "$selected" ]] && exit 0

if echo "$selected" | grep -qE '\[(image|binary)'; then
    cliphist decode <<< "$selected" | wl-copy --type image/png
else
    cliphist decode <<< "$selected" | wl-copy
fi
