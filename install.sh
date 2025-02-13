#!/bin/bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' 

echo -e "${GREEN}Copying configuration files...${NC}"
cp -r ~/wayland/config/* ~/.config/


echo -e "${BLUE}Starting installation...${NC}"


install_official_packages() {
    local packages=($@)
    if [ ${#packages[@]} -gt 0 ]; then
        print_msg "$BLUE" "Installing official packages..."
        sudo pacman -S --needed ${packages[@]}
    fi
}

echo -e "${GREEN}Installing yay...${NC}"
git clone https://aur.archlinux.org/yay.git ~/yay
cd ~/yay
makepkg -si
cd ..
rm -rf ~/yay


install_aur_packages() {
    local packages=($@)
    if [ ${#packages[@]} -gt 0 ]; then
        print_msg "$BLUE" "Installing AUR packages..."
        yay -S --needed ${packages[@]}
    fi
}



echo -e "${GREEN}Setting up ZSH...${NC}"
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.config/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.config/zsh-syntax-highlighting
git clone https://github.com/Aloxaf/fzf-tab ~/.config/fzf-tab


echo -e "${GREEN}Installing Starship...${NC}"
curl -sS https://starship.rs/install.sh | sh


echo -e "${GREEN}Installing vim-plug...${NC}"
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'


echo -e "${GREEN}Configuring GTK4 settings...${NC}"
gsettings set org.gnome.desktop.interface cursor-theme 'Vimix-cursors'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'Gruvbox-Dark'
gsettings set org.gnome.desktop.interface icon-theme 'gruvbox-dark-icons-gtk'


echo -e "${GREEN}Installing tenki...${NC}"
git clone https://github.com/ckaznable/tenki ~/tenki 
cd tenki
make build
make install
cd ..
rm -rf ~/tenki


echo -e "${GREEN}Installing Dashboard...${NC}"
git clone https://github.com/Jahamars/Dashboard.git ~/Dashboard 

# # Configure power button
# echo -e "${GREEN}Configuring power button...${NC}"
# sudo sh -c 'echo "HandlePowerKey=ignore" >> /etc/systemd/logind.conf'


echo -e "${BLUE}Installation completed!${NC}"
echo -e "${BLUE}Please restart your system to apply all changes.${NC}"
