# ╒══════╗        ╒═══════╗
# │ ╓──┐ ║════════╗  ╓─┐  ║
# │ ╚══╛ ║──┐  ╓──╜  ║ │  ║  RustyTake-Off
# │ ╓─┐ ╓╜  │  ║  │  ║ │  ║  https://github.com/RustyTake-Off
# │ ║ │ ╚╗  │  ║  │  ╚═╛  ║
# └─╜ └──╜  └──╜  └───────╜
# Script for setting up Windows dotfiles.

#Requires -RunAsAdministrator

<#
.SYNOPSIS
Script for setting up Windows dotfiles.

.DESCRIPTION
This script makes it easier to set up dotfiles on a Windows system. It creates symbolic links and copies necessary configuration files to configure PowerShell profiles, scripts, Windows Terminal, Winget, and WSL config.

.NOTES
You might want to not change the Execution Policy permanently so to change it only for the current process
run the bellow command and then run the script.
PS> Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process

To change Execution Policy permanently run bellow command which only allows trusted publishers.
PS> Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

This script also needs to be run from elevated terminal as admin.

.LINK
Repository      -   "https://github.com/RustyTake-Off/win-dotfiles",
Script file     -   "https://github.com/RustyTake-Off/win-dotfiles/blob/main/.config/scripts/Set-Dotfiles.ps1"
#>

[CmdletBinding(SupportsShouldProcess)]

# ================================================================================
# Main variables

$ConfigPowerShellProfilePath = "$env:USERPROFILE\.config\powershell_profile"
$ConfigScriptsPath = "$env:USERPROFILE\.config\scripts"
$ConfigWindowsTerminalPath = "$env:USERPROFILE\.config\windows_terminal"
$ConfigWingetPath = "$env:USERPROFILE\.config\winget"
$ConfigWSLPath = "$env:USERPROFILE\.config\wsl"

# ================================================================================
# Miscellaneous code

if (-not (Test-Path -Path "$env:USERPROFILE\pr" -PathType Container)) {
    Write-Output "Creating 'personal' folder"
    $null = New-Item -Path "$env:USERPROFILE\pr" -ItemType Directory
}

if (-not (Test-Path -Path "$env:USERPROFILE\wk" -PathType Container)) {
    Write-Output "Creating 'work' folder"
    $null = New-Item -Path "$env:USERPROFILE\wk" -ItemType Directory
}

# ================================================================================
# Helper functions

function New-CopyFile {
    param(
        [String] $SourceFile,
        [String] $TargetFile
    )

    try {
        Write-Host 'Copying file: ' -ForegroundColor Blue -NoNewline; Write-Output "$($(Split-Path -Path $SourceFile) -replace [Regex]::Escape($env:USERPROFILE), '...')\$((Get-Item $SourceFile).Name) -> $($(Split-Path -Path $TargetFile) -replace [Regex]::Escape($env:USERPROFILE), '...')\$((Get-Item $TargetFile).Name)"
        Copy-Item -Path $SourceFile -Destination $TargetFile
    } catch {
        Write-Error "Error copying new file: $_"
        Write-Error "Line: $($_.ScriptStackTrace)"
    }
}

function New-HashThenCopyFile {
    param(
        [String] $SourceFile,
        [String] $TargetFile
    )

    try {
        $HashOne = Get-FileHash -Path $SourceFile -Algorithm SHA256
        $HashTwo = Get-FileHash -Path $TargetFile -Algorithm SHA256
    } catch {
        Write-Error "Error calculating hashes: $_"
        Write-Error "Line: $($_.ScriptStackTrace)"
    }

    try {
        if ($HashOne.Hash -ne $HashTwo.Hash) {
            # Write-Output "Removing $($(Split-Path -Path $TargetFile) -replace [Regex]::Escape($env:USERPROFILE), '...')\$((Get-Item $TargetFile).Name)"
            # Remove-Item -Path $TargetFile -Force
            New-CopyFile -SourceFile $SourceFile -TargetFile $TargetFile
        } else {
            Write-Host 'File already set: ' -ForegroundColor Blue -NoNewline; Write-Output "$($(Split-Path -Path $SourceFile) -replace [Regex]::Escape($env:USERPROFILE), '...')\$((Get-Item $SourceFile).Name) -> $($(Split-Path -Path $TargetFile) -replace [Regex]::Escape($env:USERPROFILE), '...')\$((Get-Item $TargetFile).Name)"
        }
    } catch {
        Write-Error "Error copying new file: $_"
        Write-Error "Line: $($_.ScriptStackTrace)"
    }
}

function Invoke-CopyFile {
    param(
        [String] $SourceFile,
        [String] $TargetFile
    )

    try {
        if ((Test-Path -Path $SourceFile -PathType Leaf) -and (-not (Test-Path -Path $TargetFile -PathType Leaf))) {
            New-CopyFile -SourceFile $SourceFile -TargetFile $TargetFile
        } elseif ((Test-Path -Path $SourceFile -PathType Leaf) -and (Test-Path -Path $TargetFile -PathType Leaf)) {
            New-HashThenCopyFile -SourceFile $SourceFile -TargetFile $TargetFile
        } elseif ((-not (Test-Path -Path $SourceFile -PathType Leaf)) -and (Test-Path -Path $TargetFile -PathType Leaf)) {
            Write-Error "Cannot copy file, SourceFile doesn't exist in dotfiles"
        }
    } catch {
        Write-Error "Error copying new file: $_"
        Write-Error "Line: $($_.ScriptStackTrace)"
    }
}

# ================================================================================
# Main code

# Set dotfiles
try {
    if (-not (Test-Path -Path "$env:USERPROFILE\.dotfiles" -PathType Container)) {
        if (Get-Command git) {
            git clone --bare 'https://github.com/RustyTake-Off/win-dotfiles.git' "$env:USERPROFILE\.dotfiles"
            git --git-dir="$env:USERPROFILE\.dotfiles" --work-tree=$env:USERPROFILE checkout
            git --git-dir="$env:USERPROFILE\.dotfiles" --work-tree=$env:USERPROFILE config status.showUntrackedFiles no
        } else {
            Write-Error 'Git is not installed'
            Exit
        }
    } else {
        Write-Output 'Dotfiles are set. Checking for updates'
        git --git-dir="$env:USERPROFILE\.dotfiles" --work-tree=$env:USERPROFILE reset --hard
        git --git-dir="$env:USERPROFILE\.dotfiles" --work-tree=$env:USERPROFILE pull
    }
} catch {
    Write-Error "Error setting up dotfiles: $_"
    Write-Error "Line: $($_.ScriptStackTrace)"
    Exit
}

# Set PowerShell profiles
$PowerShellProfilePath = "$env:USERPROFILE\Documents\PowerShell"
if ($ConfigPowerShellProfileFiles = Get-ChildItem -Path $ConfigPowerShellProfilePath -File -Recurse) {
    if (-not (Test-Path -Path $PowerShellProfilePath -PathType Container)) {
        New-Item -Path $PowerShellProfilePath -ItemType Directory

        foreach ($File in $ConfigPowerShellProfileFiles) {
            Invoke-CopyFile -SourceFile "$ConfigPowerShellProfilePath\$($File.Name)" -TargetFile "$PowerShellProfilePath\$($File.Name)"
        }
    } else {
        foreach ($File in $ConfigPowerShellProfileFiles) {
            Invoke-CopyFile -SourceFile "$ConfigPowerShellProfilePath\$($File.Name)" -TargetFile "$PowerShellProfilePath\$($File.Name)"
        }
    }
} else {
    Write-Output 'PowerShell profile config is missing from dotfiles'
}

# Set PowerShell scripts
$PowerShellScriptsPath = "$env:USERPROFILE\Documents\PowerShell\Scripts"
if ($ConfigScriptFiles = Get-ChildItem -Path $ConfigScriptsPath -File -Recurse) {
    if (-not (Test-Path -Path $PowerShellScriptsPath -PathType Container)) {
        New-Item -Path $PowerShellScriptsPath -ItemType Directory

        foreach ($File in $ConfigScriptFiles) {
            Invoke-CopyFile -SourceFile "$ConfigScriptsPath\$($File.Name)" -TargetFile "$PowerShellScriptsPath\$($File.Name)"
        }
    } else {
        foreach ($File in $ConfigScriptFiles) {
            Invoke-CopyFile -SourceFile "$ConfigScriptsPath\$($File.Name)" -TargetFile "$PowerShellScriptsPath\$($File.Name)"
        }
    }
} else {
    Write-Output 'PowerShell scripts are missing from dotfiles'
}

# Set Windows Terminal config
$WindowsTerminalPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
if ($ConfigWindowsTerminalFiles = Get-ChildItem -Path $ConfigWindowsTerminalPath -File -Recurse) {
    if ((Get-Command -Name wt.exe) -and (-not (Test-Path -Path $WindowsTerminalPath -PathType Container))) {
        New-Item -Path $WindowsTerminalPath -ItemType Directory

        foreach ($File in $ConfigWindowsTerminalFiles) {
            $SourceToCopy = "$ConfigWindowsTerminalPath\$($File.Name)"
            $TargetToCopy = "$WindowsTerminalPath\settings.json"

            Invoke-CopyFile -SourceFile $SourceToCopy -TargetFile $TargetToCopy
        }
    } elseif ((Get-Command -Name wt.exe) -and (Test-Path -Path $WindowsTerminalPath -PathType Container)) {
        foreach ($File in $ConfigWindowsTerminalFiles) {
            $SourceToCopy = "$ConfigWindowsTerminalPath\$($File.Name)"
            $TargetToCopy = "$WindowsTerminalPath\settings.json"

            Invoke-CopyFile -SourceFile $SourceToCopy -TargetFile $TargetToCopy
        }
    }
} else {
    Write-Output 'Windows Terminal config is missing from dotfiles'
}

# Set Winget config
$WingetPath = "$env:LOCALAPPDATA\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState"
if ($ConfigWingetFiles = Get-ChildItem -Path $ConfigWingetPath -File -Recurse) {
    if (-not (Test-Path -Path $WingetPath -PathType Container)) {
        New-Item -Path $WingetPath -ItemType Directory

        foreach ($File in $ConfigWingetFiles) {
            Invoke-CopyFile -SourceFile "$ConfigWingetPath\$($File.Name)" -TargetFile "$WingetPath\settings.json"
            Invoke-CopyFile -SourceFile "$ConfigWingetPath\$($File.Name)" -TargetFile "$WingetPath\settings.json.backup"
        }
    } else {
        foreach ($File in $ConfigWingetFiles) {
            Invoke-CopyFile -SourceFile "$ConfigWingetPath\$($File.Name)" -TargetFile "$WingetPath\settings.json"
            Invoke-CopyFile -SourceFile "$ConfigWingetPath\$($File.Name)" -TargetFile "$WingetPath\settings.json.backup"
        }
    }
} else {
    Write-Output 'Winget config is missing from dotfiles'
}

# Set WSL config
if ($ConfigWSLFiles = Get-ChildItem -Path $ConfigWSLPath -File -Recurse) {
    if (-not (Test-Path -Path "$env:USERPROFILE\.wslconfig" -PathType Leaf)) {
        foreach ($File in $ConfigWSLFiles) {
            Invoke-CopyFile -SourceFile "$ConfigWSLPath\$($File.Name)" -TargetFile "$env:USERPROFILE\.wslconfig"
        }
    } else {
        foreach ($File in $ConfigWSLFiles) {
            Invoke-CopyFile -SourceFile "$ConfigWSLPath\$($File.Name)" -TargetFile "$env:USERPROFILE\.wslconfig"
        }
    }
} else {
    Write-Output 'WSL config is missing from dotfiles'
}
