#!/bin/bash

# ============================================================================
# Arch Linux Wayland Environment Installation Script (Improved)
# ============================================================================

set -e  # Exit on error

# Colors
readonly GREEN='\033[0;32m'
readonly BLUE='\033[0;34m'
readonly RED='\033[0;31m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m'

# Directories
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly CONFIG_DIR="${SCRIPT_DIR}/config"
readonly LOG_FILE="${HOME}/.install_wayland.log"
readonly BACKUP_DIR="${HOME}/.config_backup_$(date +%Y%m%d_%H%M%S)"

# ============================================================================
# Helper Functions
# ============================================================================

log() {
    echo -e "${2:-$NC}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}" | tee -a "$LOG_FILE"
}

log_error() {
    log "ERROR: $1" "$RED" >&2
}

log_success() {
    log "✓ $1" "$GREEN"
}

log_info() {
    log "→ $1" "$BLUE"
}

log_warning() {
    log "⚠ $1" "$YELLOW"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Prompt user for confirmation
confirm() {
    local prompt="${1:-Continue?}"
    local response
    read -r -p "$(echo -e ${YELLOW}${prompt} [y/N]:${NC} )" response
    [[ "$response" =~ ^[Yy]$ ]]
}

# Backup existing config
backup_config() {
    if [ -d "$HOME/.config" ]; then
        log_info "Creating backup of existing config..."
        mkdir -p "$BACKUP_DIR"
        
        # Backup only directories that will be overwritten
        for dir in "$CONFIG_DIR"/*; do
            local dirname=$(basename "$dir")
            if [ -d "$HOME/.config/$dirname" ]; then
                cp -r "$HOME/.config/$dirname" "$BACKUP_DIR/"
                log_success "Backed up ~/.config/$dirname"
            fi
        done
        
        log_success "Backup created at: $BACKUP_DIR"
    fi
}

# Parse package.list file
parse_package_list() {
    local section="$1"
    local packages=()
    local in_section=false
    
    while IFS= read -r line; do
        # Remove comments and whitespace
        line=$(echo "$line" | sed 's/#.*//' | xargs)
        
        # Skip empty lines
        [ -z "$line" ] && continue
        
        # Check for section markers
        if [[ "$line" =~ ^\[.*\]$ ]]; then
            if [[ "$line" == "[$section]" ]]; then
                in_section=true
            else
                in_section=false
            fi
            continue
        fi
        
        # Add package if in correct section
        if [ "$in_section" = true ]; then
            packages+=("$line")
        fi
    done < "${SCRIPT_DIR}/package.list"
    
    echo "${packages[@]}"
}

# Install official packages
install_official_packages() {
    log_info "Reading official packages from package.list..."
    local packages=($(parse_package_list "official"))
    
    if [ ${#packages[@]} -eq 0 ]; then
        log_warning "No official packages found in package.list"
        return
    fi
    
    log_info "Found ${#packages[@]} official packages"
    log_info "Packages: ${packages[*]}"
    
    if confirm "Install official packages?"; then
        log_info "Updating system..."
        sudo pacman -Syu --noconfirm
        
        log_info "Installing official packages..."
        if sudo pacman -S --needed --noconfirm "${packages[@]}"; then
            log_success "Official packages installed successfully"
        else
            log_error "Failed to install some official packages"
            return 1
        fi
    fi
}

# Install yay AUR helper
install_yay() {
    if command_exists yay; then
        log_success "yay is already installed"
        return 0
    fi
    
    log_info "Installing yay AUR helper..."
    
    # Install base-devel if not present
    if ! pacman -Qq base-devel &>/dev/null; then
        sudo pacman -S --needed --noconfirm base-devel
    fi
    
    local yay_dir="/tmp/yay_$$"
    git clone https://aur.archlinux.org/yay.git "$yay_dir"
    
    if (cd "$yay_dir" && makepkg -si --noconfirm); then
        rm -rf "$yay_dir"
        log_success "yay installed successfully"
    else
        rm -rf "$yay_dir"
        log_error "Failed to install yay"
        return 1
    fi
}

# Install AUR packages
install_aur_packages() {
    if ! command_exists yay; then
        log_error "yay is not installed. Cannot install AUR packages."
        return 1
    fi
    
    log_info "Reading AUR packages from package.list..."
    local packages=($(parse_package_list "aur"))
    
    if [ ${#packages[@]} -eq 0 ]; then
        log_warning "No AUR packages found in package.list"
        return
    fi
    
    log_info "Found ${#packages[@]} AUR packages"
    log_info "Packages: ${packages[*]}"
    
    if confirm "Install AUR packages?"; then
        log_info "Installing AUR packages..."
        if yay -S --needed --noconfirm "${packages[@]}"; then
            log_success "AUR packages installed successfully"
        else
            log_error "Failed to install some AUR packages"
            return 1
        fi
    fi
}

# Copy configuration files
copy_configs() {
    if [ ! -d "$CONFIG_DIR" ]; then
        log_error "Config directory not found: $CONFIG_DIR"
        return 1
    fi
    
    log_info "Copying configuration files..."
    
    if confirm "Copy configuration files? (Existing configs will be backed up)"; then
        backup_config
        
        if cp -r "$CONFIG_DIR"/* "$HOME/.config/"; then
            log_success "Configuration files copied successfully"
        else
            log_error "Failed to copy configuration files"
            return 1
        fi
    fi
}

# Setup ZSH plugins
setup_zsh() {
    if ! command_exists zsh; then
        log_warning "ZSH is not installed. Skipping ZSH setup."
        return
    fi
    
    log_info "Setting up ZSH plugins..."
    
    local plugins=(
        "zsh-autosuggestions:https://github.com/zsh-users/zsh-autosuggestions"
        "zsh-syntax-highlighting:https://github.com/zsh-users/zsh-syntax-highlighting.git"
        "fzf-tab:https://github.com/Aloxaf/fzf-tab"
    )
    
    for plugin in "${plugins[@]}"; do
        local name="${plugin%%:*}"
        local url="${plugin#*:}"
        local target="$HOME/.config/$name"
        
        if [ -d "$target" ]; then
            log_success "$name already installed"
        else
            log_info "Installing $name..."
            if git clone "$url" "$target"; then
                log_success "$name installed"
            else
                log_error "Failed to install $name"
            fi
        fi
    done
    
    # Set ZSH as default shell
    if [ "$SHELL" != "$(which zsh)" ]; then
        if confirm "Set ZSH as default shell?"; then
            chsh -s "$(which zsh)"
            log_success "ZSH set as default shell"
        fi
    fi
}

# Install Starship prompt
install_starship() {
    if command_exists starship; then
        log_success "Starship is already installed"
        return 0
    fi
    
    log_info "Installing Starship prompt..."
    if curl -sS https://starship.rs/install.sh | sh -s -- -y; then
        log_success "Starship installed successfully"
    else
        log_error "Failed to install Starship"
        return 1
    fi
}

# Install vim-plug for Neovim
install_vim_plug() {
    local plug_file="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim"
    
    if [ -f "$plug_file" ]; then
        log_success "vim-plug is already installed"
        return 0
    fi
    
    log_info "Installing vim-plug..."
    if curl -fLo "$plug_file" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim; then
        log_success "vim-plug installed successfully"
    else
        log_error "Failed to install vim-plug"
        return 1
    fi
}

# Configure GTK settings
configure_gtk() {
    if ! command_exists gsettings; then
        log_warning "gsettings not found. Skipping GTK configuration."
        return
    fi
    
    log_info "Configuring GTK settings..."
    
    local settings=(
        "org.gnome.desktop.interface:cursor-theme:Vimix-cursors"
        "org.gnome.desktop.interface:color-scheme:prefer-dark"
        "org.gnome.desktop.interface:gtk-theme:Gruvbox-Dark"
        "org.gnome.desktop.interface:icon-theme:gruvbox-dark-icons-gtk"
    )
    
    for setting in "${settings[@]}"; do
        local schema="${setting%%:*}"
        local rest="${setting#*:}"
        local key="${rest%%:*}"
        local value="${rest#*:}"
        
        if gsettings set "$schema" "$key" "$value" 2>/dev/null; then
            log_success "Set $key to $value"
        else
            log_warning "Failed to set $key"
        fi
    done
}

# Install Gruvbox theme
install_gruvbox_theme() {
    local theme_dir="$HOME/.themes/Gruvbox-Dark"
    
    if [ -d "$theme_dir" ]; then
        log_success "Gruvbox-Dark theme already installed"
        return 0
    fi
    
    if [ -d "${SCRIPT_DIR}/Gruvbox-Dark" ]; then
        log_info "Installing Gruvbox-Dark theme..."
        mkdir -p "$HOME/.themes"
        cp -r "${SCRIPT_DIR}/Gruvbox-Dark" "$theme_dir"
        log_success "Gruvbox-Dark theme installed"
    else
        log_warning "Gruvbox-Dark directory not found in script directory"
    fi
}

# Install custom applications
install_custom_apps() {
    log_info "Installing custom applications..."
    
    # Install tenki (weather app)
    if ! command_exists tenki; then
        log_info "Installing tenki..."
        local tenki_dir="/tmp/tenki_$$"
        if git clone https://github.com/ckaznable/tenki "$tenki_dir"; then
            if (cd "$tenki_dir" && make build && sudo make install); then
                log_success "tenki installed successfully"
            else
                log_error "Failed to build/install tenki"
            fi
            rm -rf "$tenki_dir"
        else
            log_error "Failed to clone tenki repository"
        fi
    else
        log_success "tenki is already installed"
    fi
    
    # Clone Dashboard
    local dashboard_dir="$HOME/Dashboard"
    if [ ! -d "$dashboard_dir" ]; then
        log_info "Cloning Dashboard..."
        if git clone https://github.com/Jahamars/Dashboard.git "$dashboard_dir"; then
            log_success "Dashboard cloned to $dashboard_dir"
        else
            log_error "Failed to clone Dashboard"
        fi
    else
        log_success "Dashboard already exists"
    fi
}

# Enable system services
enable_services() {
    log_info "Enabling system services..."
    
    local services=(
        "NetworkManager"
        "bluetooth"
        "tlp"
    )
    
    for service in "${services[@]}"; do
        if systemctl is-enabled "$service" &>/dev/null; then
            log_success "$service is already enabled"
        else
            if sudo systemctl enable "$service" 2>/dev/null; then
                log_success "Enabled $service"
            else
                log_warning "Failed to enable $service (may not be installed)"
            fi
        fi
    done
}

# Print post-installation instructions
print_post_install() {
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║         Installation Completed Successfully!              ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${BLUE}Next steps:${NC}"
    echo "  1. Reboot your system: sudo reboot"
    echo "  2. Select Hyprland or Sway from your display manager"
    echo "  3. Open Neovim and run :PlugInstall to install plugins"
    echo "  4. Check Dashboard in ~/Dashboard directory"
    echo ""
    echo -e "${BLUE}Useful commands:${NC}"
    echo "  • View logs: cat $LOG_FILE"
    echo "  • Restore backup: cp -r $BACKUP_DIR/* ~/.config/"
    echo "  • Update packages: yay -Syu"
    echo ""
    echo -e "${YELLOW}Note: Some changes require a system reboot to take effect.${NC}"
    echo ""
}

# ============================================================================
# Main Installation Flow
# ============================================================================

main() {
    log_info "Starting Wayland environment installation..."
    log_info "Script directory: $SCRIPT_DIR"
    log_info "Log file: $LOG_FILE"
    
    # Check if running on Arch Linux
    if [ ! -f /etc/arch-release ]; then
        log_error "This script is designed for Arch Linux"
        exit 1
    fi
    
    # Check if package.list exists
    if [ ! -f "${SCRIPT_DIR}/package.list" ]; then
        log_error "package.list not found in script directory"
        exit 1
    fi
    
    echo -e "${BLUE}"
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║     Arch Linux Wayland Environment Installation           ║"
    echo "║                                                            ║"
    echo "║  This script will:                                         ║"
    echo "║  • Install system packages from package.list               ║"
    echo "║  • Setup Hyprland/Sway window managers                     ║"
    echo "║  • Configure development environment                       ║"
    echo "║  • Install themes and customizations                       ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    if ! confirm "Do you want to continue with the installation?"; then
        log_info "Installation cancelled by user"
        exit 0
    fi
    
    # Installation steps
    install_official_packages || log_warning "Some official packages failed to install"
    install_yay || log_error "Failed to install yay. Cannot continue with AUR packages."
    install_aur_packages || log_warning "Some AUR packages failed to install"
    
    copy_configs || log_error "Failed to copy configuration files"
    install_gruvbox_theme
    
    setup_zsh
    install_starship
    install_vim_plug
    
    configure_gtk
    install_custom_apps
    enable_services
    
    print_post_install
}

# Run main function
main "$@"
