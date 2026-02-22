#!/usr/bin/env bash
# ============================================================
#  dotfiles installer — wayland / arch-based
#  Usage:  bash install.sh [--dry-run] [--no-packages] [--no-symlinks]
#  Logs:   ~/dotfiles-install.log
# ============================================================

set -Euo pipefail

# ─── CONSTANTS ──────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$SCRIPT_DIR"
HOME_DIR="$HOME"
LOG_FILE="$HOME_DIR/dotfiles-install.log"
BACKUP_DIR="$HOME_DIR/.dotfiles-backup/$(date +%Y%m%d_%H%M%S)"
PACKAGE_LIST="$DOTFILES_DIR/package.list"

# AUR helper (yay preferred, falls back to paru)
AUR_HELPER=""

# ─── FLAGS ──────────────────────────────────────────────────
DRY_RUN=false
SKIP_PACKAGES=false
SKIP_SYMLINKS=false
SKIP_SERVICES=false

# ─── COLORS ─────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# ─── LOGGING ────────────────────────────────────────────────
log()  { local ts; ts=$(date '+%Y-%m-%d %H:%M:%S'); echo "[$ts] $*" | tee -a "$LOG_FILE"; }
info() { log "INFO  $*"; echo -e "${BLUE}→${NC} $*"; }
ok()   { log "OK    $*"; echo -e "${GREEN}✓${NC} $*"; }
warn() { log "WARN  $*"; echo -e "${YELLOW}⚠${NC}  $*"; }
err()  { log "ERROR $*"; echo -e "${RED}✗${NC} $*" >&2; }
die()  { err "$*"; exit 1; }
sep()  { echo -e "${CYAN}──────────────────────────────────────────${NC}"; log "--- $* ---"; }

# ─── ARG PARSING ────────────────────────────────────────────
for arg in "$@"; do
  case $arg in
    --dry-run)       DRY_RUN=true ;;
    --no-packages)   SKIP_PACKAGES=true ;;
    --no-symlinks)   SKIP_SYMLINKS=true ;;
    --no-services)   SKIP_SERVICES=true ;;
    -h|--help)
      echo "Usage: $0 [--dry-run] [--no-packages] [--no-symlinks] [--no-services]"
      echo "  --dry-run      Show what would be done, don't change anything"
      echo "  --no-packages  Skip package installation"
      echo "  --no-symlinks  Skip config symlinks"
      echo "  --no-services  Skip systemd service enabling"
      exit 0 ;;
    *) warn "Unknown argument: $arg" ;;
  esac
done

# ─── HELPERS ────────────────────────────────────────────────
run() {
  if $DRY_RUN; then
    echo -e "  ${YELLOW}[DRY]${NC} $*"
    log "DRY   $*"
  else
    log "RUN   $*"
    "$@"
  fi
}

# Backup a file/dir before touching it
backup() {
  local target="$1"
  if [[ -e "$target" || -L "$target" ]]; then
    local dest="$BACKUP_DIR/${target#$HOME_DIR/}"
    run mkdir -p "$(dirname "$dest")"
    run cp -a "$target" "$dest"
    log "BACKUP $target → $dest"
  fi
}

# Create a symlink safely (backs up existing target first)
symlink() {
  local src="$1"   # absolute path inside dotfiles repo
  local dst="$2"   # absolute destination path

  if [[ ! -e "$src" ]]; then
    warn "Source not found, skipping symlink: $src"
    return 0
  fi

  if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
    ok "Already linked: $dst"
    return 0
  fi

  backup "$dst"

  if ! $DRY_RUN; then
    rm -rf "$dst"
    mkdir -p "$(dirname "$dst")"
    ln -s "$src" "$dst"
  else
    echo -e "  ${YELLOW}[DRY]${NC} ln -s $src $dst"
  fi
  ok "Linked: $dst → $src"
}

# ─── PREFLIGHT ──────────────────────────────────────────────
preflight() {
  sep "Preflight checks"

  # Must be Arch-based
  if ! command -v pacman &>/dev/null; then
    die "pacman not found. This script only works on Arch-based distros."
  fi
  ok "pacman found"

  # Not root
  if [[ $EUID -eq 0 ]]; then
    die "Do not run as root. Run as your normal user."
  fi
  ok "Running as user: $USER"

  # dotfiles repo integrity
  [[ -d "$DOTFILES_DIR/config" ]] || die "config/ directory not found in $DOTFILES_DIR"
  ok "Dotfiles directory: $DOTFILES_DIR"

  # Create backup dir (unless dry-run)
  if ! $DRY_RUN; then
    mkdir -p "$BACKUP_DIR"
    info "Backup location: $BACKUP_DIR"
  fi

  # Detect AUR helper
  if command -v yay  &>/dev/null; then AUR_HELPER="yay"
  elif command -v paru &>/dev/null; then AUR_HELPER="paru"
  else AUR_HELPER=""
  fi
  [[ -n "$AUR_HELPER" ]] && ok "AUR helper: $AUR_HELPER" || warn "No AUR helper found (yay/paru). AUR packages will be skipped."
}

# ─── PACKAGE INSTALLATION ───────────────────────────────────
install_packages() {
  sep "Package installation"

  if [[ ! -f "$PACKAGE_LIST" ]]; then
    warn "package.list not found, skipping package install"
    return 0
  fi

  # Read package names (first column, strip version)
  local pkgs=()
  while IFS= read -r line; do
    [[ -z "$line" || "$line" =~ ^# ]] && continue
    pkgs+=( "$(echo "$line" | awk '{print $1}')" )
  done < "$PACKAGE_LIST"

  info "Total packages in list: ${#pkgs[@]}"

  # Split into official and AUR (we try official first)
  info "Updating pacman databases..."
  run sudo pacman -Sy --noconfirm 2>/dev/null || warn "pacman -Sy failed, continuing"

  local official=()
  local aur=()

  for pkg in "${pkgs[@]}"; do
    if pacman -Si "$pkg" &>/dev/null 2>&1; then
      official+=("$pkg")
    else
      aur+=("$pkg")
    fi
  done

  info "Official repo packages: ${#official[@]}"
  info "Potential AUR packages:  ${#aur[@]}"

  # Install official packages (only missing ones)
  local missing_official=()
  for pkg in "${official[@]}"; do
    pacman -Qi "$pkg" &>/dev/null 2>&1 || missing_official+=("$pkg")
  done

  if [[ ${#missing_official[@]} -gt 0 ]]; then
    info "Installing ${#missing_official[@]} missing official packages..."
    run sudo pacman -S --noconfirm --needed "${missing_official[@]}" \
      || warn "Some official packages failed to install (see log)"
  else
    ok "All official packages already installed"
  fi

  # Install AUR packages
  if [[ -n "$AUR_HELPER" && ${#aur[@]} -gt 0 ]]; then
    local missing_aur=()
    for pkg in "${aur[@]}"; do
      pacman -Qi "$pkg" &>/dev/null 2>&1 || missing_aur+=("$pkg")
    done
    if [[ ${#missing_aur[@]} -gt 0 ]]; then
      info "Installing ${#missing_aur[@]} AUR packages via $AUR_HELPER..."
      run "$AUR_HELPER" -S --noconfirm --needed "${missing_aur[@]}" \
        || warn "Some AUR packages failed to install"
    else
      ok "All AUR packages already installed"
    fi
  elif [[ ${#aur[@]} -gt 0 ]]; then
    warn "Skipping ${#aur[@]} AUR packages (no AUR helper)"
  fi
}

# ─── SYMLINKS ───────────────────────────────────────────────
# Maps: dotfiles relative path → $HOME destination
declare -A SYMLINK_MAP=(
  # hyprland
  ["config/hypr"]="$HOME_DIR/.config/hypr"
  # sway
  ["config/sway"]="$HOME_DIR/.config/sway"
  # waybar
  ["config/waybar"]="$HOME_DIR/.config/waybar"
  # kitty
  ["config/kitty"]="$HOME_DIR/.config/kitty"
  # nvim
  ["config/nvim"]="$HOME_DIR/.config/nvim"
  # helix
  ["config/helix"]="$HOME_DIR/.config/helix"
  # wofi
  ["config/wofi"]="$HOME_DIR/.config/wofi"
  # tofi
  ["config/tofi"]="$HOME_DIR/.config/tofi"
  # swaync
  ["config/swaync"]="$HOME_DIR/.config/swaync"
  # swaylock
  ["config/swaylock"]="$HOME_DIR/.config/swaylock"
  # btop
  ["config/btop"]="$HOME_DIR/.config/btop"
  # cava
  ["config/cava"]="$HOME_DIR/.config/cava"
  # macchina
  ["config/macchina"]="$HOME_DIR/.config/macchina"
  # gtk
  ["config/gtk-3.0"]="$HOME_DIR/.config/gtk-3.0"
  ["config/gtk-4.0"]="$HOME_DIR/.config/gtk-4.0"
  # starship
  ["config/starship.toml"]="$HOME_DIR/.config/starship.toml"
  # pacman
  ["config/pacman.conf"]="$HOME_DIR/.config/pacman.conf"
  # tmux
  ["config/.tmux.conf"]="$HOME_DIR/.tmux.conf"
  # mimeapps
  ["config/mimeapps.list"]="$HOME_DIR/.config/mimeapps.list"
  # scripts (keep in wayland/scripts, just make scripts executable)
)

create_symlinks() {
  sep "Creating symlinks"

  for rel_src in "${!SYMLINK_MAP[@]}"; do
    local abs_src="$DOTFILES_DIR/$rel_src"
    local dst="${SYMLINK_MAP[$rel_src]}"
    symlink "$abs_src" "$dst"
  done

  # pacman.conf is system-wide — special handling
  if [[ -f "$DOTFILES_DIR/config/pacman.conf" ]]; then
    info "pacman.conf: copying to /etc/pacman.conf (requires sudo)"
    backup "/etc/pacman.conf"
    run sudo cp "$DOTFILES_DIR/config/pacman.conf" /etc/pacman.conf \
      && ok "pacman.conf installed" \
      || warn "Failed to copy pacman.conf"
  fi

  # tlp.conf → /etc/tlp.conf
  if [[ -f "$DOTFILES_DIR/config/tlp.conf" ]]; then
    info "tlp.conf: copying to /etc/tlp.conf (requires sudo)"
    backup "/etc/tlp.conf"
    run sudo cp "$DOTFILES_DIR/config/tlp.conf" /etc/tlp.conf \
      && ok "tlp.conf installed" \
      || warn "Failed to copy tlp.conf"
  fi
}

# ─── SCRIPTS ────────────────────────────────────────────────
setup_scripts() {
  sep "Making scripts executable"
  find "$DOTFILES_DIR/scripts" -name "*.sh" | while read -r f; do
    run chmod +x "$f" && ok "chmod +x $f"
  done
  # smth scripts too
  find "$DOTFILES_DIR/smth" -name "*.sh" 2>/dev/null | while read -r f; do
    run chmod +x "$f"
  done
}

# ─── THEMES ─────────────────────────────────────────────────
setup_themes() {
  sep "Setting up themes"

  local themes_dst="$HOME_DIR/.local/share/themes"
  local icons_dst="$HOME_DIR/.local/share/icons"
  run mkdir -p "$themes_dst" "$icons_dst"

  # GTK theme
  if [[ -d "$DOTFILES_DIR/themes/gruvbox-dark-gtk" ]]; then
    symlink "$DOTFILES_DIR/themes/gruvbox-dark-gtk" "$themes_dst/gruvbox-dark-gtk"
  fi

  # Cursor theme
  if [[ -d "$DOTFILES_DIR/themes/gruvbox-cursor" ]]; then
    symlink "$DOTFILES_DIR/themes/gruvbox-cursor" "$icons_dst/gruvbox-cursor"
  fi
}

# ─── WALLS ──────────────────────────────────────────────────
setup_walls() {
  sep "Wallpapers"
  # walls stay in the dotfiles dir; configs reference $HOME/wayland/walls
  # Create a ~/wayland symlink pointing to the dotfiles dir if not already there
  local wayland_link="$HOME_DIR/wayland"
  if [[ ! -e "$wayland_link" ]]; then
    run ln -s "$DOTFILES_DIR" "$wayland_link"
    ok "Created ~/wayland → $DOTFILES_DIR"
  elif [[ -L "$wayland_link" && "$(readlink "$wayland_link")" == "$DOTFILES_DIR" ]]; then
    ok "~/wayland already points to $DOTFILES_DIR"
  else
    warn "~/wayland exists but points elsewhere or is a real dir. Not touching it."
    warn "Your scripts expect ~/wayland/walls — please adjust manually."
  fi
}

# ─── SYSTEMD SERVICES ───────────────────────────────────────
setup_services() {
  sep "Systemd services"

  local user_services=(
    "pipewire"
    "pipewire-pulse"
    "wireplumber"
  )
  local system_services=(
    "NetworkManager"
    "bluetooth"
    "tlp"
    "sddm"
  )

  for svc in "${user_services[@]}"; do
    if systemctl --user list-unit-files "$svc.service" &>/dev/null 2>&1; then
      run systemctl --user enable --now "$svc.service" \
        && ok "User service enabled: $svc" \
        || warn "Could not enable user service: $svc"
    else
      warn "User service not found: $svc"
    fi
  done

  for svc in "${system_services[@]}"; do
    if systemctl list-unit-files "$svc.service" &>/dev/null 2>&1; then
      run sudo systemctl enable "$svc.service" \
        && ok "System service enabled: $svc" \
        || warn "Could not enable system service: $svc"
    else
      warn "System service not found: $svc"
    fi
  done
}

# ─── SHELL ──────────────────────────────────────────────────
setup_shell() {
  sep "Shell setup"

  # Add starship init to zshrc if not present
  local zshrc="$HOME_DIR/.zshrc"
  local starship_line='eval "$(starship init zsh)"'

  if [[ ! -f "$zshrc" ]]; then
    run touch "$zshrc"
  fi

  if ! grep -qF "starship init" "$zshrc" 2>/dev/null; then
    if ! $DRY_RUN; then
      echo "" >> "$zshrc"
      echo "# Starship prompt" >> "$zshrc"
      echo "$starship_line" >> "$zshrc"
    fi
    ok "Added starship init to .zshrc"
  else
    ok "starship init already in .zshrc"
  fi

  # Set zsh as default shell
  if [[ "$SHELL" != "$(command -v zsh)" ]] && command -v zsh &>/dev/null; then
    info "Changing default shell to zsh..."
    run chsh -s "$(command -v zsh)" "$USER" \
      && ok "Shell changed to zsh" \
      || warn "Could not change shell (you may need to do it manually)"
  else
    ok "Shell is already zsh (or zsh not installed)"
  fi
}

# ─── ROLLBACK ───────────────────────────────────────────────
rollback() {
  sep "ROLLBACK"
  warn "Rolling back to $BACKUP_DIR ..."

  if [[ ! -d "$BACKUP_DIR" ]]; then
    err "Backup dir not found: $BACKUP_DIR"
    return 1
  fi

  # Restore every backed-up file
  find "$BACKUP_DIR" -type f -o -type l | while read -r backed_up; do
    local rel="${backed_up#$BACKUP_DIR/}"
    local original="$HOME_DIR/$rel"
    mkdir -p "$(dirname "$original")"
    cp -a "$backed_up" "$original"
    log "RESTORE $original"
  done
  ok "Rollback complete"
}

# ─── SUMMARY ────────────────────────────────────────────────
summary() {
  sep "Installation summary"
  ok "Log file:    $LOG_FILE"
  ok "Backup dir:  $BACKUP_DIR"
  echo ""
  echo -e "${BOLD}${GREEN}All done! 🎉${NC}"
  echo ""
  if $DRY_RUN; then
    echo -e "${YELLOW}This was a DRY RUN — nothing was actually changed.${NC}"
    echo "Re-run without --dry-run to apply changes."
  else
    echo "You may need to log out and back in for all changes to take effect."
    echo "If something went wrong, run:"
    echo "  bash $0 --rollback"
  fi
}

# ─── ROLLBACK MODE ──────────────────────────────────────────
if [[ "${1:-}" == "--rollback" ]]; then
  # Find the most recent backup
  BACKUP_DIR=$(find "$HOME_DIR/.dotfiles-backup" -mindepth 1 -maxdepth 1 -type d | sort | tail -1)
  rollback
  exit 0
fi

# ─── TRAP — auto-rollback on fatal error ────────────────────
cleanup() {
  local exit_code=$?
  if [[ $exit_code -ne 0 ]]; then
    err "Script failed with exit code $exit_code"
    err "Attempting automatic rollback..."
    rollback || true
    err "Check $LOG_FILE for details"
  fi
}
trap cleanup EXIT

# ═══════════════════════════════════════════════════════════
#  MAIN
# ═══════════════════════════════════════════════════════════
echo ""
echo -e "${BOLD}${CYAN}╔══════════════════════════════════════╗${NC}"
echo -e "${BOLD}${CYAN}║  wayland dotfiles installer          ║${NC}"
echo -e "${BOLD}${CYAN}╚══════════════════════════════════════╝${NC}"
echo ""

$DRY_RUN && warn "DRY RUN MODE — no changes will be made"

# Initialize log
mkdir -p "$(dirname "$LOG_FILE")"
echo "" >> "$LOG_FILE"
log "========================================"
log "Install started at $(date)"
log "Script dir: $DOTFILES_DIR"
log "User: $USER, Home: $HOME_DIR"
log "Flags: dry-run=$DRY_RUN no-packages=$SKIP_PACKAGES no-symlinks=$SKIP_SYMLINKS"

preflight

$SKIP_PACKAGES  || install_packages
$SKIP_SYMLINKS  || create_symlinks
$SKIP_SYMLINKS  || setup_themes

setup_scripts
setup_walls

$SKIP_SERVICES  || setup_services
setup_shell

summary

log "Install finished at $(date)"
trap - EXIT   # disarm rollback trap on success
exit 0
