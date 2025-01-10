#!/bin/sh

prev_focus=""

# Подписываемся на события Sway
swaymsg -m -t subscribe '["window"]' | \
  jq --unbuffered 'select(.change == "focus").container.id' | \
  while read new_focus; do
    if [ -n "$prev_focus" ]; then
      swaymsg "[con_id=${prev_focus}] mark --add _prev" &>/dev/null
    fi
    prev_focus=$new_focus
  done
