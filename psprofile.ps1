# In $PROFILE:
# ```ps1
# $DOTFILES="/path/to/dotfiles"
# . "$DOTFILES/psprofile.ps1"
# ```
oh-my-posh init pwsh --config "$DOTFILES/ohmyposh.json" | Invoke-Expression
