#!/bin/bash
# Generates per-app terminal theme files from themes/*.json.
# Apps: alacritty, kitty, wezterm, tmux, ghostty
# Run after adding or editing a theme JSON to regenerate all app files.

set -euo pipefail
DOTFILES="$(cd "$(dirname "$0")" && pwd)"

command -v jq >/dev/null 2>&1 || { echo "jq is required but not installed."; exit 1; }

for json in "$DOTFILES"/themes/*.json; do
  [[ -f "$json" ]] || continue
  theme=$(jq -r '.name' "$json")

  bg=$(jq -r '.colors.bg'      "$json")
  fg=$(jq -r '.colors.fg'      "$json")
  primary=$(jq -r '.colors.primary' "$json")
  bg_alt=$(jq -r '.colors.bg_alt'  "$json")

  a=()
  for i in {0..15}; do
    a+=("$(jq -r ".ansi[$i]" "$json")")
  done

  echo "Generating: $theme"

  # ── Alacritty ──────────────────────────────────────────────────────────────
  cat > "$DOTFILES/alacritty/themes/$theme.toml" <<TOML
[colors.primary]
background = "$bg"
foreground = "$fg"

[colors.cursor]
cursor = "$primary"
text   = "$fg"

[colors.selection]
background = "$bg_alt"
text       = "$fg"

[colors.normal]
black   = "${a[0]}"
red     = "${a[1]}"
green   = "${a[2]}"
yellow  = "${a[3]}"
blue    = "${a[4]}"
magenta = "${a[5]}"
cyan    = "${a[6]}"
white   = "${a[7]}"

[colors.bright]
black   = "${a[8]}"
red     = "${a[9]}"
green   = "${a[10]}"
yellow  = "${a[11]}"
blue    = "${a[12]}"
magenta = "${a[13]}"
cyan    = "${a[14]}"
white   = "${a[15]}"
TOML

  # ── Kitty ──────────────────────────────────────────────────────────────────
  cat > "$DOTFILES/kitty/themes/$theme.conf" <<CONF
# vim:ft=kitty

foreground $fg
background $bg
selection_foreground none
selection_background $bg_alt

cursor $primary
cursor_text_color $fg

color0  ${a[0]}
color8  ${a[8]}

color1  ${a[1]}
color9  ${a[9]}

color2  ${a[2]}
color10 ${a[10]}

color3  ${a[3]}
color11 ${a[11]}

color4  ${a[4]}
color12 ${a[12]}

color5  ${a[5]}
color13 ${a[13]}

color6  ${a[6]}
color14 ${a[14]}

color7  ${a[7]}
color15 ${a[15]}
CONF

  # ── WezTerm ────────────────────────────────────────────────────────────────
  cat > "$DOTFILES/wezterm/themes/$theme.lua" <<LUA
return {
  foreground    = "$fg",
  background    = "$bg",
  cursor_bg     = "$primary",
  cursor_border = "$primary",
  cursor_fg     = "$fg",
  selection_bg  = "$bg_alt",
  selection_fg  = "$fg",
  ansi    = { "${a[0]}", "${a[1]}", "${a[2]}", "${a[3]}", "${a[4]}", "${a[5]}", "${a[6]}", "${a[7]}" },
  brights = { "${a[8]}", "${a[9]}", "${a[10]}", "${a[11]}", "${a[12]}", "${a[13]}", "${a[14]}", "${a[15]}" },
}
LUA

  # ── Tmux ───────────────────────────────────────────────────────────────────
  cat > "$DOTFILES/tmux/themes/$theme.conf" <<CONF
set -g pane-active-border-style    'fg=$primary,bg=default'
set -g pane-border-style           'fg=${a[7]},bg=default'
set -g status-style                'bg=default,fg=${a[7]}'
set -g window-status-current-style 'fg=$primary,bold'
set -g window-status-style         'fg=${a[7]}'
CONF

  # ── Ghostty ────────────────────────────────────────────────────────────────
  {
    echo "background = $bg"
    echo "foreground = $fg"
    echo "cursor-color = $primary"
    for i in {0..7};  do echo "palette = $i=${a[$i]}"; done
    echo ""
    for i in {8..15}; do echo "palette = $i=${a[$i]}"; done
  } > "$DOTFILES/ghostty/themes/$theme"

done

echo "All theme files generated."
