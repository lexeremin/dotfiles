# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Determine the operating system
if [[ $(uname) == "Darwin" ]]; then
  OS="macos"
elif [[ $(uname) == "Linux" ]]; then
  OS="linux"

# file management
source <(fzf --zsh)

# starship
eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.config/starship/starship.toml

# suggestions

if [[ "$OS" == "macos" ]]; then
  source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

bindkey '^w' autosuggest-execute
bindkey '^e' autosuggest-accept
bindkey '^u' autosuggest-toggle
bindkey '^k' up-line-or-search
bindkey '^j' down-line-or-search

# syntax highlighting
if [[ "$OS" == "macos" ]]; then
  source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi 

# Aliases for Eza (or exa on Linux)
if command -v eza &> /dev/null; then
  alias la="eza -l --icons --git -a"
  alias lt="eza --tree --level=2 --long --icons --git"
  alias ltree="eza --tree --level=2 --icons --git"
elif command -v exa &> /dev/null; then
  alias la="exa -l --icons --git -a"
  alias lt="exa --tree --level=2 --long --icons --git"
  alias ltree="exa --tree --level=2 --icons --git"
else
  echo "eza/exa not installed"
fi

# Common aliases
alias cdw="cd ~"
alias cdd="cd ~/Developer/Projects"

# macOS-specific aliases
if [[ "$OS" == "macos" ]]; then
  alias cdob="cd ~/Library/Mobile\ Documents/iCloud~md~obsidian/Documents/"
fi

# Added by LM Studio CLI (lms)
if [[ "$OS" == "macos" ]]; then
  export PATH="$PATH:/Users/devalex/.lmstudio/bin"
fi
