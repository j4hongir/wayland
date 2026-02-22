#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKGLIST="$DIR/package.list"

G='\033[0;32m' Y='\033[1;33m' R='\033[0;31m' C='\033[0;36m' N='\033[0m'
ok()   { echo -e "${G}✓${N} $*"; }
info() { echo -e "${C}→${N} $*"; }
warn() { echo -e "${Y}⚠${N}  $*"; }
die()  { echo -e "${R}✗${N} $*" >&2; exit 1; }

[[ $EUID -ne 0 ]] || die "Не от root!"
command -v pacman &>/dev/null || die "Только Arch!"
[[ -f "$PKGLIST" ]] || die "Нет package.list"

pkgs=()
while IFS= read -r line; do
    line="${line%%#*}"
    line="${line// /}"
    line="${line//	/}"
    [[ -z "$line" ]] && continue
    pkgs+=("$line")
done < "$PKGLIST"

sudo pacman -Sy --noconfirm 2>&1 | tail -3

repo_all=$(pacman -Ssq 2>/dev/null | sort -u)
installed=$(pacman -Qq 2>/dev/null | sort -u)
official=(); aur=(); skip=0

for pkg in "${pkgs[@]}"; do
    if echo "$installed" | grep -qx "$pkg" 2>/dev/null; then
        skip=$((skip+1)); continue
    fi
    if echo "$repo_all" | grep -qx "$pkg" 2>/dev/null; then
        official+=("$pkg")
    else
        aur+=("$pkg")
    fi
done

ok "Уже: $skip | Official: ${#official[@]} | AUR: ${#aur[@]}"

[[ ${#official[@]} -gt 0 ]] && \
    sudo pacman -S --needed --noconfirm "${official[@]}" 2>&1 \
    | grep -E "^(error:|warning:)" || true

if [[ ${#aur[@]} -gt 0 ]]; then
    aur_bin=""
    command -v yay  &>/dev/null && aur_bin="yay"
    command -v paru &>/dev/null && aur_bin="${aur_bin:-paru}"
    if [[ -z "$aur_bin" ]]; then
        sudo pacman -S --needed --noconfirm git base-devel 2>/dev/null || true
        tmp=$(mktemp -d)
        git clone --depth=1 https://aur.archlinux.org/yay.git "$tmp/yay"
        (cd "$tmp/yay" && makepkg -si --noconfirm)
        rm -rf "$tmp"
        aur_bin="yay"
    fi
    failed=()
    for pkg in "${aur[@]}"; do
        "$aur_bin" -S --needed --noconfirm "$pkg" 2>&1 | tail -1 || failed+=("$pkg")
    done
    [[ ${#failed[@]} -gt 0 ]] && warn "Не установлено: ${failed[*]}"
fi

for svc in NetworkManager bluetooth sddm tlp; do
    [[ -f "/usr/lib/systemd/system/${svc}.service" ]] && \
        sudo systemctl enable "$svc" 2>/dev/null && ok "enabled: $svc" || true
done
sudo loginctl enable-linger "$USER" 2>/dev/null || true

link() {
    local src="$1" dst="$2"
    [[ -e "$src" || -d "$src" ]] || { warn "Нет: $src"; return; }
    mkdir -p "$(dirname "$dst")"
    [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]] && return
    [[ -e "$dst" && ! -L "$dst" ]] && mv "$dst" "${dst}.bak"
    ln -sf "$src" "$dst"
    ok "→ $dst"
}

C="$DIR/config"

link "$C/hypr"          "$HOME/.config/hypr"
link "$C/sway"          "$HOME/.config/sway"
link "$C/waybar"        "$HOME/.config/waybar"
link "$C/kitty"         "$HOME/.config/kitty"
link "$C/nvim"          "$HOME/.config/nvim"
link "$C/helix"         "$HOME/.config/helix"
link "$C/wofi"          "$HOME/.config/wofi"
link "$C/tofi"          "$HOME/.config/tofi"
link "$C/swaync"        "$HOME/.config/swaync"
link "$C/swaylock"      "$HOME/.config/swaylock"
link "$C/btop"          "$HOME/.config/btop"
link "$C/cava"          "$HOME/.config/cava"
link "$C/macchina"      "$HOME/.config/macchina"
link "$C/gtk-3.0"       "$HOME/.config/gtk-3.0"
link "$C/gtk-4.0"       "$HOME/.config/gtk-4.0"
link "$C/starship.toml" "$HOME/.config/starship.toml"
link "$C/mimeapps.list" "$HOME/.config/mimeapps.list"
link "$C/.tmux.conf"    "$HOME/.tmux.conf"

mkdir -p "$HOME/.local/share/themes" "$HOME/.local/share/icons"
link "$DIR/themes/gruvbox-dark-gtk" "$HOME/.local/share/themes/gruvbox-dark-gtk"
link "$DIR/themes/gruvbox-cursor"   "$HOME/.local/share/icons/gruvbox-cursor"

[[ "$DIR" != "$HOME/wayland" ]] && link "$DIR" "$HOME/wayland"

[[ -f "$C/pacman.conf" ]] && sudo cp "$C/pacman.conf" /etc/pacman.conf && ok "→ /etc/pacman.conf"
[[ -f "$C/tlp.conf" ]]    && sudo cp "$C/tlp.conf"    /etc/tlp.conf    && ok "→ /etc/tlp.conf"

find "$DIR/scripts" "$DIR/smth" "$DIR/old" -name "*.sh" -type f 2>/dev/null -exec chmod +x {} \;

ZSHRC="$HOME/.zshrc"
[[ -f "$ZSHRC" ]] || touch "$ZSHRC"
grep -qF "starship init" "$ZSHRC" 2>/dev/null || printf '\neval "$(starship init zsh)"\n' >> "$ZSHRC"

command -v zsh &>/dev/null && [[ "$SHELL" != "$(command -v zsh)" ]] && chsh -s "$(command -v zsh)" "$USER"

for grp in seat video input; do
    getent group "$grp" &>/dev/null && sudo usermod -aG "$grp" "$USER" 2>/dev/null || true
done

ok "Готово — sudo reboot"
