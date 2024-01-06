# In $PROFILE:
# ```ps1
# $DOTFILES="/path/to/dotfiles"
# . "$DOTFILES/psprofile.ps1"
# ```
oh-my-posh init pwsh --config "$DOTFILES/ohmyposh.json" | Invoke-Expression
$env:POSH_GIT_ENABLED = $true

Invoke-Expression (& { (zoxide init powershell | Out-String) })

Import-Module PSReadLine
Import-Module Posh-Git
Import-Module PSFzf
Import-Module Terminal-Icons

Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }

$env:RIPGREP_CONFIG_PATH="$DOTFILES/ripgreprc"
$env:BAT_CONFIG_PATH="$DOTFILES/batrc"
$env:FZF_CTRL_T_COMMAND="fd -t f"

# Fix PS colors for Solarized Light
Set-PSReadLineOption -Colors @{
	Member = "Magenta"
	Number = "Magenta"
	Type = "DarkYellow"
	ContinuationPrompt = "Blue"
	Default = "Blue"
}

Get-ChildItem -Path "$DOTFILES/completions/ps1" -Filter *.ps1 | ForEach-Object {
    . $_.FullName
}

## Alias {{{

Function Move-Up { Set-Location .. }
Function Move-UpUp { Set-Location ..\.. }
Function Move-UpUpUp { Set-Location ..\..\.. }

Set-Alias -Name '..' -Value Move-Up
Set-Alias -Name '...' -Value Move-UpUp
Set-Alias -Name '....' -Value Move-UpUpUp

Set-Alias -Name 'll' -Value Get-ChildItem

Set-Alias -Name 'gti' -Value git

Function Alias-Gs { git status }
Set-Alias -Name 'gs' -Value Alias-Gs
Function Alias-Add { git add }
Set-Alias -Name add -Value Alias-Add
Function Alias-Gd { git diff }
Set-Alias -Name gd -Value Alias-Gd
Function Alias-Gds { git diff --staged }
Set-Alias -Name gds -Value Alias-Gds
Function Alias-Gco { git commit }
Set-Alias -Name gco -Value Alias-Gco
Function Alias-Gca { git commit -a }
Set-Alias -Name gca -Value Alias-Gca
Function Alias-Amend { git commit --amend }
Set-Alias -Name amend -Value Alias-Amend
Function Alias-Amendwq { git commit --amend --no-edit }
Set-Alias -Name amendwq -Value Alias-Amendwq

## }}}

# vim: fdm=marker
