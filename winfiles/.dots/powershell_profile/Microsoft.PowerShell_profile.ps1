<#
.SYNOPSIS
PowerShell profile script

.DESCRIPTION
Loads PowerShell profile script when a shell is opened.

.LINK
GitHub      - https://github.com/RustyTake-Off
GitHub Repo - https://github.com/RustyTake-Off/dotfiles

.NOTES
Author - RustyTake-Off
#>

try {
    # load powershell profile scripts
    $profileScripts = @('functions', 'completions')
    $profilePath = "$HOME/.dots/scripts"

    foreach ($script in $profileScripts) {
        if (Test-Path -Path "$profilePath/$script" -PathType Leaf) {
            Invoke-Expression "$profilePath/$script"
        }
    }

    # initialize other tools
    Get-Command -Name starship && Invoke-Expression (&starship init powershell)
    Get-Command -Name zoxide && Invoke-Expression (& { (zoxide init powershell | Out-String) })

    exit 0 # success
} catch {
    "Error in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
    exit 1
}
