#
# .zshenv
#
typeset -U path PATH

path=(~/.local/bin $path)
       
export PATH

# Setting Variables
export EDITOR=/usr/bin/nvim
export VISUAL="$EDITOR"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_DATA_HOME="$HOME/.local/share"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export ZSH_ABBR=/usr/share/zsh/plugins/zsh-abbr/
export ABBR_USER_ABBREVIATIONS_FILE="$ZDOTDIR/user-abbreviations"
export ZSH_PLUGINS="$ZDOTDIR/plugins"
export NVM_DIR="$XDG_DATA_HOME/nvm"
export NVM_LAZY_LOAD=true
export STARSHIP_CONFIG="$ZDOTDIR/starship.toml"
