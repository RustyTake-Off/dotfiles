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
Version - 0.1.11
#>

[CmdletBinding(SupportsShouldProcess)]
param()

begin {
    # Preferences
    $ErrorActionPreference = 'SilentlyContinue'
}

process {
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
        function desk { Set-Location "$HOME/Desktop" }
        function docs { Set-Location "$HOME/Documents" }

        function h { Get-History }
        function cls { Clear-Host }

        function ls { Get-ChildItem }
        function la { Get-ChildItem }
        function ll { Get-ChildItem }

        function df {
            Get-Volume
        }

        # Create new env variable
        function export ([string]$Name, [string]$Value) {
            Set-Item -Path "env:$Name" -Value $Value -Force
        }

        function pkill ([string]$Name) {
            Get-Process -Name $Name -ErrorAction SilentlyContinue | Stop-Process
        }

        function pgrep ([string]$Name) {
            Get-Process | Where-Object { $_.ProcessName -like "*$Name*" }
        }

        function head ([string]$Path, [int]$N = 10) {
            Get-Content -Path $Path -Head $N
        }

        function tail ([string]$Path, [int]$N = 10) {
            Get-Content -Path $Path -Tail $N
        }

        function touch ([string]$File) {
            Write-Output '' | Out-File -FilePath $File -Encoding ASCII
        }

        # Find files
        function ff ([string]$Name) {
            Get-ChildItem -Recurse -Filter "*$Name*" -ErrorAction SilentlyContinue | ForEach-Object {
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
        function open ([string]$Path) {
            explorer.exe $Path
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
        function editpsp {
            notepad $PROFILE
        }

        function repsp {
            Invoke-Expression $PROFILE
        }

        function revcp {
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
    } catch {
        Write-Error "Error in line $($_.InvocationInfo.ScriptLineNumber): $($_.Exception.Message)"
        exit 1
    }
}
