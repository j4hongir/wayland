#!/bin/bash

if ! command -v fzf >/dev/null 2>&1; then
    echo "fzf not installed"
    exit 1
fi

if [ -z "$TMUX" ]; then
    selected_session=$(tmux list-sessions -F "#{session_name}: #{session_windows} window#{?session_attached, (connaction),}" 2>/dev/null | \
        fzf --reverse --header="tmux sessions" --header-first | \
        cut -d':' -f1)
    
    if [ -n "$selected_session" ]; then
        tmux attach-session -t "$selected_session"
    else
        echo "session not selected"
        exit 0
    fi
else
    selected_session=$(tmux list-sessions -F "#{session_name}: #{session_windows} window#{?session_attached, (connaction),}" | \
        fzf --reverse --header="tmux sessions" --header-first | \
        cut -d':' -f1)
    
    if [ -n "$selected_session" ]; then
        tmux switch-client -t "$selected_session"
    else
        echo "session not selected"
        exit 0
    fi
fi
