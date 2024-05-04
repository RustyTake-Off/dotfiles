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
Version - 0.1.0
#>

try {
    $profilePath = "$HOME/Documents/PowerShell/Microsoft.PowerShell_profile.ps1"

    if (Test-Path $profilePath -PathType Leaf) {
        Invoke-Expression $profilePath
    } else {
        throw "PowerShell profile in '$profilePath' does not exist. Please ensure the path is correct and the file exists."
    }

    exit 0 # success
} catch {
    "Error in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
    exit 1
}
