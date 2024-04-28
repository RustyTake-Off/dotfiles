<#
.SYNOPSIS
Loads various functions.

.DESCRIPTION
Loads useful functions for doing various things.

.LINK
GitHub - https://github.com/RustyTake-Off/dotfiles
#>

# Quick movement around directories
function cd...... { Set-Location ..\..\..\..\..\.. }
function cd..... { Set-Location ..\..\..\..\.. }
function cd.... { Set-Location ..\..\..\.. }
function cd... { Set-Location ..\..\.. }
function cd.. { Set-Location ..\.. }
function cd. { Set-Location .. }
function hm { Set-Location $env:USERPROFILE }
function hpr { Set-Location "$env:USERPROFILE/pr" }
function hwk { Set-Location "$env:USERPROFILE/wk" }
function dl { Set-Location "$env:USERPROFILE/Downloads" }
function doc { Set-Location "$env:USERPROFILE/Documents" }
function dtop { Set-Location "$env:USERPROFILE/Desktop" }

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
    git --git-dir="$env:USERPROFILE\.dots" --work-tree=$env:USERPROFILE $Args
}

function setdots {
    Invoke-Expression (Join-Path -Path $env:USERPROFILE -ChildPath '\.dots\scripts\set-dotfiles.ps1')
}

# Use WinUp script
function winup {
    Invoke-Expression (Join-Path -Path $env:USERPROFILE -ChildPath "\.dots\scripts\winup.ps1 $Args")
}

# Quick admin switch
function admin {
    if (-not $Args) {
        Start-Process wt -Verb RunAs -ArgumentList "pwsh -NoExit -NoLogo -ExecutionPolicy Bypass -WorkingDirectory $(Get-Location)"
    } else {
        Start-Process wt -Verb RunAs -ArgumentList "pwsh -NoExit -NoLogo -ExecutionPolicy Bypass -WorkingDirectory $(Get-Location) -Command $Args"
    }
    # This is a backup command if for some reason the whole thing brakes
    # wt --profile "PowerShell (Admin)" --suppressApplicationTitle --startingDirectory "$(Get-Location)"
}

# Manage powershell profile
function Edit-Profile {
    notepad (Join-Path -Path $env:USERPROFILE -ChildPath '\Documents\PowerShell\Microsoft.PowerShell_profile.ps1')
}

function Reset-Profile {
    Invoke-Expression (Join-Path -Path $env:USERPROFILE -ChildPath '\Documents\PowerShell\Microsoft.PowerShell_profile.ps1')
}

function Reset-VSCProfile {
    Invoke-Expression (Join-Path -Path $env:USERPROFILE -ChildPath '\Documents\PowerShell\Microsoft.VSCode_profile.ps1')
}
