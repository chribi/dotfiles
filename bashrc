#!/bin/bash

# In .bashrc:
# ```sh
# DOTFILES=/path/to/dotfiles
# source $DOTFILES/bashrc
# ```
eval "$(oh-my-posh.exe init bash --config "$DOTFILES/ohmyposh.json")"

export RIPGREP_CONFIG_PATH="$DOTFILES/ripgreprc"
export BAT_CONFIG_PATH="$DOTFILES/batrc"

## Alias {{{

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

alias ll="ls -l"

alias gti=git
alias add="git add"
alias gs="git status"
alias gd="git diff"
alias gds="git diff --staged"
alias gc="git commit"
alias gca="git commit -a"
alias amend="git commit --amend"
alias amendwq="git commit --amend --no-edit"

## }}}

# vim: fdm=marker
