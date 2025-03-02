#!/bin/bash

# Define the list of directories to rename (edit this list as needed)
DIRS=("nvim" "ghostty" "alacritty" "tmux" "starship") # Replace with your directory names

# Base directory
BASE_DIR="$HOME/.config"

# Print the list of directories that will be renamed
echo "The following directories in $BASE_DIR will be renamed:"
for DIR in "${DIRS[@]}"; do
  echo "  - $DIR -> $DIR.bak"
done

# Ask for confirmation
read -p "Do you want to proceed? (y/n) " -n 1 -r
echo # Move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Aborted."
  exit 1
fi

# Loop through each directory in the list
for DIR in "${DIRS[@]}"; do
  FULL_PATH="$BASE_DIR/$DIR"
  BAK_PATH="$FULL_PATH.bak"

  # Check if the directory exists
  if [ ! -d "$FULL_PATH" ]; then
    echo "Warning: Directory '$FULL_PATH' does not exist. Skipping..."
    continue
  fi

  # Check if the backup directory already exists
  if [ -e "$BAK_PATH" ]; then
    echo "Warning: Backup directory '$BAK_PATH' already exists. Skipping..."
    continue
  fi

  # Rename the directory
  mv -v "$FULL_PATH" "$BAK_PATH"
done
