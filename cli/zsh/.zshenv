export LANG=en_US.UTF-8
export EDITOR="nvim"


# Homebrew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# ref: https://docs.brew.sh/Shell-Completion#configuring-completions-in-zsh
if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi
