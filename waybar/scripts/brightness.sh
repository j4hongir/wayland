#!/bin/bash
# Save as ~/.config/waybar/scripts/brightness.sh

# Get current brightness and max brightness
current=$(brightnessctl get)
max=$(brightnessctl max)

# Calculate percentage
percentage=$(( (current * 100) / max ))

# Choose icon based on brightness level
if [ "$percentage" -ge 80 ]; then
    icon=" 󰃠"
elif [ "$percentage" -ge 60 ]; then
    icon=" 󰃝"
elif [ "$percentage" -ge 40 ]; then
    icon=" 󰃟"
elif [ "$percentage" -ge 20 ]; then
    icon=" 󰃞"
else
    icon=" 󰃜"
fi

# Output current brightness with icon
echo "$icon $percentage%"
