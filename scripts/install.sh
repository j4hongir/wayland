cp -r ~/wayland/config/* ~/.config/

mkdir -p ~/.fonts 
mkdir -p ~/.themes
mkdir -p ~/.icons

cp ~/wayland/themes/cursor ~/.icons
cp ~/wayland/themes/gtk ~/.themes
cp ~/wayland/fonts/* ~/.fonts

sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/paru.git
cd paru && makepkg -si

sudo pacman -S --needed \
  bat bluez bluez-utils brightnessctl chromium cliphist \
  eza fzf git github-cli grim helix hypridle hyprland \
  hyprlock hyprpicker kitty less swaybg swayimg pavucontrol obs-studio thermald \
  macchina mission-center mpv nautilus ncdu neovim network-manager-applet \
  nwg-look obsidian openvpn papirus-icon-theme \
  power-profiles-daemon pyenv \
  qt5ct qt6ct sddm slurp sof-firmware starship \
  swappy swaync tesseract tesseract-data-eng tesseract-data-rus tmux trash-cli \
  tree virtualbox waybar \
  xdg-desktop-portal-hyprland yazi zsh

paru -S --needed antigravity easygamma-git happ-desktop-bin onlyoffice-bin \
  pomotroid-bin themechanger-git tofi

git clone https://github.com/j4hongir/zsh-tempo.git ~/zsh-tempo
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.config/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.config/zsh-syntax-highlighting
git clone https://github.com/Aloxaf/fzf-tab ~/.config/fzf-tab


sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim \
  --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'gtk'
gsettings set org.gnome.desktop.interface cursor-theme 'cursor'
