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
Version - 0.1.3
#>

# Configuration variables
$profileScripts = @('functions', 'completions')
$profilePath = "$HOME/.dots/scripts"

foreach ($script in $profileScripts) {
    if (Test-Path -Path "$profilePath/$script" -PathType Leaf) {
        Invoke-Expression "$profilePath/$script"
    }
}

Get-Command -Name starship && Invoke-Expression (&starship init powershell)
Get-Command -Name zoxide && Invoke-Expression (& { (zoxide init powershell | Out-String) })
