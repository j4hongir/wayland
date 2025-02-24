export XDG_CURRENT_DESKTOP=sway # xdg-desktop-portal
export XDG_SESSION_DESKTOP=sway # systemd
export XDG_SESSION_TYPE=wayland # xdg/systemd
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"


# Основные настройки для Wayland
export WAYLAND_DISPLAY=wayland-1
export MOZ_ENABLE_WAYLAND=1 # для Firefox
export QT_QPA_PLATFORM=wayland # для Qt приложений
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
export GDK_BACKEND=wayland # для GTK приложений
export SDL_VIDEODRIVER=wayland # для SDL2 приложений
export _JAVA_AWT_WM_NONREPARENTING=1 # для Java приложений
export CLUTTER_BACKEND=wayland # для Clutter

# Для улучшения совместимости с X11
export XWAYLAND_NO_GRAB=1

# Для корректной работы GTK
export GTK_THEME=Gruvbox-Dark # замените на ваш темы

# Для улучшения производительности
export WLR_NO_HARDWARE_CURSORS=1 # если есть проблемы с курсором
