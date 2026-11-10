# .zshrc

# Only configure interactive shells
[[ $- == *i* ]] || return

# shellcheck source=/dev/null
source "${HOME}/.bash_profile"

# Completion
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
unsetopt LIST_AMBIGUOUS

# Prefix history search on the up and down arrows
bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward
