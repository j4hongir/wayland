#!/usr/bin/env bash
sleep 1
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=Hyprland
systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
sleep 1
systemctl --user restart xdg-desktop-portal-hyprland
sleep 2
systemctl --user restart xdg-desktop-portal
