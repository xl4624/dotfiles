# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#
# Oh My Zsh Configuration
#

export ZSH="$HOME/.oh-my-zsh"

# Theme
# ZSH_THEME="spaceship"

# Settings
DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_LS_COLORS="true"
DISABLE_AUTO_TITLE="true" # fix commands being repeated in the output
ENABLE_CORRECTION="true"

# Plugins
plugins=(
  archlinux
  fzf
  git
  zoxide
  pip
  rust
  docker
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Autosuggestions settings
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=59'
ZSH_AUTOSUGGEST_IGNORE="?(#c50,)" # don't suggest commands with longer than 50 chars
# for speed: https://github.com/zsh-users/zsh-autosuggestions#disabling-automatic-widget-re-binding
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
ZSH_AUTOSUGGEST_STRATEGY=(history)

# Initialize Oh My Zsh
source $ZSH/oh-my-zsh.sh

#
# Environment Variables
#

export EDITOR='nvim'
export AIRPODS="F0:04:E1:E3:21:10"
export GOPATH=$HOME/.go
export OLLAMA_API_BASE=http://127.0.0.1:11434

# PATH configuration
export PATH=/usr/local/texlive/2024/bin/x86_64-linux:$PATH
export PATH="$HOME/.local/share/gem/ruby/3.3.0/bin:$PATH"
export PATH="$PATH:/home/xiaomin/.local/bin"

# Pager settings
export LESS=-FRX
export MANROFFOPT="-c"
export MANPAGER="sh -c 'col -bx | bat -plman'"

#
# History
#

HISTSIZE=1000000
HISTFILE="$HOME/.zsh_history"
SAVEHIST=$HISTSIZE

#
# Shell Options
#

setopt AUTO_CD              # .. is shortcut for cd .. (etc)
setopt AUTO_REMOVE_SLASH    # remove trailing slash
setopt AUTO_PUSHD           # cd automatically pushes old dir onto dir stack
setopt CORRECT_ALL          # argument auto-correction
setopt HIST_FIND_NO_DUPS    # filter contiguous duplicates from history
setopt HIST_IGNORE_SPACE    # don't record commands starting with a space
setopt IGNORE_EOF           # prevent C-d from exiting shell
setopt INTERACTIVE_COMMENTS # allow comments, even in interactive shells
setopt LIST_PACKED          # make completions lists more densely packed
setopt MENU_COMPLETE        # auto-insert first possible ambiguous completion
setopt PRINT_EXIT_VALUE     # for non-zero exit status
setopt PUSHD_IGNORE_DUPS    # don't push multiple copies of same dir onto stack
setopt PUSHD_SILENT         # don't print dir stack after pushing/popping
setopt SHARE_HISTORY        # share history across shells

#
# Aliases
#

alias cd=z
alias vim=nvim
alias ls="eza --icons"
alias ll="eza -al --icons"
alias lt="eza -a --tree --level=1 --icons"
alias neofetch=fastfetch
alias jupyter="nocorrect jupyter"
alias git="nocorrect git"
alias make="nocorrect make"
alias deluser=userdel

#
# Functions
#

function tmux() {
  emulate -L zsh

  local ENV_OVERRIDES=()

  # Make sure even pre-existing tmux sessions use the latest SSH_AUTH_SOCK.
  # Inspired by: https://gist.github.com/lann/6771001
  if [ -r "$SSH_AUTH_SOCK" -a ! -L "$SSH_AUTH_SOCK" ]; then
    ln -sf "$SSH_AUTH_SOCK" "$HOME/.ssh/ssh_auth_sock"
    ENV_OVERRIDES+=(SSH_AUTH_SOCK="$HOME/.ssh/ssh_auth_sock")
  fi

  # If provided with args, pass them through.
  if [[ -n "$@" ]]; then
    env "${ENV_OVERRIDES[@]}" tmux "$@"
    return
  fi

  # Attach to existing session, or create one, based on current directory.
  local SESSION_NAME=$(basename "${$(pwd)//[.:]/_}")
  env "${ENV_OVERRIDES[@]}" tmux new -A -s "$SESSION_NAME"
}

# if the command ends with !, then replace it with '&>/dev/null & disown'
function accept-line-background {
  if [[ $BUFFER == *\! ]]; then
    BUFFER="${BUFFER%\!} &>/dev/null & disown"
  fi
  zle accept-line
}
zle -N accept-line-background
bindkey '\r' accept-line-background
bindkey '\n' accept-line-background
bindkey '^x^x' accept-line  # in case accept-line-background ever fails

# Edit last command output in nvim (uses tmux capture-pane)
edit-last-command-output() {
  if [[ "$TERM" =~ "tmux" ]]; then
    tmux capture-pane -p -S - -E - -J | tac | awk '
      found && !/❯/ { print }
      /❯/ && !found { found=1; next }
      /❯/ && found {exit}
    ' | tac | nvim -
  else
    echo
    print -Pn "%F{red}error: can't capture last command output outside of tmux%f"
    zle accept-line
  fi
}
zle -N edit-last-command-output
bindkey '^x^o' edit-last-command-output

function mdview() {
  pandoc $1 > /tmp/$1.html
  xdg-open /tmp/$1.html
}

#
# Tool Initializations
#

# zoxide
eval "$(zoxide init zsh)"

# fzf
source <(fzf --zsh)

# pipx completion - only rebuild compinit once a day
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi
eval "$(register-python-argcomplete pipx)"

# nvm
export NVM_DIR="$HOME/.nvm"
source /usr/share/nvm/init-nvm.sh

# conda
__conda_setup="$('/home/xiaomin/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/xiaomin/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/xiaomin/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/xiaomin/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup

# ghcup
[ -f "/home/xiaomin/.ghcup/env" ] && . "/home/xiaomin/.ghcup/env"

# pnpm
export PNPM_HOME="/home/xiaomin/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# opam
[[ ! -r '/home/xiaomin/.opam/opam-init/init.zsh' ]] || source '/home/xiaomin/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null

#
# Powerlevel10k Theme
#

source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
