export HISTFILE=${ZDOTDIR:-${HOME}}/.zhistory
export HISTSIZE=1200000
export SAVEHIST=1000000

setopt APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY_TIME
setopt SHARE_HISTORY

function open-history-finder() {
  BUFFER=$(history -n -r 1 | fzf --exact --reverse --query="$LBUFFER")
  CURSOR=${#BUFFER}
  zle reset-prompt
}
zle -N open-history-finder
bindkey '^R' open-history-finder