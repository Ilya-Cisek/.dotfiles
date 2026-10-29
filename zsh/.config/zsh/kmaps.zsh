# Match the Up and Down arrow history search behavior.
bindkey '^P' up-line-or-beginning-search
bindkey '^N' down-line-or-beginning-search

# Accept history suggestions only with Alt+L.
ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=()
bindkey '^[l' autosuggest-accept

# Open the current command in $EDITOR with Ctrl+G.
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^G' edit-command-line
bindkey -r '^X^E'
