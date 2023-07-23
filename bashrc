#!/bin/bash

# In .bashrc:
# ```sh
# DOTFILES=/path/to/dotfiles
# source $DOTFILES/bashrc
# ```
eval "$(oh-my-posh.exe init bash --config "$DOTFILES/ohmyposh.json")"

## Alias {{{

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

alias ll="ls -l"

alias gti=git
alias add="git add"
alias gs="git status"
alias amend="git commit --amend"
alias amendwq="git commit --amend --no-edit"

## }}}

# vim: fdm=marker
