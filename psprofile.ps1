# In $PROFILE:
# ```ps1
# $DOTFILES="/path/to/dotfiles"
# . "$DOTFILES/psprofile.ps1"
# ```
oh-my-posh init pwsh --config "$DOTFILES/ohmyposh.json" | Invoke-Expression

$env:RIPGREP_CONFIG_PATH="$DOTFILES/ripgreprc"

# Fix PS colors for Solarized Light
Set-PSReadLineOption -Colors @{
	Member = "Magenta"
	Number = "Magenta"
	Type = "DarkYellow"
	ContinuationPrompt = "Blue"
	Default = "Blue"
}

## Alias {{{

Function Move-Up { Set-Location .. }
Function Move-UpUp { Set-Location ..\.. }
Function Move-UpUpUp { Set-Location ..\..\.. }

Set-Alias -Name '..' -Value Move-Up
Set-Alias -Name '...' -Value Move-UpUp
Set-Alias -Name '....' -Value Move-UpUpUp

Set-Alias -Name 'll' -Value Get-ChildItem

Function Get-GitStatus { git status }
Set-Alias -Name 'gti' -Value git
Set-Alias -Name 'gs' -Value Get-GitStatus


## }}}

# vim: fdm=marker
