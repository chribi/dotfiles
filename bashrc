#!/bin/bash

# In .bashrc:
# ```sh
# DOTFILES=/path/to/dotfiles
# source $DOTFILES/bashrc
# ```

# Instead of using
# $ eval "$(oh-my-posh.exe init bash --config "$DOTFILES/ohmyposh.json")"
# we cache the result and source it.
# This works fine when not fiddling around with the config.
if [ ! -f "$DOTFILES/ohmyposh.bash" ]; then
    oh-my-posh init bash --config "$DOTFILES/ohmyposh.json" > "$DOTFILES/ohmyposh.bash"
fi
source "$DOTFILES/ohmyposh.bash"

eval "$(zoxide init bash)"

export RIPGREP_CONFIG_PATH="$DOTFILES/ripgreprc"
export BAT_CONFIG_PATH="$DOTFILES/batrc"
export FZF_CTRL_T_COMMAND="fd -t f"

for completion in $DOTFILES/completions/bash/*.bash ; do
    source "$completion"
done

## Neovim stuff {{{

# ripgrep and edit
function rge() {
    mkdir -p "$DOTFILES/tmp"
    rg --vimgrep "$@" > "$DOTFILES/tmp/rgqf"
    nvim -q "$DOTFILES/tmp/rgqf" '+Trouble quickfix'
}

function nvdiff() {
    nvim "+DiffviewOpen $@"
}

alias nvgit="nvim +Git"

## }}}

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

# Better colors for ls under solarized colorscheme
# di = directory
# ex = executable
# ln = link
export LS_COLORS='di=0;34:ex=0;32:ln=0;33:*.zip=0;31:*.gz=0;31'

# vim: fdm=marker
