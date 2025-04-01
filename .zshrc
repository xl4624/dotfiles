#t Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# path to Oh My Zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="spaceship"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true" # fix commands being repeated in the output

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# 
# Plugins
#

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

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=59'
ZSH_AUTOSUGGEST_IGNORE="?(#c50,)" # don't suggest commands with longer than 50 chars
# for speed: # https://github.com/zsh-users/zsh-autosuggestions#disabling-automatic-widget-re-binding
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd completion)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Initialize zoxide
eval "$(zoxide init zsh)"

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

# Custom variables
export AIRPODS="08:25:73:53:D8:97"
export GOPATH=$HOME/.go
export OLLAMA_API_BASE=http://127.0.0.1:11434

export PATH=/usr/local/texlive/2024/bin/x86_64-linux:$PATH # Tex Live
export PATH="$HOME/.local/share/gem/ruby/3.3.0/bin:$PATH"

# Add flags to the less pager during git diff
export LESS=-FRX 

# Use bat as man pager and fix issue with bolding, see: https://github.com/sharkdp/bat/issues/652
export MANROFFOPT="-c"
export MANPAGER="sh -c 'col -bx | bat -plman'" man sprintf

#
# History
#

HISTSIZE=1000000
HISTFILE="$HOME/.zsh_history"
SAVEHIST=$HISTSIZE

#
# Options (man zshoptions)
#

setopt AUTO_CD              # [default] .. is shortcut for cd .. (etc)
setopt AUTO_REMOVE_SLASH    # [default] remove slash
setopt AUTO_PUSHD           # [default] cd automatically pushed old dir onto dir stack
setopt CORRECT		    # [default] command auto-correction
setopt CORRECT_ALL	    # [default] argument auto-correction
setopt HIST_FIND_NO_DUPS    # filter contiguous duplicates from history
setopt HIST_IGNORE_SPACE    # [default] don't record commands starting with a space
setopt IGNORE_EOF           # [default] prevent C-d from exiting shell
setopt INTERACTIVE_COMMENTS # [default] allow comments, even in interactive shells
setopt LIST_PACKED	    # make completions lists more densely packed
setopt MENU_COMPLETE	    # auto-insert first possible ambiguous completion
setopt PRINT_EXIT_VALUE     # for non-zero exit status
setopt PUSHD_IGNORE_DUPS    # don't push multiple copies of same dir onto stack
setopt PUSHD_SILENT	    # don't print dir stack after pushing/popping
setopt SHARE_HISTORY	    # share history across shells

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

# Created by 'pipx'
autoload -U compinit && compinit
eval "$(register-python-argcomplete pipx)"
export PATH="$PATH:/home/xiaomin/.local/bin"

source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
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
# <<< conda initialize <<<
#
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Created by 'ghcup'
[ -f "/home/xiaomin/.ghcup/env" ] && . "/home/xiaomin/.ghcup/env" # ghcup-env

# pnpm
export PNPM_HOME="/home/xiaomin/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
