#!/bin/bash

# In .bashrc:
# ```sh
# DOTFILES=/path/to/dotfiles
# source $DOTFILES/bashrc
# ```
eval "$(oh-my-posh.exe init bash --config "$DOTFILES/ohmyposh.json")"
