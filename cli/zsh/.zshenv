export LANG=en_US.UTF-8
export EDITOR="nvim"
export VISUAL="code --wait"

export CONFIG_HOME=${XDG_CONFIG_HOME:-~/.config}
export CACHE_HOME=${XDG_CACHE_HOME:-~/.cache}
export DATA_HOME=${XDG_DATA_HOME:-~/.local/share}
export STATE_HOME=${XDG_STATE_HOME:-~/.local/state}
# ignore: RUNTIME_DIR, DATA_DIRS, CONFIG_DIRS

export HISTFILE=${ZDOTDIR:-${HOME}}/.zhistory
export HISTSIZE=1200000
export SAVEHIST=1000000
