#!/usr/bin/env bash
sleep 1
killall -e xdg-desktop-portal-wlr
killall xdg-desktop-portal
/usr/lib/xdg-desktop-portal-wlr &
sleep 2
/usr/lib/xdg-desktop-portal &


export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

export XDG_CURRENT_DESKTOP=hyprland  
export XDG_SESSION_DESKTOP=hyprland  
export XDG_SESSION_TYPE=wayland 

export WAYLAND_DISPLAY=wayland-1
export MOZ_ENABLE_WAYLAND=1 
export QT_QPA_PLATFORM=wayland 
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
export GDK_BACKEND=wayland 
export SDL_VIDEODRIVER=wayland 
export _JAVA_AWT_WM_NONREPARENTING=1 
export CLUTTER_BACKEND=wayland 

export XWAYLAND_NO_GRAB=1

export GTK_THEME=Gruvbox-Dark 

export WLR_NO_HARDWARE_CURSORS=1 
