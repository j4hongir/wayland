cp -r config/* ~/.config/

sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/paru.git
cd paru && makepkg -si


sudo pacman -S --needed \
  bat bluez bluez-utils chromium cliphist docker efibootmgr eza fzf git \
  github-cli grim gst-plugin-pipewire helix hypridle hyprland hyprlock \
  hyprpicker intel-ucode kitty libpulse linux linux-firmware macchina \
  mission-center mpv nautilus ncdu neovim networkmanager obsidian openvpn \
  pipewire pipewire-alsa pipewire-jack pipewire-pulse power-profiles-daemon \
  ripgrep sddm slurp sof-firmware starship sudo swappy swaync tmux tree \
  ttf-liberation virtualbox waybar wireplumber wpa_supplicant \
  xdg-desktop-portal-hyprland yazi zram-generator zsh

paru -S --needed antigravity easygamma-git happ-desktop-bin onlyoffice-bin tofi

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim \
  --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

gsettings set org.gnome.desktop.interface gtk-theme 'gtk'
gsettings set org.gnome.desktop.interface cursor-theme 'cursor'
