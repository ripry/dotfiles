CONFIG_HOME=${XDG_CONFIG_HOME:-~/.config}
CACHE_HOME=${XDG_CACHE_HOME:-~/.cache}


# Cache the result of `sheldon source` when sheldon config is updated.
SHELDON_SOURCE_CACHE="$CACHE_HOME/sheldon/source.zsh"
SHELDON_CONFIG="$CONFIG_HOME/sheldon/plugins.toml"

if [[ ! -r "$SHELDON_SOURCE_CACHE" || "$SHELDON_CONFIG" -nt "$SHELDON_SOURCE_CACHE" ]]; then
  mkdir -p $(dirname $SHELDON_SOURCE_CACHE)
  sheldon --quiet source > $SHELDON_SOURCE_CACHE
fi
source "$SHELDON_SOURCE_CACHE"

unset SHELDON_SOURCE_CACHE SHELDON_CONFIG


unset CONFIG_HOME CACHE_HOME
