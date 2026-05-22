#!/bin/bash
#
# install-rice.sh — Arch-only ricing installer.
# Installs Hyprland + Waybar + SDDM + supporting userland for a paperlike rice.
# Run AFTER ./install.sh (which handles the base font + tooling).
#
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LEAVES_DIR="$SCRIPT_DIR/leaves"

# ── Guard: Arch only ─────────────────────────────────────────────────────────

if [[ "$(uname)" != "Linux" ]] || [[ ! -f /etc/os-release ]] \
   || ! grep -q '^ID=arch' /etc/os-release; then
  echo "install-rice.sh: Arch Linux only. Detected: $(uname -s) / $(grep ^ID= /etc/os-release 2>/dev/null || echo unknown)"
  exit 1
fi

# ── paru ─────────────────────────────────────────────────────────────────────

if ! command -v paru &>/dev/null; then
  echo "paru not found. Run ./install.sh first to get it."
  exit 1
fi

# ── Packages ─────────────────────────────────────────────────────────────────

echo "Installing rice packages via paru..."
# shellcheck disable=SC2046
paru -S --needed --noconfirm $(grep -vE '^\s*(#|$)' "$LEAVES_DIR/packages-rice-arch.txt" | tr '\n' ' ')

# ── Services ─────────────────────────────────────────────────────────────────

echo "Enabling services..."
sudo systemctl enable sddm.service
sudo systemctl enable NetworkManager.service
sudo systemctl enable bluetooth.service

# ── Groups ───────────────────────────────────────────────────────────────────

echo "Adding $USER to video, input, audio groups..."
sudo usermod -aG video,input,audio "$USER"

# ── SDDM theme + config (root install) ───────────────────────────────────────

if [[ -d "$SCRIPT_DIR/sddm/theme" ]]; then
  echo "Installing SDDM theme to /usr/share/sddm/themes/dotfiles..."
  sudo rm -rf /usr/share/sddm/themes/dotfiles
  sudo cp -r "$SCRIPT_DIR/sddm/theme" /usr/share/sddm/themes/dotfiles
fi
if [[ -f "$SCRIPT_DIR/sddm/sddm.conf" ]]; then
  sudo mkdir -p /etc/sddm.conf.d
  sudo cp "$SCRIPT_DIR/sddm/sddm.conf" /etc/sddm.conf.d/10-dotfiles.conf
fi

# ── Done ─────────────────────────────────────────────────────────────────────

cat <<'EOF'

──────────────────────────────────────────────────────────────────────────────
Rice install complete.

Next steps:
  1. Run ./setup-rice.sh to stow the rice configs and pick a theme.
  2. Log out (or reboot) and select the "Hyprland" session in SDDM.
  3. Group changes (video/input/audio) need a fresh login to take effect.
──────────────────────────────────────────────────────────────────────────────
EOF
