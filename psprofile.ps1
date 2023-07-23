# In $PROFILE:
# ```ps1
# $DOTFILES="/path/to/dotfiles"
# . "$DOTFILES/psprofile.ps1"
# ```
oh-my-posh init pwsh --config "$DOTFILES/ohmyposh.json" | Invoke-Expression

# Fix PS colors for Solarized Light
Set-PSReadLineOption -Colors @{
	Member = "Magenta"
	Number = "Magenta"
	Type = "DarkYellow"
	ContinuationPrompt = "Blue"
	Default = "Blue"
}
