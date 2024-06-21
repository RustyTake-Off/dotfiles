<#
.SYNOPSIS
PowerShell profile script

.DESCRIPTION
Loads PowerShell profile script when a shell is opened.

.LINK
GitHub      - https://github.com/RustyTake-Off
GitHub Repo - https://github.com/RustyTake-Off/dotfiles

.NOTES
Author  - RustyTake-Off
Version - 0.1.4
#>

# Configuration variables
$scripts = @('functions', 'completions')
$scriptsPath = "$HOME/.dots/scripts"

foreach ($script in $scripts) {
    if (Test-Path -Path "$scriptsPath/$script" -PathType Leaf) {
        Invoke-Expression "$scriptsPath/$script"
    }
}

Get-Command -Name starship | Out-Null && Invoke-Expression (&starship init powershell)
Get-Command -Name zoxide | Out-Null && Invoke-Expression (& { (zoxide init powershell | Out-String) })
