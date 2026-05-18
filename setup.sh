#!/bin/bash

sedi() { if [[ "$(uname)" == "Darwin" ]]; then sed -i '' "$@"; else sed -i "$@"; fi; }

# Display help message
show_help() {
  echo "Usage: $0 [--restow|--unstow]"
  echo "Manage dotfiles symlinks using GNU Stow and backup existing setup."
  echo "Options:"
  echo "  --restow   Update symlinks by removing and recreating them."
  echo "  --unstow   Remove symlinks and restore backups."
  echo "  (default)  Create symlinks."
  exit 0
}

# Parse command-line arguments
MODE="stow" # Default mode

if [[ "$1" == "--restow" ]]; then
  MODE="restow"
elif [[ "$1" == "--unstow" ]]; then
  MODE="unstow"
elif [[ "$1" == "--help" || "$1" == "-h" ]]; then
  show_help
fi

# Read .stowrc to get ignore patterns
IGNORE_PATTERNS=()

if [[ -f .stowrc ]]; then
  while IFS= read -r line; do
    if [[ "$line" == --ignore=* ]]; then
      IGNORE_PATTERNS+=("${line#--ignore=}")
    fi
  done <.stowrc
fi

# Always ignore the .git directory
IGNORE_PATTERNS+=(".git")

# Function to check if a directory should be ignored
should_ignore() {
  local dir="$1"

  for pattern in "${IGNORE_PATTERNS[@]}"; do
    if [[ "$dir" == "$pattern" || "$dir" == *"/$pattern" ]]; then
      return 0 # Directory should be ignored
    fi
  done

  return 1 # Directory should not be ignored
}

# Get a list of all directories in the dotfiles directory
DIRS=()

while IFS= read -r -d '' dir; do
  dir_name="${dir#./}" # Remove leading ./
  if ! should_ignore "$dir_name"; then
    DIRS+=("$dir_name")
  fi
done < <(find . -mindepth 1 -maxdepth 1 -type d -print0)

# Function to rename directories and files to .bak
backup_existing() {
  local target="$1"

  if [[ -e "$target" && ! -L "$target" ]]; then
    echo "Backing up $target to $target.bak..."
    mv "$target" "$target.bak"
  fi
}

# Function to restore directories and files from .bak
restore_backup() {
  local target="$1"

  if [[ -e "$target.bak" ]]; then
    echo "Restoring $target.bak to $target..."
    mv "$target.bak" "$target"
  fi
}

# ── Theme switcher ────────────────────────────────────────────────────────────

apply_theme() {
  local theme="$1"
  local json="themes/$theme.json"

  if [[ ! -f "$json" ]]; then
    echo "Theme file not found: $json"
    exit 1
  fi

  get_val() { grep "\"$1\"" "$json" | sed 's/.*: *"\([^"]*\)".*/\1/' | head -1; }

  local ghostty_theme=$(get_val ghostty_theme)
  local starship_palette=$(get_val starship_palette)
  local nvim_colorscheme=$(get_val nvim_colorscheme)
  local nvim_lualine=$(get_val nvim_lualine)
  local vscode_theme=$(get_val vscode_theme)
  local pi_theme=$(get_val pi_theme)

  echo "Applying theme: $theme"

  # Include-based: copy pre-built theme files to ~/.config/
  mkdir -p ~/.config/alacritty ~/.config/kitty ~/.config/wezterm ~/.config/tmux
  cp "alacritty/themes/$theme.toml" ~/.config/alacritty/current-theme.toml
  cp "kitty/themes/$theme.conf"     ~/.config/kitty/current-theme.conf
  cp "wezterm/themes/$theme.lua"    ~/.config/wezterm/current-theme.lua
  cp "tmux/themes/$theme.conf"      ~/.config/tmux/current-theme.conf

  # Name-based: patch single-line theme references in dotfiles configs
  sedi "s/^theme = .*/theme = $ghostty_theme/" ghostty/config
  # Also patch the live ghostty config in case it isn't stow-symlinked
  [[ -f ~/.config/ghostty/config ]] && \
    sedi "s/^theme = .*/theme = $ghostty_theme/" ~/.config/ghostty/config
  sedi "s/^palette = .*/palette = \"$starship_palette\"/" starship/starship.toml
  sedi 's/colorscheme = "[^"]*"/colorscheme = "'"$nvim_colorscheme"'"/' \
    nvim/lua/plugins/colorscheme.lua
  sedi 's/theme = "[^"]*"/theme = "'"$nvim_lualine"'"/' \
    nvim/lua/plugins/ui.lua
  sedi 's/"workbench\.colorTheme": "[^"]*"/"workbench.colorTheme": "'"$vscode_theme"'"/' \
    vscode/settings.json
  sedi 's/"theme": "[^"]*"/"theme": "'"$pi_theme"'"/' \
    pi/.pi/agent/settings.json

  # Copy: chrome + firefox manifests + vscode colorscheme
  cp "chrome/themes/$theme.json"        chrome/manifest.json
  cp "firefox/themes/$theme.json"       firefox/manifest.json
  cp "vscode/themes/$theme.jsonc"       vscode/colorscheme.jsonc
}

# Discover available themes
THEMES=()
for f in themes/*.json; do
  [[ -f "$f" ]] && THEMES+=("$(basename "$f" .json)")
done

if [[ ${#THEMES[@]} -gt 0 ]]; then
  echo "Available themes:"
  for i in "${!THEMES[@]}"; do
    echo "  $((i+1)). ${THEMES[$i]}"
  done
  read -rp "Choose a theme [1]: " THEME_CHOICE
  THEME_CHOICE="${THEME_CHOICE:-1}"
  THEME="${THEMES[$((THEME_CHOICE-1))]}"
  echo "Using theme: $THEME"
  apply_theme "$THEME"
fi

# ─────────────────────────────────────────────────────────────────────────────

# Backup pi config files (stowed separately to ~, not ~/.config)
PI_CONFIG_FILES=("$HOME/.pi/agent/models.json" "$HOME/.pi/agent/settings.json")
for file in "${PI_CONFIG_FILES[@]}"; do
  backup_existing "$file"
done

# Backup existing directories in ~/.config/
for dir in "${DIRS[@]}"; do
  config_dir="$HOME/.config/${dir}"
  backup_existing "$config_dir"
  #define widow style for alacritty depending on the OS
  if [[ "$dir" == "alacritty" ]]; then
    if [[ "$(uname)" == "Darwin" ]]; then
      DECORATIONS="buttonless"
    else
      DECORATIONS="none"
    fi
    echo "[window]" >./alacritty/decoration.toml
    echo "" >>./alacritty/decoration.toml
    echo "decorations = '$DECORATIONS'" >>./alacritty/decoration.toml
  fi
  if [[ "$dir" == "ghostty" ]]; then
    if [[ "$(uname)" == "Darwin" ]]; then
      echo "macos-titlebar-style = hidden" >./ghostty/macos
    else
      echo "window-decoration = false" >./ghostty/linux
    fi
  fi
done

# Backup Zsh-related files in the home directory
ZSH_FILES=(".zshrc" ".zlogin" ".zprofile" ".zshenv")

for file in "${ZSH_FILES[@]}"; do
  zsh_file="$HOME/$file"
  backup_existing "$zsh_file"
done

echo "export ZDOTDIR=$HOME/.config/zsh" >~/.zshenv

case "$MODE" in
"stow")
  echo "Stowing..."
  stow -v .
  stow --target ~ -v pi
  ;;
"restow")
  echo "Restowing..."
  stow -v --restow .
  stow --target ~ --restow -v pi
  ;;
"unstow")
  echo "Unstowing..."
  stow -v --delete .
  stow --target ~ --delete -v pi
  ;;
*)
  echo "Invalid mode: $MODE"
  exit 1
  ;;
esac

# Restore backups after unstow
if [[ "$MODE" == "unstow" ]]; then
  rm ~/.zshenv
  # Restore directories in ~/.config/
  for dir in "${DIRS[@]}"; do
    config_dir="$HOME/.config/${dir}"
    restore_backup "$config_dir"
  done

  # Restore Zsh-related files in the home directory
  for file in "${ZSH_FILES[@]}"; do
    zsh_file="$HOME/$file"
    restore_backup "$zsh_file"
  done

  # Restore pi config files
  for file in "${PI_CONFIG_FILES[@]}"; do
    restore_backup "$file"
  done
fi

echo "Done!"
