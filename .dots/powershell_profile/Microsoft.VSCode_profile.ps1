<#
.SYNOPSIS
PowerShell profile script for VSCode

.DESCRIPTION
Loads PowerShell profile script when a shell in VSCode is opened.

.LINK
GitHub      - https://github.com/RustyTake-Off
GitHub Repo - https://github.com/RustyTake-Off/dotfiles

.NOTES
Author  - RustyTake-Off
Version - 0.1.3
#>

# Configuration variables
$profilePath = "$HOME/Documents/PowerShell/Microsoft.PowerShell_profile.ps1"

if (Test-Path $profilePath -PathType Leaf) {
    Invoke-Expression $profilePath
}
