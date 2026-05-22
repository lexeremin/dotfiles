#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LEAVES_DIR="$SCRIPT_DIR/leaves"

# ── Font install ─────────────────────────────────────────────────────────────

install_font_macos() {
  if brew list --cask font-jetbrains-mono-nerd-font &>/dev/null; then
    echo "JetBrainsMono Nerd Font already installed, skipping."
    return
  fi
  echo "Installing JetBrainsMono Nerd Font via Homebrew..."
  brew install --cask font-jetbrains-mono-nerd-font
}

ensure_bootstrap_tools() {
  # wget + unzip are needed by install_font_linux before the main package list runs.
  local missing=()
  command -v wget  &>/dev/null || missing+=("wget")
  command -v unzip &>/dev/null || missing+=("unzip")
  [[ ${#missing[@]} -eq 0 ]] && return

  echo "Installing bootstrap tools: ${missing[*]}"
  if command -v pacman &>/dev/null; then
    sudo pacman -S --needed --noconfirm "${missing[@]}"
  elif command -v dnf &>/dev/null; then
    sudo dnf install -y "${missing[@]}"
  elif command -v rpm-ostree &>/dev/null; then
    rpm-ostree install --apply-live --allow-inactive "${missing[@]}" || \
      rpm-ostree install "${missing[@]}"
  elif command -v apt &>/dev/null; then
    sudo apt update && sudo apt install -y "${missing[@]}"
  else
    echo "No supported package manager found to install: ${missing[*]}"
    exit 1
  fi
}

install_font_linux() {
  if fc-list | grep -qi "JetBrainsMono Nerd Font"; then
    echo "JetBrainsMono Nerd Font already installed, skipping."
    return
  fi
  ensure_bootstrap_tools
  echo "Installing JetBrainsMono Nerd Font..."
  local tmp
  tmp=$(mktemp -d)
  wget -qO "$tmp/JetBrainsMono.zip" \
    "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"

  # On Atomic, /usr/share/fonts is read-only and wiped on OS updates.
  # Install to ~/.local/share/fonts instead — no root needed, survives updates.
  if [[ "${1:-}" == "atomic" ]]; then
    local font_dir="$HOME/.local/share/fonts/JetBrainsNerdFont"
    mkdir -p "$font_dir"
    unzip -q "$tmp/JetBrainsMono.zip" -d "$font_dir"
    fc-cache -fv
  else
    sudo mkdir -p /usr/share/fonts/JetBrainsNerdFont
    sudo unzip -q "$tmp/JetBrainsMono.zip" -d /usr/share/fonts/JetBrainsNerdFont
    sudo fc-cache -fv
  fi

  rm -rf "$tmp"
}

# ── Arch helpers ─────────────────────────────────────────────────────────────

install_paru() {
  if command -v paru &>/dev/null; then
    echo "paru already installed, skipping."
    return
  fi
  echo "Installing paru (AUR helper)..."
  sudo pacman -S --needed base-devel git
  local tmp
  tmp=$(mktemp -d)
  git clone https://aur.archlinux.org/paru.git "$tmp/paru"
  (cd "$tmp/paru" && makepkg -si --noconfirm)
  rm -rf "$tmp"
}

# ── Manual install helpers (Fedora / Ubuntu) ─────────────────────────────────

install_stow_fedora() {
  if command -v stow &>/dev/null; then
    echo "stow already installed, skipping."
    return
  fi
  echo "Installing stow from source..."
  local version="2.4.1"
  local tmp
  tmp=$(mktemp -d)
  curl -sL "https://ftp.gnu.org/gnu/stow/stow-${version}.tar.gz" | tar -xz -C "$tmp"
  (cd "$tmp/stow-${version}" && ./configure && make && sudo make install)
  rm -rf "$tmp"
}

install_starship() {
  if command -v starship &>/dev/null; then
    echo "starship already installed, skipping."
    return
  fi
  echo "Installing starship..."
  curl -sS https://starship.rs/install.sh | sh -s -- --yes
}

install_lazygit() {
  if command -v lazygit &>/dev/null; then
    echo "lazygit already installed, skipping."
    return
  fi
  echo "Installing lazygit..."
  local version
  version=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest \
    | grep '"tag_name"' | cut -d'"' -f4 | sed 's/v//')
  local tmp
  tmp=$(mktemp -d)
  curl -sL "https://github.com/jesseduffield/lazygit/releases/download/v${version}/lazygit_${version}_Linux_x86_64.tar.gz" \
    | tar -xz -C "$tmp"
  sudo install "$tmp/lazygit" /usr/local/bin/lazygit
  rm -rf "$tmp"
}

install_eza_ubuntu() {
  if command -v eza &>/dev/null; then
    echo "eza already installed, skipping."
    return
  fi
  echo "Installing eza via deb.gierens.de..."
  sudo apt install -y gpg
  sudo mkdir -p /etc/apt/keyrings
  wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc \
    | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
  echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" \
    | sudo tee /etc/apt/sources.list.d/gierens.list
  sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
  sudo apt update && sudo apt install -y eza
}

install_eza_fedora() {
  if command -v eza &>/dev/null; then
    echo "eza already installed, skipping."
    return
  fi
  echo "Installing eza (not in Fedora 42+ repos, using GitHub release)..."
  local version
  version=$(curl -s https://api.github.com/repos/eza-community/eza/releases/latest \
    | grep '"tag_name"' | cut -d'"' -f4)
  local tmp
  tmp=$(mktemp -d)
  curl -sL "https://github.com/eza-community/eza/releases/download/${version}/eza_x86_64-unknown-linux-gnu.tar.gz" \
    | tar -xz -C "$tmp"
  sudo install "$tmp/eza" /usr/local/bin/eza
  rm -rf "$tmp"
}

install_yazi() {
  if command -v yazi &>/dev/null; then
    echo "yazi already installed, skipping."
    return
  fi
  echo "Installing yazi..."
  local version
  version=$(curl -s https://api.github.com/repos/sxyazi/yazi/releases/latest \
    | grep '"tag_name"' | cut -d'"' -f4)
  local tmp
  tmp=$(mktemp -d)
  curl -sL "https://github.com/sxyazi/yazi/releases/download/${version}/yazi-x86_64-unknown-linux-gnu.zip" \
    -o "$tmp/yazi.zip"
  unzip -q "$tmp/yazi.zip" -d "$tmp"
  sudo install "$tmp/yazi-x86_64-unknown-linux-gnu/yazi" /usr/local/bin/yazi
  rm -rf "$tmp"
}

# ── OS detection ──────────────────────────────────────────────────────────────

detect_os() {
  if [[ "$(uname)" == "Darwin" ]]; then
    echo "macos"
  elif [[ -f /etc/os-release ]]; then
    local id
    id=$(grep "^ID=" /etc/os-release | cut -d= -f2 | tr -d '"')
    case "$id" in
      arch)   echo "arch" ;;
      fedora)
        if [[ -f /run/ostree-booted ]]; then echo "fedora-atomic"
        else echo "fedora"; fi ;;
      ubuntu) echo "ubuntu" ;;
      *)      echo "unsupported:$id" ;;
    esac
  else
    echo "unsupported"
  fi
}

# ── Installers ────────────────────────────────────────────────────────────────

install_macos() {
  if ! command -v brew &>/dev/null; then
    echo "Homebrew not found. Install it first: https://brew.sh"
    exit 1
  fi
  install_font_macos
  echo "Installing packages via Homebrew..."
  # shellcheck disable=SC2046
  brew install $(grep -v '^\s*$' "$LEAVES_DIR/leaves.txt" | tr '\n' ' ')
}

install_arch() {
  install_font_linux
  install_paru
  echo "Installing packages via pacman..."
  # shellcheck disable=SC2046
  sudo pacman -S --needed $(grep -v '^\s*$' "$LEAVES_DIR/packages-arch.txt" | tr '\n' ' ')
}

install_fedora_atomic() {
  install_font_linux atomic
  echo "Installing packages via rpm-ostree..."
  # shellcheck disable=SC2046
  rpm-ostree install $(grep -v '^\s*$' "$LEAVES_DIR/packages-fedora-atomic.txt" | tr '\n' ' ')

  install_stow_fedora
  install_starship
  install_lazygit
  install_eza_fedora
  install_yazi

  echo ""
  echo "rpm-ostree changes are staged — reboot to apply layered packages."
}

install_fedora() {
  install_font_linux standard
  echo "Installing packages via dnf..."
  # shellcheck disable=SC2046
  sudo dnf install -y $(grep -v '^\s*$' "$LEAVES_DIR/packages-fedora.txt" | tr '\n' ' ')

  install_stow_fedora
  install_starship
  install_lazygit
  install_eza_fedora
  install_yazi
}

install_ubuntu() {
  install_font_linux
  echo "Updating apt..."
  sudo apt update

  echo "Installing packages via apt..."
  # shellcheck disable=SC2046
  sudo apt install -y $(grep -v '^\s*$' "$LEAVES_DIR/packages-ubuntu.txt" | tr '\n' ' ')

  install_starship
  install_lazygit
  install_eza_ubuntu
  install_yazi
}

# ── Main ──────────────────────────────────────────────────────────────────────

OS=$(detect_os)

case "$OS" in
  macos)   install_macos ;;
  arch)    install_arch ;;
  fedora)         install_fedora ;;
  fedora-atomic)  install_fedora_atomic ;;
  ubuntu)  install_ubuntu ;;
  *)
    echo "Unsupported OS: ${OS#unsupported:}"
    echo "Supported: macOS, Arch, Fedora, Ubuntu"
    exit 1
    ;;
esac

echo "Done!"
