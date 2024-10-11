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
#>

if (Test-Path $PROFILE -PathType Leaf) {
    . $PROFILE
}
