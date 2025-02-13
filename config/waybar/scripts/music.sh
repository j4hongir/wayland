#!/bin/bash
# Save as ~/.config/waybar/scripts/music.sh

# Get player status and redirect stderr to /dev/null
STATUS=$(playerctl status 2>/dev/null)

# Get exit status of the previous command
STATUS_EXIT_CODE=$?

# Check if any player is running
if [ $STATUS_EXIT_CODE -eq 0 ]; then
    # Get current track info with error redirection
    ARTIST=$(playerctl metadata artist 2>/dev/null)
    TITLE=$(playerctl metadata title 2>/dev/null)
    
    # Set icons based on player status
    if [ "$STATUS" = "Playing" ]; then
        ICON=" 󰎈"
    else
        ICON=" 󰏤"
    fi
    
    # Output format
    if [ -n "$ARTIST" ]; then
        echo "$ICON $ARTIST - $TITLE"
    else
        echo "$ICON $TITLE"
    fi
else
    # If no player is running or available
    echo "󰎇"
fi
