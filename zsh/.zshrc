#!/bin/sh
# HISTFILE="$XDG_DATA_HOME"/zsh/history
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
export PATH="$HOME/.local/bin":$PATH
export MANPAGER='nvim +Man!'
export MANWIDTH=999
export PATH=$HOME/.cargo/bin:$PATH
export PATH=$HOME/.local/share/go/bin:$PATH
export GOPATH=$HOME/.local/share/go
export PATH=/home/komil/.fnm:$PATH

# some useful options (man zshoptions)
setopt autocd extendedglob nomatch menucomplete
setopt interactive_comments
stty stop undef		# Disable ctrl-s to freeze terminal.
zle_highlight=('paste:none')

# beeping is annoying
unsetopt BEEP

# completions
autoload -Uz compinit
zstyle ':completion:*' menu select
zstyle ':completion::complete:lsof:*' menu yes select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey -M menuselect '^[[Z' reverse-menu-complete

# Colors
autoload -Uz colors && colors

alias ls="ls --color=always"
alias ll="ls -l --color=always"
alias la="ls -a --color=always"

# nvm
export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# source ~/.gitstatus/gitstatus.prompt.zsh
source ~/.prompt/zsh-prompt
source /home/komil/.zsh-vi-mode/zsh-vi-mode.plugin.zsh
# source /home/komil/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


eval "$(zoxide init zsh)"
eval "$(thefuck --alias)"
eval "$(atuin init zsh)"
[[ $commands[kubectl] ]] && source <(kubectl completion zsh)
