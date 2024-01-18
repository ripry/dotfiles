mise() {
  unset -f mise
  eval \"$(mise activate zsh)\"
  mise $@
}
