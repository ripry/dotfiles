# ---
# Options
# ---
# history
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

# directory
setopt AUTO_CD
setopt AUTOPUSHD
setopt PUSHD_IGNORE_DUPS


# ---
# Widgets
# ---
open-history-finder() {
  BUFFER=$(history -n -r 1 | fzf --exact --reverse --query="$LBUFFER")
  CURSOR=${#BUFFER}
  zle reset-prompt
}
zle -N open-history-finder
bindkey "^R" open-history-finder
