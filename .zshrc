#
# ~/.zshrc
#

# Setting the completion path
fpath=($ZDOTDIR/functions $fpath)

autoload -Uz compinit promptinit
autoload -U $fpath[1]/*(.:t)
autoload -Uz run-help-git run-help-ip run-help-openssl run-help-p4 run-help-sudo run-help-svk run-help-svn

compinit; promptinit

HISTFILE="$ZDOTDIR/.zsh_history"
HISTSIZE=10000
SAVEHIST=1000

setopt share_history
setopt hist_ignore_space      # Do not record an event that begins with space.
setopt hist_expire_dups_first # Expire a duplicate event first when trimming history.
setopt hist_ignore_dups       # Do not record an event that was just recorded again.
setopt hist_ignore_all_duPS   # Delete an old recorded event if a new event is a duplicate.
setopt hist_find_no_dups      # Do not display a previously found event.
setopt hist_ignore_space      # Do not record an event starting with a space.
setopt hist_save_no_dups      # Do not write a duplicate event to the history file.
setopt hist_verify            # Do not execute immediately upon history expansion.
setopt extended_glob
setopt glob_dots
setopt autocd
setopt bang_hist              # Treat the '!' character specially during expansion.
setopt inc_append_history     # Write to the history file immediately, not when the shell exits.

if [[ -z "ssh-agent" ]];then
  eval $(ssh-agent -s)
fi

# LS Colors
if [[ "uname" = "Linux" ]]; then
  eval $(dircolors -p > "$XDG_CONFIG_HOME/.dircolors")
 export LS_OPTIONS="--color=auto"
else
 export LS_OPTIONS="-G"
fi

zstyle ':antidote:bundle' use-friendly-names on
zstyle ':completion:*' menu no
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:*' switch-group '<' '>'

# File & Plugin Sourcing
[[ -f "$ZDOTDIR/.fzf_options" ]] && . "$ZDOTDIR/.fzf_options" 

if [[ ! -f "$ZDOTDIR/.antidote/antidote.zsh" ]]; then
  echo "antidote not found, installing...";
  git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote
fi
. "$ZDOTDIR/.antidote/antidote.zsh" && antidote load
 
# Alias Definitions
(( ${+aliases[run-help]} )) && unalias run-help
alias help=run-help 
alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'
alias ls='eza --color=auto'
alias lsa='eza -lA'
alias grep='grep --color=auto'
alias pactree='pactree -c'
alias wget='wget --hsts-file="$XDG_CACHE_HOME/wget-hsts"'
alias ehist='nvim /mnt/c/Users/jeffr/AppData/Roaming/Microsoft/Windows/PowerShell/PSReadLine/ConsoleHost_history.txt'
alias epro='nvim /mnt/c/Users/jeffr/Documents/PowerShell/Microsoft.PowerShell_profile.ps1'
alias yazi='y'

# View man pages with Bat
export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"
zshcache_time="$(date +%s%N)"

# Automatic Rehash
autoload -Uz add-zsh-hook
rehash_precmd() {
  if [[ -a /var/cache/zsh/pacman ]]; then
    local paccache_time="$(date -r /var/cache/zsh/pacman +%s%N)"
    if (( zshcache_time < paccache_time )); then
      rehash
      zshcache_time="$paccache_time"
    fi
  fi
}
add-zsh-hook -Uz precmd rehash_precmd

# Bindings and Line settings
ABBR_DEFAULT_BINDINGS=0 # Remove default bindings
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#8f80a4'
PROMPT='%F{green}%n%f@%F{magenta}%m%f %F{blue}%B%~%b%f %# '
echo -ne '\e[5 q' # Use beam shape cursor on startup.
zle -N zle-keymap-select
zle -N zle-line-init
zle -N fzf-delete-history-widget
zle -N clear-screen-scroll

export KEYTIMEOUT=1
bindkey -v
bindkey -r '^J' # Unset ctrl + j
bindkey -v '^?' backward-delete-char
bindkey '^D' exit_zsh
bindkey '^[^M' abbr-expand # Alt + Enter expands abbreviations
bindkey '^M' accept-line # Enter expands and accepts
bindkey ' ' abbr-expand-and-insert # Spacebar expands then behaves as normal
bindkey '^[ ' magic-space  # Alt + space acts as normal spacebar
bindkey '^L' clear-screen
bindkey '^ ' autosuggest-accept # Ctrl + spacebar accepts suggestion
bindkey -M isearch '^[ ' abbr-expand-and-insert # Alt + space to expand & insert space
bindkey -M isearch ' ' magic-space # Spacebar behaves normally
bindkey -M viins '^[r' fzf-delete-history-widget
bindkey -M vicmd '^[r' fzf-delete-history-widget
bindkey -M emacs '^[r' fzf-delete-history-widget
bindkey -M viins '^[r' fzf-delete-history-widget
bindkey -M vicmd '^[r' fzf-delete-history-widget
bindkey -M emacs '^[r' fzf-delete-history-widget

if [[ -z $+commands[zoxide] ]]; then
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
fi

# - Superfluous conditionals, might be worth optimizing.
#   eval "$(zoxide init zsh --cmd cd)"
# elif
#   [[ -v $+commands[zoxide] ]]; then

source <(fzf --zsh)
eval "$(zoxide init zsh --cmd cd)"
eval "$(starship init zsh)"
