<#
.SYNOPSIS
Loads PowerShell profile script when a shell in VSCode is opened.

.DESCRIPTION
Loads PowerShell profile script when a shell in VSCode is opened.

.LINK
GitHub - https://github.com/RustyTake-Off/dotfiles
#>

$profilePath = Join-Path -Path $env:USERPROFILE -ChildPath '\Documents\PowerShell\Microsoft.PowerShell_profile.ps1'

if (Test-Path $profilePath -PathType Leaf) {
    Invoke-Expression $profilePath
} else {
    Write-Host "PowerShell profile path '$profilePath' does not exist. Please ensure the path is correct and the file exists."
}
