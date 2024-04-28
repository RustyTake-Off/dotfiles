<#
.SYNOPSIS
Loads PowerShell profile script when a shell is opened.

.DESCRIPTION
Loads PowerShell profile script when a shell is opened.

.LINK
GitHub - https://github.com/RustyTake-Off/dotfiles
#>

# Loads powershell profile scripts
$profileScripts = @('functions', 'completions')
$profilePath = "$env:USERPROFILE\.dots\scripts"

foreach ($script in $profileScripts) {
    if (Test-Path -Path "$profilePath\$script" -PathType Leaf) {
        Invoke-Expression "$profilePath\$script"
    }
}

# Initialize other tools
Get-Command -Name starship && Invoke-Expression (&starship init powershell)
Get-Command -Name zoxide && Invoke-Expression (& { (zoxide init powershell | Out-String) })
