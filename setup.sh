#!/bin/bash

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
done

# Backup Zsh-related files in the home directory
ZSH_FILES=(".zshrc" ".zlogin" ".zprofile" ".zshenv")

for file in "${ZSH_FILES[@]}"; do
  zsh_file="$HOME/$file"
  backup_existing "$zsh_file"
done

echo "export ZDOTDIR=$HOME/.config/zsh" >~/.zshenv

# Run stow, restow, or unstow for each directory
# for dir in "${DIRS[@]}"; do
#   case "$MODE" in
#   "stow")
#     echo "Stowing $dir..."
#     if [[ "$dir" == "zsh" ]]; then
#       # Symlink zsh files to home directory
#       stow --verbose -t "$HOME/" "$dir"
#     else
#       stow --verbose -t "$HOME/.config/${dir}" "$dir"
#     fi
#     ;;
#   "restow")
#     echo "Restowing $dir..."
#     if [[ "$dir" == "zsh" ]]; then
#       # Restow zsh files to home directory
#       stow --restow --verbose -t "$HOME/" "$dir"
#     else
#       stow --restow --verbose -t "$HOME/.config/${dir}" "$dir"
#     fi
#     ;;
#   "unstow")
#     echo "Unstowing $dir..."
#     if [[ "$dir" == "zsh" ]]; then
#       # Unstow zsh files from home directory
#       stow --delete --verbose -t "$HOME/" "$dir"
#     else
#       stow --delete --verbose -t "$HOME/.config/${dir}" "$dir"
#     fi
#     ;;
#   *)
#     echo "Invalid mode: $MODE"
#     exit 1
#     ;;
#   esac
# done

case "$MODE" in
"stow")
  echo "Stowing..."
  stow -v .
  ;;
"restow")
  echo "Restowing..."
  stow -v --restow .
  ;;
"unstow")
  echo "Unstowing..."
  stow -v --delete .
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
fi

echo "Done!"
