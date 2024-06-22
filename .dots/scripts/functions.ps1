<#
.SYNOPSIS
Various functions/aliases

.DESCRIPTION
Loads useful functions/aliases for doing various things.

.LINK
GitHub      - https://github.com/RustyTake-Off
GitHub Repo - https://github.com/RustyTake-Off/dotfiles

.NOTES
Author  - RustyTake-Off
Version - 0.1.9
#>

$ErrorActionPreference = 'SilentlyContinue'

try {
    # Common functions
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

    function df {
        Get-Volume
    }

    # Create new env variable
    function export ([string]$name, [string]$value) {
        Set-Item -Path "env:$name" -Value $value -Force
    }

    function pkill ([string]$name) {
        Get-Process -Name $name -ErrorAction SilentlyContinue | Stop-Process
    }

    function pgrep ([string]$name) {
        Get-Process | Where-Object { $_.ProcessName -like "*$name*" }
    }

    function head ([string]$path, [int]$n = 10) {
        Get-Content -Path $path -Head $n
    }

    function tail ([string]$path, [int]$n = 10) {
        Get-Content -Path $path -Tail $n
    }

    function touch ([string]$file) {
        Write-Output '' | Out-File -FilePath $file -Encoding ASCII
    }

    # Find files
    function ff ([string]$name) {
        Get-ChildItem -Recurse -Filter "*$name*" -ErrorAction SilentlyContinue | ForEach-Object {
            Write-Output $_.FullName
        }
    }

    # Find commands
    function which {
        Get-Command -Name $args | Select-Object -ExpandProperty Definition
    }

    function md5 { Get-FileHash -Algorithm MD5 $args }
    function sha1 { Get-FileHash -Algorithm SHA1 $args }
    function sha256 { Get-FileHash -Algorithm SHA256 $args }

    # Get public ips
    function pubip4 { (Invoke-WebRequest -Uri 'https://api.ipify.org/').Content }
    function pubip6 { (Invoke-WebRequest -Uri 'https://ifconfig.me/ip').Content }

    function sysinfo { Get-ComputerInfo }
    function flushdns { Clear-DnsClientCache }

    # Open windows explorer
    function open ([string]$path) {
        explorer.exe $path
    }

    # Quick admin
    function admin {
        if ($args) {
            Start-Process wt -Verb RunAs -ArgumentList "pwsh -NoExit -NoLogo -ExecutionPolicy Bypass -WorkingDirectory $(Get-Location) -Command $args"
        } else {
            Start-Process wt -Verb RunAs -ArgumentList "pwsh -NoExit -NoLogo -ExecutionPolicy Bypass -WorkingDirectory $(Get-Location)"
        }
    }

    # Manage powershell profile
    function editprofile {
        notepad $PROFILE
    }

    function reprofile {
        Invoke-Expression $PROFILE
    }

    function revscprofile {
        Invoke-Expression ($PROFILE -replace 'PowerShell_profile', 'VSCode_profile')
    }

    # Manage dotfiles in $HOME directory
    function dot {
        git --git-dir="$HOME/.dotfiles" --work-tree=$HOME $args
    }

    function setdots {
        Invoke-Expression "$HOME/.dots/scripts/set-dotfiles.ps1"
    }

    function winup {
        Invoke-Expression "$HOME/.dots/scripts/winup.ps1 $args"
    }

    $ErrorActionPreference = 'Continue'
} catch {
    Write-ColoredMessage "Error in line $($_.InvocationInfo.ScriptLineNumber): $($_.Exception.Message)" 'red'
    exit 1
}
