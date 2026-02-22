#!/usr/bin/env bash
# =============================================================================
#  wayland dotfiles installer
#  Usage:  ./install.sh [OPTIONS]
#
#  Options:
#    --dry-run        показать что будет, ничего не менять
#    --no-packages    пропустить установку пакетов
#    --no-symlinks    пропустить симлинки
#    --no-services    пропустить сервисы
#    --no-shell       пропустить настройку шелла
#    --only-packages  только пакеты
#    --rollback       откатить последние изменения
#    -h|--help        помощь
# =============================================================================

set -Euo pipefail

# ── ПУТИ ─────────────────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$SCRIPT_DIR"
LOG_FILE="$HOME/.dotfiles-install.log"
BACKUP_BASE="$HOME/.dotfiles-backup"
BACKUP_DIR="$BACKUP_BASE/$(date +%Y%m%d_%H%M%S)"
PACKAGE_LIST="$DOTFILES_DIR/package.list"

# ── ФЛАГИ ────────────────────────────────────────────────────────────────────
DRY_RUN=false
SKIP_PACKAGES=false
SKIP_SYMLINKS=false
SKIP_SERVICES=false
SKIP_SHELL=false
ONLY_PACKAGES=false
DO_ROLLBACK=false
AUR_HELPER=""

# ── ЦВЕТА ────────────────────────────────────────────────────────────────────
if [[ -t 1 ]]; then
  R='\033[0;31m' G='\033[0;32m' Y='\033[1;33m'
  B='\033[0;34m' C='\033[0;36m' BOLD='\033[1m' N='\033[0m'
else
  R='' G='' Y='' B='' C='' BOLD='' N=''
fi

# ── ЛОГИРОВАНИЕ ──────────────────────────────────────────────────────────────
_ts()  { date '+%Y-%m-%d %H:%M:%S'; }
log()  { echo "[$(_ts)] $*" >> "$LOG_FILE"; }
info() { echo -e "${B}→${N} $*";  log "INFO  $*"; }
ok()   { echo -e "${G}✓${N} $*";  log "OK    $*"; }
warn() { echo -e "${Y}⚠${N}  $*"; log "WARN  $*"; }
err()  { echo -e "${R}✗${N} $*" >&2; log "ERROR $*"; }
die()  { err "$*"; exit 1; }
sep()  { echo -e "\n${C}${BOLD}━━━ $* ━━━${N}"; log "=== $* ==="; }

# ── АРГУМЕНТЫ ────────────────────────────────────────────────────────────────
for arg in "$@"; do
  case "$arg" in
    --dry-run)       DRY_RUN=true ;;
    --no-packages)   SKIP_PACKAGES=true ;;
    --no-symlinks)   SKIP_SYMLINKS=true ;;
    --no-services)   SKIP_SERVICES=true ;;
    --no-shell)      SKIP_SHELL=true ;;
    --only-packages) ONLY_PACKAGES=true ;;
    --rollback)      DO_ROLLBACK=true ;;
    -h|--help) grep '^#  ' "${BASH_SOURCE[0]}" | sed 's/^#  //'; exit 0 ;;
    *) warn "Неизвестный аргумент: $arg" ;;
  esac
done

# ── ХЕЛПЕРЫ ──────────────────────────────────────────────────────────────────
run() {
  if $DRY_RUN; then
    echo -e "  ${Y}[DRY]${N} $*"; log "DRY $*"; return 0
  fi
  log "RUN $*"; "$@"
}

backup() {
  local t="$1"
  [[ -e "$t" || -L "$t" ]] || return 0
  local rel
  [[ "$t" == /etc/* ]] && rel="etc/${t#/etc/}" || rel="${t#"$HOME/"}"
  local dst="$BACKUP_DIR/$rel"
  mkdir -p "$(dirname "$dst")"
  cp -a "$t" "$dst"
  log "BACKUP $t → $dst"
}

symlink() {
  local src="$1" dst="$2"
  if [[ ! -e "$src" && ! -d "$src" ]]; then
    warn "Не найдено: $src — пропускаю"
    return 0
  fi
  if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
    ok "Уже: $dst"; return 0
  fi
  if ! $DRY_RUN; then
    backup "$dst"
    rm -rf "$dst"
    mkdir -p "$(dirname "$dst")"
    ln -sf "$src" "$dst"
  else
    echo -e "  ${Y}[DRY]${N} ln -sf $src → $dst"
  fi
  ok "Слинкован: $dst"
}

# ── ОТКАТ ────────────────────────────────────────────────────────────────────
do_rollback() {
  sep "ОТКАТ"
  local last
  last=$(find "$BACKUP_BASE" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | sort | tail -1)
  [[ -z "$last" ]] && die "Нет бэкапов в $BACKUP_BASE"
  warn "Восстанавливаю из: $last"
  while IFS= read -r f; do
    local rel="${f#"$last/"}"
    local orig
    [[ "$rel" == etc/* ]] && orig="/$rel" || orig="$HOME/$rel"
    mkdir -p "$(dirname "$orig")"
    cp -a "$f" "$orig"
    ok "Восстановлено: $orig"
  done < <(find "$last" \( -type f -o -type l \))
  ok "Откат завершён"
}

# ── PREFLIGHT ─────────────────────────────────────────────────────────────────
preflight() {
  sep "Проверки"
  command -v pacman &>/dev/null || die "pacman не найден — только Arch-based!"
  ok "pacman найден"
  [[ $EUID -ne 0 ]] || die "Не запускай от root!"
  ok "Пользователь: $USER"
  [[ -d "$DOTFILES_DIR/config" ]] || die "config/ не найден в $DOTFILES_DIR"
  ok "Dotfiles: $DOTFILES_DIR"
  [[ -f "$PACKAGE_LIST" ]] && ok "package.list найден" || warn "package.list не найден"

  $DRY_RUN || mkdir -p "$BACKUP_DIR"
  ok "Бэкап: $BACKUP_DIR"

  # AUR helper
  if   command -v yay  &>/dev/null; then AUR_HELPER="yay"
  elif command -v paru &>/dev/null; then AUR_HELPER="paru"
  fi
  [[ -n "$AUR_HELPER" ]] && ok "AUR helper: $AUR_HELPER" \
    || warn "AUR helper не найден — попробую установить yay"
}

# ── УСТАНОВКА YAY ────────────────────────────────────────────────────────────
install_yay() {
  [[ -n "$AUR_HELPER" ]] && return 0
  sep "Установка yay"
  if $DRY_RUN; then
    echo -e "  ${Y}[DRY]${N} git clone yay && makepkg -si"; return 0
  fi
  sudo pacman -S --needed --noconfirm git base-devel 2>/dev/null || true
  local tmp; tmp=$(mktemp -d)
  git clone --depth=1 https://aur.archlinux.org/yay.git "$tmp/yay" \
    && pushd "$tmp/yay" >/dev/null \
    && MAKEFLAGS="-j$(nproc)" makepkg -si --noconfirm \
    && popd >/dev/null \
    && AUR_HELPER="yay" \
    && ok "yay установлен" \
    || warn "Не удалось установить yay — AUR пакеты пропущу"
  rm -rf "$tmp"
}

# ── УСТАНОВКА ПАКЕТОВ ────────────────────────────────────────────────────────
install_packages() {
  sep "Установка пакетов"
  [[ -f "$PACKAGE_LIST" ]] || { warn "package.list не найден"; return 0; }

  # Читаем список — первое слово, пропускаем # и пустые строки
  local all_pkgs=()
  while IFS= read -r line; do
    line="${line#"${line%%[![:space:]]*}"}"   # ltrim
    line="${line%"${line##*[![:space:]]}"}"   # rtrim
    [[ -z "$line" || "$line" == \#* ]] && continue
    all_pkgs+=("${line%% *}")
  done < "$PACKAGE_LIST"

  local total="${#all_pkgs[@]}"
  info "Пакетов в списке: $total"
  [[ $total -eq 0 ]] && { warn "Список пустой"; return 0; }

  # Обновить БД pacman
  info "Синхронизация баз данных..."
  if ! $DRY_RUN; then
    # NOCONFIRM через переменную окружения — надёжнее чем флаг
    DEBIAN_FRONTEND=noninteractive sudo pacman -Sy --noconfirm 2>&1 \
      | tail -3; true
  fi

  # Получить все пакеты из репо одним вызовом
  local repo_list=""
  local installed_list=""
  if ! $DRY_RUN; then
    repo_list=$(pacman -Ssq 2>/dev/null | sort -u)
    installed_list=$(pacman -Qq 2>/dev/null | sort -u)
  fi

  local official=()
  local aur=()
  local already=0

  for pkg in "${all_pkgs[@]}"; do
    if [[ -n "$installed_list" ]] && echo "$installed_list" | grep -qx "$pkg" 2>/dev/null; then
      already=$((already + 1))
      continue
    fi
    if $DRY_RUN || echo "$repo_list" | grep -qx "$pkg" 2>/dev/null; then
      official+=("$pkg")
    else
      aur+=("$pkg")
    fi
  done

  ok "Уже установлено: $already"
  info "Нужно (official): ${#official[@]}"
  info "Нужно (AUR):      ${#aur[@]}"

  # ── Официальные — чанками по 50 ──────────────────────────────────────────
  if [[ ${#official[@]} -gt 0 ]]; then
    info "Устанавливаю официальные пакеты..."
    if ! $DRY_RUN; then
      local i=0 chunk_size=50 n="${#official[@]}"
      while [[ $i -lt $n ]]; do
        local chunk=("${official[@]:$i:$chunk_size}")
        local end=$(( i + ${#chunk[@]} ))
        info "  Чанк [$((i+1))–$end / $n]..."
        # --noconfirm + PACMAN_NOCONFIRM чтобы точно не зависало
        sudo pacman -S --needed --noconfirm --noprogressbar "${chunk[@]}" \
          2>&1 | tee -a "$LOG_FILE" \
          | grep -E "^(error:|warning:|:: installing|installing |upgrading )" \
          || true
        i=$(( i + chunk_size ))
      done
      ok "Официальные пакеты установлены"
    else
      echo -e "  ${Y}[DRY]${N} pacman -S --needed --noconfirm [${#official[@]} пакетов]"
    fi
  else
    ok "Все официальные пакеты уже есть"
  fi

  # ── AUR пакеты ───────────────────────────────────────────────────────────
  if [[ ${#aur[@]} -gt 0 ]]; then
    if [[ -n "$AUR_HELPER" ]]; then
      info "Устанавливаю AUR пакеты через $AUR_HELPER..."
      local failed=()
      for pkg in "${aur[@]}"; do
        if ! $DRY_RUN; then
          info "  AUR: $pkg"
          "$AUR_HELPER" -S --needed --noconfirm "$pkg" \
            2>&1 | tee -a "$LOG_FILE" | tail -2 || true
          pacman -Qi "$pkg" &>/dev/null || failed+=("$pkg")
        else
          echo -e "  ${Y}[DRY]${N} $AUR_HELPER -S $pkg"
        fi
      done
      [[ ${#failed[@]} -gt 0 ]] \
        && warn "Не установлено: ${failed[*]}" \
        || ok "Все AUR пакеты установлены"
    else
      warn "Нет AUR helper — пропускаю ${#aur[@]} пакетов:"
      printf '  - %s\n' "${aur[@]}"
      warn "После установки yay выполни: yay -S --needed ${aur[*]}"
    fi
  fi

  sep "Итог"
  ok "Уже было:   $already"
  ok "Official:   ${#official[@]}"
  ok "AUR:        ${#aur[@]}"
}

# ── СИМЛИНКИ ─────────────────────────────────────────────────────────────────
create_symlinks() {
  sep "Симлинки"

  # "относительный_путь|абсолютный_путь_назначения"
  local -a links=(
    "config/hypr|$HOME/.config/hypr"
    "config/sway|$HOME/.config/sway"
    "config/waybar|$HOME/.config/waybar"
    "config/kitty|$HOME/.config/kitty"
    "config/nvim|$HOME/.config/nvim"
    "config/helix|$HOME/.config/helix"
    "config/wofi|$HOME/.config/wofi"
    "config/tofi|$HOME/.config/tofi"
    "config/swaync|$HOME/.config/swaync"
    "config/swaylock|$HOME/.config/swaylock"
    "config/btop|$HOME/.config/btop"
    "config/cava|$HOME/.config/cava"
    "config/macchina|$HOME/.config/macchina"
    "config/gtk-3.0|$HOME/.config/gtk-3.0"
    "config/gtk-4.0|$HOME/.config/gtk-4.0"
    "config/starship.toml|$HOME/.config/starship.toml"
    "config/mimeapps.list|$HOME/.config/mimeapps.list"
    "config/.tmux.conf|$HOME/.tmux.conf"
  )

  for entry in "${links[@]}"; do
    symlink "$DOTFILES_DIR/${entry%%|*}" "${entry##*|}"
  done

  # pacman.conf → /etc/pacman.conf
  if [[ -f "$DOTFILES_DIR/config/pacman.conf" ]]; then
    info "pacman.conf → /etc/pacman.conf"
    if ! $DRY_RUN; then
      backup "/etc/pacman.conf"
      sudo cp "$DOTFILES_DIR/config/pacman.conf" /etc/pacman.conf \
        && ok "pacman.conf установлен" || warn "Не удалось скопировать pacman.conf"
    else
      echo -e "  ${Y}[DRY]${N} sudo cp pacman.conf /etc/pacman.conf"
    fi
  fi

  # tlp.conf → /etc/tlp.conf
  if [[ -f "$DOTFILES_DIR/config/tlp.conf" ]]; then
    info "tlp.conf → /etc/tlp.conf"
    if ! $DRY_RUN; then
      backup "/etc/tlp.conf"
      sudo cp "$DOTFILES_DIR/config/tlp.conf" /etc/tlp.conf \
        && ok "tlp.conf установлен" || warn "Не удалось скопировать tlp.conf"
    else
      echo -e "  ${Y}[DRY]${N} sudo cp tlp.conf /etc/tlp.conf"
    fi
  fi
}

# ── ТЕМЫ ─────────────────────────────────────────────────────────────────────
setup_themes() {
  sep "Темы"
  local td="$HOME/.local/share/themes" id="$HOME/.local/share/icons"
  run mkdir -p "$td" "$id"
  [[ -d "$DOTFILES_DIR/themes/gruvbox-dark-gtk" ]] \
    && symlink "$DOTFILES_DIR/themes/gruvbox-dark-gtk" "$td/gruvbox-dark-gtk"
  [[ -d "$DOTFILES_DIR/themes/gruvbox-cursor" ]] \
    && symlink "$DOTFILES_DIR/themes/gruvbox-cursor" "$id/gruvbox-cursor"
}

# ── СКРИПТЫ ──────────────────────────────────────────────────────────────────
setup_scripts() {
  sep "Права на скрипты"
  for dir in "$DOTFILES_DIR/scripts" "$DOTFILES_DIR/smth" "$DOTFILES_DIR/old"; do
    [[ -d "$dir" ]] || continue
    while IFS= read -r f; do
      run chmod +x "$f" && ok "chmod +x $(basename "$f")"
    done < <(find "$dir" -name "*.sh" -type f)
  done
}

# ── ~/wayland ────────────────────────────────────────────────────────────────
setup_wayland_link() {
  sep "~/wayland"
  local link="$HOME/wayland"
  if [[ "$DOTFILES_DIR" == "$link" ]]; then
    ok "Уже в ~/wayland — симлинк не нужен"; return 0
  fi
  if [[ -L "$link" && "$(readlink "$link")" == "$DOTFILES_DIR" ]]; then
    ok "~/wayland → $DOTFILES_DIR (уже)"; return 0
  fi
  if [[ -e "$link" && ! -L "$link" ]]; then
    warn "~/wayland — реальная директория, не трогаю"; return 0
  fi
  run ln -sf "$DOTFILES_DIR" "$link" && ok "~/wayland → $DOTFILES_DIR"
}

# ── СЕРВИСЫ ──────────────────────────────────────────────────────────────────
setup_services() {
  sep "Systemd сервисы"

  # Пользовательские — нужно быть в графической сессии чтобы полностью заработало
  # Поэтому просто enable без --now (--now может завалиться в chroot/ssh)
  local user_svcs=("pipewire" "pipewire-pulse" "wireplumber")
  local sys_svcs=("NetworkManager" "bluetooth" "tlp" "sddm")

  info "Пользовательские сервисы..."
  for svc in "${user_svcs[@]}"; do
    # Ищем unit файл напрямую — надёжнее чем systemctl в ssh сессии
    if find /usr/lib/systemd/user/ /etc/systemd/user/ \
         -name "${svc}.service" 2>/dev/null | grep -q .; then
      if ! $DRY_RUN; then
        systemctl --user enable "$svc.service" 2>/dev/null \
          && ok "  [user] enabled: $svc" \
          || warn "  Не удалось enable: $svc (нормально в SSH — будет работать после логина)"
      else
        echo -e "  ${Y}[DRY]${N} systemctl --user enable $svc"
      fi
    else
      warn "  unit не найден: $svc — пакет установлен?"
    fi
  done

  info "Системные сервисы..."
  for svc in "${sys_svcs[@]}"; do
    # Ищем unit файл
    if find /usr/lib/systemd/system/ /etc/systemd/system/ \
         -name "${svc}.service" 2>/dev/null | grep -q .; then
      if ! $DRY_RUN; then
        sudo systemctl enable "$svc.service" 2>/dev/null \
          && ok "  [system] enabled: $svc" \
          || warn "  Не удалось enable: $svc"
      else
        echo -e "  ${Y}[DRY]${N} sudo systemctl enable $svc"
      fi
    else
      warn "  unit не найден: $svc — пакет установлен?"
    fi
  done

  # Обязательно включить lingering чтобы user-сервисы стартовали при загрузке
  if ! $DRY_RUN; then
    sudo loginctl enable-linger "$USER" 2>/dev/null \
      && ok "loginctl linger включён для $USER" || true
  fi
}

# ── ШЕЛЛ ─────────────────────────────────────────────────────────────────────
setup_shell() {
  sep "Шелл"
  local zshrc="$HOME/.zshrc"
  [[ -f "$zshrc" ]] || run touch "$zshrc"

  if command -v starship &>/dev/null; then
    if ! grep -qF "starship init" "$zshrc" 2>/dev/null; then
      $DRY_RUN || printf '\n# Starship prompt\neval "$(starship init zsh)"\n' >> "$zshrc"
      ok "starship добавлен в .zshrc"
    else
      ok "starship уже в .zshrc"
    fi
  else
    warn "starship не установлен"
  fi

  if command -v zsh &>/dev/null; then
    local zsh_bin; zsh_bin="$(command -v zsh)"
    if [[ "$SHELL" != "$zsh_bin" ]]; then
      run chsh -s "$zsh_bin" "$USER" \
        && ok "Шелл → zsh" \
        || warn "Не удалось: chsh -s $zsh_bin $USER"
    else
      ok "Шелл уже zsh"
    fi
  fi
}

# ── ИТОГ ─────────────────────────────────────────────────────────────────────
print_summary() {
  sep "ГОТОВО"
  echo ""
  echo -e "${G}${BOLD}╔══════════════════════════════════════╗${N}"
  echo -e "${G}${BOLD}║   Установка завершена! 🎉            ║${N}"
  echo -e "${G}${BOLD}╚══════════════════════════════════════╝${N}"
  echo ""
  ok "Лог:   $LOG_FILE"
  ok "Бэкап: $BACKUP_DIR"
  echo ""
  if $DRY_RUN; then
    echo -e "${Y}DRY RUN — ничего не изменено. Убери --dry-run чтобы применить.${N}"
    return
  fi
  echo -e "  ${B}Дальнейшие шаги:${N}"
  echo "  1. Перезагрузись: sudo reboot"
  echo "  2. На экране SDDM выбери Hyprland или Sway"
  echo "  3. Если что-то сломалось: bash $0 --rollback"
  echo ""
}

# ── TRAP ─────────────────────────────────────────────────────────────────────
_on_error() {
  local code=$?; [[ $code -eq 0 ]] && return
  err "Упал с кодом $code — лог: $LOG_FILE"
  [[ -d "$BACKUP_DIR" ]] && { err "Автооткат..."; do_rollback || true; }
}
trap '_on_error' ERR

# ═════════════════════════════════════════════════════════════════════════════
#  MAIN
# ═════════════════════════════════════════════════════════════════════════════
mkdir -p "$(dirname "$LOG_FILE")"
{ echo ""; echo "=== Старт: $(date) | $USER | $DOTFILES_DIR ==="; } >> "$LOG_FILE"

$DO_ROLLBACK && { do_rollback; exit 0; }

echo ""
echo -e "${C}${BOLD}╔══════════════════════════════════════╗${N}"
echo -e "${C}${BOLD}║     wayland dotfiles installer       ║${N}"
echo -e "${C}${BOLD}╚══════════════════════════════════════╝${N}"
echo ""
$DRY_RUN && warn "DRY RUN — изменений не будет"

preflight

if $ONLY_PACKAGES; then
  install_yay; install_packages
  print_summary; trap - ERR; exit 0
fi

$SKIP_PACKAGES || { install_yay; install_packages; }
$SKIP_SYMLINKS || { create_symlinks; setup_themes; }
setup_scripts
setup_wayland_link
$SKIP_SERVICES || setup_services
$SKIP_SHELL    || setup_shell

print_summary
log "=== Финиш: $(date) ==="
trap - ERR
exit 0
