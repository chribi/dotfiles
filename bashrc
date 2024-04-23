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
alias cdg='cd  $(git rev-parse --show-toplevel)'

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

__git_complete add _git_add
__git_complete gs _git_status
__git_complete gd _git_diff
__git_complete gds _git_diff
__git_complete gc _git_commit
__git_complete gca _git_commit
__git_complete amend _git_commit
__git_complete amendwq _git_commit

## }}}

## Git bindings from https://stackoverflow.com/a/37007733 {{{

is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

bind_git_status_files() {
  is_in_git_repo &&
    git -c color.status=always status --short |
    fzf --height 40% -m --ansi --nth 2..,.. | awk '{print $2}'
}

bind_git_branches() {
  is_in_git_repo &&
    git branch -a -vv --color=always | grep -v '/HEAD\s' |
    fzf --height 40% --ansi --multi --tac | sed 's/^..//' | awk '{print $1}' |
    sed 's#^remotes/[^/]*/##'
}

bind_git_hashes() {
  is_in_git_repo &&
    git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph |
    fzf --height 40% --ansi --no-sort --reverse --multi | grep -o '[a-f0-9]\{7,\}'
}

bind '"\er": redraw-current-line'
bind '"\C-g\C-f": "$(bind_git_status_files)\e\C-e\er"'
bind '"\C-g\C-b": "$(bind_git_branches)\e\C-e\er"'
bind '"\C-g\C-h": "$(bind_git_hashes)\e\C-e\er"'

## }}}

# Better colors for ls under solarized colorscheme
# di = directory
# ex = executable
# ln = link
export LS_COLORS='di=0;34:ex=0;32:ln=0;33:*.zip=0;31:*.gz=0;31'

# vim: fdm=marker
