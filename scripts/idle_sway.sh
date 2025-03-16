
exec_always swayidle -w \
    timeout 600 'swaylock -f -i ~/wayland/walls/gruvwall.png' \
    timeout 615 'swaymsg "output * dpms off"' \
        resume 'swaymsg "output * dpms on"' \
    timeout 620 'systemctl suspend' \
    before-sleep 'swaylock -f -i ~/wayland/walls/gruvwall.png'
