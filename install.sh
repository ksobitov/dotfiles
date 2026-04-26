#!/usr/bin/env bash
# =============================================================================
# Dotfiles Install Script
# Muallif: Komil | https://github.com/getnf/getnf (font uchun)
#
# Yangi muhitda barcha sozlamalarni bitta buyruq bilan o'rnatadi:
#   bash install.sh
# =============================================================================

set -euo pipefail

# --- Ranglar ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

info()    { echo -e "${BLUE}[INFO]${NC}  $*"; }
success() { echo -e "${GREEN}[OK]${NC}    $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC}  $*"; }
error()   { echo -e "${RED}[ERROR]${NC} $*" >&2; }
step()    { echo -e "\n${BOLD}==> $*${NC}"; }

# =============================================================================
# 1. PACKAGE MANAGER ANIQLASH
# =============================================================================
detect_pkg_manager() {
  if command -v apt &>/dev/null; then
    PKG_MANAGER="apt"
    PKG_INSTALL="sudo apt install -y"
    PKG_UPDATE="sudo apt update"
  elif command -v pacman &>/dev/null; then
    PKG_MANAGER="pacman"
    PKG_INSTALL="sudo pacman -S --noconfirm"
    PKG_UPDATE="sudo pacman -Sy"
  elif command -v dnf &>/dev/null; then
    PKG_MANAGER="dnf"
    PKG_INSTALL="sudo dnf install -y"
    PKG_UPDATE="sudo dnf check-update || true"
  else
    error "Qo'llab-quvvatlanadigan paket menejeri topilmadi (apt/pacman/dnf)."
    exit 1
  fi
  info "Paket menejeri: $PKG_MANAGER"
}

# =============================================================================
# 2. PAKETLARNI O'RNATISH
# =============================================================================
install_packages() {
  step "Tizim paketlarini o'rnatish"
  $PKG_UPDATE

  local packages=(
    zsh
    tmux
    kitty
    xclip
    xbanish
    fzf
    curl
    git
    wget
    unzip
  )

  for pkg in "${packages[@]}"; do
    if ! command -v "$pkg" &>/dev/null && ! dpkg -s "$pkg" &>/dev/null 2>&1; then
      info "O'rnatilmoqda: $pkg"
      $PKG_INSTALL "$pkg" || warn "$pkg o'rnatilmadi, davom etilmoqda..."
    else
      success "$pkg allaqachon o'rnatilgan"
    fi
  done
}

# =============================================================================
# 3. OH MY ZSH O'RNATISH
# =============================================================================
install_oh_my_zsh() {
  step "Oh My Zsh o'rnatish"
  if [ -d "$HOME/.oh-my-zsh" ]; then
    success "Oh My Zsh allaqachon o'rnatilgan"
    return
  fi
  info "Oh My Zsh yuklanmoqda..."
  RUNZSH=no CHSH=no sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  success "Oh My Zsh o'rnatildi"
}

# =============================================================================
# 4. ZSH PLUGINLARINI O'RNATISH
# =============================================================================
install_zsh_plugins() {
  step "Zsh pluginlarini o'rnatish"
  local ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

  # zsh-vi-mode
  local zvm_dir="$ZSH_CUSTOM/plugins/zsh-vi-mode"
  if [ ! -d "$zvm_dir" ]; then
    info "zsh-vi-mode yuklanmoqda..."
    git clone https://github.com/jeffreytse/zsh-vi-mode.git "$zvm_dir"
    success "zsh-vi-mode o'rnatildi"
  else
    success "zsh-vi-mode allaqachon bor"
  fi

  # zsh-syntax-highlighting
  local zsh_dir="$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
  if [ ! -d "$zsh_dir" ]; then
    info "zsh-syntax-highlighting yuklanmoqda..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$zsh_dir"
    success "zsh-syntax-highlighting o'rnatildi"
  else
    success "zsh-syntax-highlighting allaqachon bor"
  fi

  # fzf-zsh-plugin
  local fzf_dir="$ZSH_CUSTOM/plugins/fzf-zsh-plugin"
  if [ ! -d "$fzf_dir" ]; then
    info "fzf-zsh-plugin yuklanmoqda..."
    git clone https://github.com/unixorn/fzf-zsh-plugin.git "$fzf_dir"
    success "fzf-zsh-plugin o'rnatildi"
  else
    success "fzf-zsh-plugin allaqachon bor"
  fi

  # zsh-autopair
  local autopair_dir="$ZSH_CUSTOM/plugins/zsh-autopair"
  if [ ! -d "$autopair_dir" ]; then
    info "zsh-autopair yuklanmoqda..."
    git clone https://github.com/hlissner/zsh-autopair.git "$autopair_dir"
    success "zsh-autopair o'rnatildi"
  else
    success "zsh-autopair allaqachon bor"
  fi
}

# =============================================================================
# 5. FZF O'RNATISH (shell integration)
# =============================================================================
install_fzf() {
  step "fzf shell integratsiyasini sozlash"
  if [ ! -f "$HOME/.fzf.zsh" ]; then
    if [ -d "$HOME/.fzf" ]; then
      "$HOME/.fzf/install" --all --no-bash --no-fish
    elif command -v fzf &>/dev/null; then
      info "fzf tizimga o'rnatilgan, ~/.fzf.zsh fayli yo'q — fzf key-bindings qo'lda yuklanmoqda"
      # Paket menejeri orqali o'rnatilgan fzf uchun
      local fzf_share=""
      for p in /usr/share/doc/fzf/examples /usr/share/fzf; do
        [ -f "$p/key-bindings.zsh" ] && fzf_share="$p" && break
      done
      if [ -n "$fzf_share" ]; then
        cat > "$HOME/.fzf.zsh" <<EOF
# fzf key bindings and completion (system install)
source $fzf_share/key-bindings.zsh 2>/dev/null || true
source $fzf_share/completion.zsh   2>/dev/null || true
EOF
        success "~/.fzf.zsh yaratildi"
      else
        warn "fzf share fayllari topilmadi, ~/.fzf.zsh qo'lda sozlanishi kerak bo'lishi mumkin"
      fi
    fi
  else
    success "~/.fzf.zsh allaqachon mavjud"
  fi
}

# =============================================================================
# 6. TPM (TMUX PLUGIN MANAGER) O'RNATISH
# =============================================================================
install_tpm() {
  step "TPM (Tmux Plugin Manager) o'rnatish"
  local tpm_dir="$HOME/.tmux/plugins/tpm"
  if [ ! -d "$tpm_dir" ]; then
    info "TPM yuklanmoqda..."
    git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
    success "TPM o'rnatildi"
  else
    success "TPM allaqachon o'rnatilgan"
  fi
}

# =============================================================================
# 7. GETNF ORQALI JETBRAINSMONO NERD FONT O'RNATISH
# =============================================================================
install_fonts() {
  step "JetBrainsMono Nerd Font o'rnatish (getnf orqali)"

  local getnf_bin="$HOME/.local/bin/getnf"

  # getnf o'rnatish
  if ! command -v getnf &>/dev/null && [ ! -f "$getnf_bin" ]; then
    info "getnf yuklanmoqda..."
    curl -fsSL https://raw.githubusercontent.com/getnf/getnf/main/install.sh | bash
    export PATH="$HOME/.local/bin:$PATH"
    success "getnf o'rnatildi"
  else
    success "getnf allaqachon o'rnatilgan"
  fi

  # Font o'rnatish
  if ! fc-list | grep -qi "JetBrainsMono"; then
    info "JetBrainsMono Nerd Font yuklanmoqda..."
    getnf -i JetBrainsMono
    fc-cache -fv &>/dev/null
    success "JetBrainsMono Nerd Font o'rnatildi"
  else
    success "JetBrainsMono Nerd Font allaqachon o'rnatilgan"
  fi
}

# =============================================================================
# 8. VIM O'RNATISH TEKSHIRUVI
# =============================================================================
install_vim() {
  step "Vim mavjudligini tekshirish"
  if ! command -v vim &>/dev/null; then
    info "Vim o'rnatilmoqda..."
    $PKG_INSTALL vim || warn "Vim o'rnatilmadi"
  else
    success "Vim allaqachon o'rnatilgan"
  fi
}

# =============================================================================
# 9. SYMLINK YARATISH (backup bilan)
# =============================================================================
make_symlink() {
  local src="$1"
  local dest="$2"

  # Maqsad papkani yaratish
  mkdir -p "$(dirname "$dest")"

  # Agar real fayl/papka bo'lsa — zaxira nusxa
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    local backup="${dest}.bak.$(date +%Y%m%d_%H%M%S)"
    warn "Mavjud fayl zaxiralandi: $backup"
    mv "$dest" "$backup"
  fi

  # Eski symlink bo'lsa o'chirish
  [ -L "$dest" ] && rm "$dest"

  ln -sf "$src" "$dest"
  success "Symlink: $dest -> $src"
}

link_dotfiles() {
  step "Symlink'lar yaratish"

  make_symlink "$DOTFILES_DIR/zsh/.zshrc"          "$HOME/.zshrc"
  make_symlink "$DOTFILES_DIR/tmux/.tmux.conf"     "$HOME/.tmux.conf"
  make_symlink "$DOTFILES_DIR/kitty/kitty.conf"    "$HOME/.config/kitty/kitty.conf"
  make_symlink "$DOTFILES_DIR/tmux/scripts/_tmux_duplicate_pane" \
               "$HOME/.local/bin/_tmux_duplicate_pane"
  chmod +x "$HOME/.local/bin/_tmux_duplicate_pane"
  make_symlink "$DOTFILES_DIR/vim/.vimrc"           "$HOME/.vimrc"
  make_symlink "$DOTFILES_DIR/systemd/xbanish.service" \
               "$HOME/.config/systemd/user/xbanish.service"

  # .xprofile endi kerak emas (xbanish systemd service orqali boshqariladi)
  if [ -L "$HOME/.xprofile" ]; then
    rm "$HOME/.xprofile"
    success "Eski ~/.xprofile symlinki o'chirildi"
  elif [ -f "$HOME/.xprofile" ]; then
    warn "~/.xprofile fayli mavjud — agar kerak bo'lmasa qo'lda o'chiring"
  fi
}

# =============================================================================
# 9. XBANISH SYSTEMD USER SERVICE O'RNATISH
# =============================================================================
install_xbanish_service() {
  step "xbanish systemd user service o'rnatish"

  # Eski system-level service bo'lsa o'chirish
  if systemctl is-active --quiet xbanish.service 2>/dev/null; then
    info "Eski system xbanish service o'chirilmoqda..."
    sudo systemctl stop xbanish.service || true
    sudo systemctl disable xbanish.service || true
  fi
  if [ -f /etc/systemd/system/xbanish.service ]; then
    sudo rm /etc/systemd/system/xbanish.service
    sudo systemctl daemon-reload || true
  fi

  # Symlink link_dotfiles da yaratilgan, shu yerda enable + start
  systemctl --user daemon-reload
  systemctl --user enable xbanish.service
  systemctl --user start xbanish.service \
    || warn "xbanish service hozir ishga tushmadi (grafik sessiya kerak bo'lishi mumkin). Login qilib qaytgach avtomatik ishga tushadi."
  success "xbanish user service yoqildi"
}

# =============================================================================
# 10. ZSH DEFAULT SHELL QILISH
# =============================================================================
set_default_shell() {
  step "Zsh ni default shell qilish"
  local zsh_path
  zsh_path="$(command -v zsh)"
  if [ "$SHELL" != "$zsh_path" ]; then
    if ! grep -q "$zsh_path" /etc/shells; then
      echo "$zsh_path" | sudo tee -a /etc/shells
    fi
    chsh -s "$zsh_path"
    success "Default shell zsh ga o'zgartirildi: $zsh_path"
  else
    success "Default shell allaqachon zsh"
  fi
}

# =============================================================================
# 11. TMUX PLUGINLARINI O'RNATISH
# =============================================================================
install_tmux_plugins() {
  step "Tmux pluginlarini o'rnatish (TPM orqali)"
  if command -v tmux &>/dev/null && [ -f "$HOME/.tmux/plugins/tpm/bin/install_plugins" ]; then
    info "tmux-resurrect va boshqa pluginlar o'rnatilmoqda..."
    # TMUX sessiyasiz ishlash uchun
    TMUX_PLUGIN_MANAGER_PATH="$HOME/.tmux/plugins" \
      "$HOME/.tmux/plugins/tpm/bin/install_plugins" || true
    success "Tmux pluginlari o'rnatildi"
  else
    warn "TPM topilmadi yoki tmux mavjud emas. tmux ichida 'prefix + I' bosing"
  fi
}

# =============================================================================
# ASOSIY
# =============================================================================
main() {
  echo -e "${BOLD}"
  echo "╔══════════════════════════════════════╗"
  echo "║        Dotfiles Installer            ║"
  echo "╚══════════════════════════════════════╝"
  echo -e "${NC}"

  detect_pkg_manager
  install_packages
  install_vim
  install_oh_my_zsh
  install_zsh_plugins
  install_fzf
  install_tpm
  install_fonts
  link_dotfiles
  install_xbanish_service
  install_tmux_plugins
  set_default_shell

  echo -e "\n${GREEN}${BOLD}"
  echo "╔══════════════════════════════════════╗"
  echo "║   O'rnatish muvaffaqiyatli tugadi!   ║"
  echo "╚══════════════════════════════════════╝"
  echo -e "${NC}"
  echo "Keyingi qadamlar:"
  echo "  1. Yangi terminal oching yoki: exec zsh"
  echo "  2. Tmux ichida pluginlarni yuklash: prefix + I (katta I)"
  echo "  3. Kitty shrift to'g'ri ko'rinishini tekshiring"
}

main "$@"
