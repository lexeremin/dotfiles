#!/bin/bash
#
# setup-rice.sh — stow rice configs + apply rice theme.
# Runs independently of setup.sh. Arch-only; only touches Wayland-side configs.
#
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

mkdir -p "$HOME/.config"

sedi() { if [[ "$(uname)" == "Darwin" ]]; then sed -i '' "$@"; else sed -i "$@"; fi; }

show_help() {
  cat <<EOF
Usage: $0 [--restow|--unstow] [theme]
Stow rice dotfiles + apply a theme to Hyprland/Waybar/Fuzzel/Dunst/Hyprlock.

  --restow      Update symlinks by removing and recreating them.
  --unstow      Remove rice symlinks and restore backups.
  theme         Optional theme name (skips interactive prompt).
EOF
  exit 0
}

# Rice stow packages (each becomes ~/.config/<name>)
RICE_PKGS=(hypr waybar fuzzel dunst Thunar hyprlock hypridle swww)

# ── Args ─────────────────────────────────────────────────────────────────────
MODE="stow"
THEME_ARG=""
for a in "$@"; do
  case "$a" in
    --restow) MODE="restow" ;;
    --unstow) MODE="unstow" ;;
    -h|--help) show_help ;;
    *) THEME_ARG="$a" ;;
  esac
done

# ── Theme selection ──────────────────────────────────────────────────────────
THEMES=()
for f in themes/*.json; do
  [[ -f "$f" ]] && THEMES+=("$(basename "$f" .json)")
done

THEME=""
if [[ -n "$THEME_ARG" ]]; then
  for t in "${THEMES[@]}"; do [[ "$t" == "$THEME_ARG" ]] && THEME="$t"; done
  [[ -z "$THEME" ]] && { echo "Unknown theme: $THEME_ARG"; exit 1; }
elif [[ "$MODE" != "unstow" ]]; then
  echo "Available themes:"
  for i in "${!THEMES[@]}"; do echo "  $((i+1)). ${THEMES[$i]}"; done
  read -rp "Choose a theme [1]: " THEME_CHOICE
  THEME_CHOICE="${THEME_CHOICE:-1}"
  THEME="${THEMES[$((THEME_CHOICE-1))]}"
fi

# ── Backup helpers ───────────────────────────────────────────────────────────
backup_existing() {
  local target="$1"
  if [[ -e "$target" && ! -L "$target" ]]; then
    echo "Backing up $target to $target.bak"
    mv "$target" "$target.bak"
  fi
}
restore_backup() {
  local target="$1"
  if [[ -e "$target.bak" ]]; then
    echo "Restoring $target.bak to $target"
    mv "$target.bak" "$target"
  fi
}

# ── Apply theme ──────────────────────────────────────────────────────────────
apply_rice_theme() {
  local theme="$1"
  local json="themes/$theme.json"
  [[ ! -f "$json" ]] && { echo "Missing theme JSON: $json"; exit 1; }

  local theme_type
  theme_type=$(grep '"type"' "$json" | sed 's/.*: *"\([^"]*\)".*/\1/' | head -1)

  echo "Applying rice theme: $theme ($theme_type)"

  mkdir -p ~/.config/hypr ~/.config/waybar ~/.config/fuzzel \
           ~/.config/dunst ~/.config/hyprlock

  # Hyprland border colors — copy theme Lua, exposed as ~/.config/hypr/current-theme.lua
  cp "hypr/themes/$theme.lua" ~/.config/hypr/current-theme.lua

  # Hyprlock colors — Hyprland config dir (shared with hypr namespace)
  cp "hyprlock/themes/$theme.conf" ~/.config/hypr/current-theme-hyprlock.conf

  # Waybar colors
  cp "waybar/themes/$theme.css" ~/.config/waybar/current-theme.css

  # Fuzzel colors
  cp "fuzzel/themes/$theme.ini" ~/.config/fuzzel/colors.ini

  # Dunst — concat base + per-theme so the later sections override
  cat dunst/dunstrc "dunst/themes/$theme.conf" > ~/.config/dunst/dunstrc

  # SDDM theme colors (writes /usr/share/sddm/themes/dotfiles/theme.conf)
  if [[ -d /usr/share/sddm/themes/dotfiles ]]; then
    local bg fg accent muted
    bg=$(grep '"bg"'     "$json" | sed 's/.*: *"\([^"]*\)".*/\1/' | head -1)
    fg=$(grep '"fg"'     "$json" | sed 's/.*: *"\([^"]*\)".*/\1/' | head -1)
    accent=$(grep '"primary"' "$json" | sed 's/.*: *"\([^"]*\)".*/\1/' | head -1)
    muted=$(grep '"subtle"'   "$json" | sed 's/.*: *"\([^"]*\)".*/\1/' | head -1)
    sudo tee /usr/share/sddm/themes/dotfiles/theme.conf >/dev/null <<EOF
[General]
background=$bg
foreground=$fg
accent=$accent
muted=$muted
font=JetBrains Mono
EOF
  fi

  # GTK / icon theme + color scheme via gsettings (no-op on systems without it)
  if command -v gsettings &>/dev/null; then
    if [[ "$theme_type" == "dark" ]]; then
      gsettings set org.gnome.desktop.interface gtk-theme   "Adwaita-dark"   || true
      gsettings set org.gnome.desktop.interface icon-theme  "Papirus-Dark"   || true
      gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"   || true
    else
      gsettings set org.gnome.desktop.interface gtk-theme   "Adwaita"        || true
      gsettings set org.gnome.desktop.interface icon-theme  "Papirus-Light"  || true
      gsettings set org.gnome.desktop.interface color-scheme "prefer-light"  || true
    fi
  fi

  # Live reload signals — safe to fail when nothing is running yet
  hyprctl reload >/dev/null 2>&1 || true
  pkill -SIGUSR2 waybar 2>/dev/null || true
  pkill dunst 2>/dev/null; setsid dunst >/dev/null 2>&1 &
}

# ── Stow / unstow / restow rice packages ─────────────────────────────────────
do_stow() {
  for pkg in "${RICE_PKGS[@]}"; do
    [[ ! -d "$pkg" ]] && continue
    backup_existing "$HOME/.config/$pkg"
  done
  case "$MODE" in
    stow)    stow --target "$HOME/.config" -v "${RICE_PKGS[@]}" ;;
    restow)  stow --target "$HOME/.config" --restow -v "${RICE_PKGS[@]}" ;;
    unstow)
      stow --target "$HOME/.config" --delete -v "${RICE_PKGS[@]}"
      for pkg in "${RICE_PKGS[@]}"; do restore_backup "$HOME/.config/$pkg"; done
      ;;
  esac
}

# ── Main ─────────────────────────────────────────────────────────────────────
do_stow

if [[ "$MODE" != "unstow" && -n "$THEME" ]]; then
  apply_rice_theme "$THEME"
fi

echo "Done!"
