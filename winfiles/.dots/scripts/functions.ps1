<#
.SYNOPSIS
Various functions/aliases

.DESCRIPTION
Loads useful functions/aliases for doing various things.

.LINK
GitHub      - https://github.com/RustyTake-Off
GitHub Repo - https://github.com/RustyTake-Off/dotfiles

.NOTES
Author - RustyTake-Off
#>

try {
    # Quick movement around directories
    function cd...... { Set-Location ../../../../../.. }
    function cd..... { Set-Location ../../../../.. }
    function cd.... { Set-Location ../../../.. }
    function cd... { Set-Location ../../.. }
    function cd.. { Set-Location ../.. }
    function cd. { Set-Location .. }
    function hm { Set-Location $HOME }
    function hpr { Set-Location "$HOME/pr" }
    function hwk { Set-Location "$HOME/wk" }
    function dl { Set-Location "$HOME/Downloads" }
    function doc { Set-Location "$HOME/Documents" }
    function desk { Set-Location "$HOME/Desktop" }

    function h { Get-History }
    function cls { Clear-Host }

    function ls { Get-ChildItem }
    function la { Get-ChildItem }
    function ll { Get-ChildItem }

    # *nix like
    function touch ([string] $fileName) {
        Write-Output '' | Out-File -FilePath $fileName -Encoding ASCII
    }

    function which {
        Get-Command -Name $Args | Select-Object -ExpandProperty Path
    }

    # Check file hashes
    function md5 { Get-FileHash -Algorithm MD5 $Args }
    function sha1 { Get-FileHash -Algorithm SHA1 $Args }
    function sha256 { Get-FileHash -Algorithm SHA256 $Args }

    # Get public IP
    function pubip4 { (Invoke-WebRequest -Uri 'https://api.ipify.org/').Content }
    function pubip6 { (Invoke-WebRequest -Uri 'https://ifconfig.me/ip').Content }

    # Open windows explorer
    function open { explorer.exe $Args }

    # Manage dotfiles in $HOME directory
    function dot {
        git --git-dir="$HOME/.dots" --work-tree=$HOME $Args
    }

    function setdots {
        Invoke-Expression ("$HOME/.dots/scripts/set-dots.ps1")
    }

    # Use WinUp script
    function winup {
        Invoke-Expression ("$HOME/.dots/scripts/winup.ps1 $Args")
    }

    # Quick admin switch
    function admin {
        if ($Args) {
            Start-Process wt -Verb RunAs -ArgumentList "pwsh -NoExit -NoLogo -ExecutionPolicy Bypass -WorkingDirectory $(Get-Location) -Command $Args"
        } else {
            Start-Process wt -Verb RunAs -ArgumentList "pwsh -NoExit -NoLogo -ExecutionPolicy Bypass -WorkingDirectory $(Get-Location)"
        }

        # This is a backup command if for some reason the whole thing breaks
        # wt --profile "PowerShell (Admin)" --suppressApplicationTitle --startingDirectory "$(Get-Location)"
    }

    # Manage powershell profile
    function edit-profile {
        notepad ("$HOME/Documents/PowerShell/Microsoft.PowerShell_profile.ps1")
    }

    function reset-profile {
        Invoke-Expression ("$HOME/Documents/PowerShell/Microsoft.PowerShell_profile.ps1")
    }

    function reset-vscprofile {
        Invoke-Expression ("$HOME/Documents/PowerShell/Microsoft.VSCode_profile.ps1")
    }

    exit 0 # success
} catch {
    "Error in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
    exit 1
}
