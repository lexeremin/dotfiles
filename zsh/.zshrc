# You may need to manually set your language environment
export LANG=en_US.UTF-8

# file management
source <(fzf --zsh)

# starship
eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.config/starship/starship.toml

# suggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey '^w' autosuggest-execute
bindkey '^e' autosuggest-accept
bindkey '^u' autosuggest-toggle
bindkey '^k' up-line-or-search
bindkey '^j' down-line-or-search

# syntax highlighting
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Eza
alias la="eza -l --icons --git -a"
alias lt="eza --tree --level=2 --long --icons --git"
alias ltree="eza --tree --level=2  --icons --git"
alias cdw="cd ~"
alias cdob="cd /Users/devalex/Library/Mobile\ Documents/iCloud~md~obsidian/Documents/"
alias cdd="cd ~/Developer/Projects"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/devalex/.lmstudio/bin"
