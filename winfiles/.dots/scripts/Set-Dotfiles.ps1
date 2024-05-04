<#
.SYNOPSIS
Dotfiles setup script

.DESCRIPTION
Loads dotfiles and sets them up one the system in their respective locations.

.LINK
GitHub      - https://github.com/RustyTake-Off
GitHub Repo - https://github.com/RustyTake-Off/dotfiles

.NOTES
Author  - RustyTake-Off
Version - 0.1.0
#>

[CmdletBinding(SupportsShouldProcess)]

$repoUrl = 'https://github.com/RustyTake-Off/dotfiles.git'
$dotfilesPath = "$HOME/.dotfiles"
$winfilesPath = "$HOME/winfiles"
$toCheckout = @{
    docs     = @('images')
    winfiles = @('.dots', '.gitconfig')
}

$dotProfilePath = "$HOME/.dots/powershell_profile"
$profilePath = "$HOME/Documents/PowerShell"
$dotWTPath = "$HOME/.dots/windows_terminal"
$wtPath = "$env:LOCALAPPDATA/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState"
$dotWingetPath = "$HOME/.dots/winget"
$wingetPath = "$env:LOCALAPPDATA/Packages/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe/LocalState"
$dotWSLPath = "$HOME/.dots/wsl"
$wslPath = "$HOME"

# ANSI escape sequences for different colors
$red = [char]27 + '[31m'
$green = [char]27 + '[32m'
$yellow = [char]27 + '[33m'
$blue = [char]27 + '[34m'
$purple = [char]27 + '[35m'
$resetColor = [char]27 + '[0m'

function New-CopyFile ([string]$sourceFile, [string]$targetFile) {
    try {
        Write-Host "Copying $yellow$($(Split-Path -Path $sourceFile) -replace [Regex]::Escape($HOME), '...')/$((Get-Item $sourceFile).Name)$resetColor -> $purple$($(Split-Path -Path $targetFile) -replace [Regex]::Escape($HOME), '...')/$((Get-Item $targetFile).Name)$resetColor"
        Copy-Item -Path $sourceFile -Destination $targetFile
    } catch {
        "Error in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
    }
}

function New-HashThenCopyFile ([string]$sourceFile, [string]$targetFile) {
    try {
        $hashOne = Get-FileHash -Path $sourceFile -Algorithm SHA256
        $hashTwo = Get-FileHash -Path $targetFile -Algorithm SHA256

        if ($hashOne.Hash -ne $hashTwo.Hash) {
            New-CopyFile -sourceFile $sourceFile -targetFile $targetFile
        } else {
            Write-Host "File already set $yellow$($(Split-Path -Path $sourceFile) -replace [Regex]::Escape($HOME), '...')/$((Get-Item $sourceFile).Name)$resetColor -> $purple$($(Split-Path -Path $targetFile) -replace [Regex]::Escape($HOME), '...')/$((Get-Item $targetFile).Name)$resetColor"
        }
    } catch {
        "Error in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
    }
}

function Invoke-HashAndCopyOrCopy ([string]$sourceFile, [string]$targetFile) {
    try {
        if ((Test-Path -Path $sourceFile -PathType Leaf) -and (-not (Test-Path -Path $targetFile -PathType Leaf))) {
            New-CopyFile -sourceFile $sourceFile -targetFile $targetFile

        } elseif ((Test-Path -Path $sourceFile -PathType Leaf) -and (Test-Path -Path $targetFile -PathType Leaf)) {
            New-HashThenCopyFile -sourceFile $sourceFile -targetFile $targetFile

        } elseif ((-not (Test-Path -Path $sourceFile -PathType Leaf)) -and (Test-Path -Path $targetFile -PathType Leaf)) {
            Write-Host "$($red)File '$sourceFile' does not exist$($resetColor)"
        }
    } catch {
        "Error in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
    }
}

try {
    # set dotfiles
    if (Get-Command -Name git -ErrorAction SilentlyContinue) {
        $dotfilesPathExists = Test-Path -Path $dotfilesPath -PathType Container
        $paths = @()

        foreach ($key in $toCheckout.Keys) {
            foreach ($item in $toCheckout[$key]) {
                $paths += "$key/$item"
            }
        }

        if (-not $dotfilesPathExists) {
            Write-Host "$($yellow)Cloning dotfiles...$($resetColor)"
            git clone --bare $repoUrl $dotfilesPath
            git --git-dir=$dotfilesPath --work-tree=$HOME checkout $paths
            git --git-dir=$dotfilesPath --work-tree=$HOME config status.showUntrackedFiles no

            if (Test-Path -Path $winfilesPath -PathType Container) {
                foreach ($item in $toCheckout['winfiles']) {
                    $sourcePath = "$winfilesPath/$item"

                    if (Test-Path -Path $sourcePath -PathType Container) {
                        Get-ChildItem -Path $sourcePath | ForEach-Object {
                            Move-Item -Path $_.FullName -Destination $HOME -Force
                        }
                    } elseif (Test-Path -Path $sourcePath -PathType Leaf) {
                        Move-Item -Path $sourcePath -Destination $HOME -Force
                    }
                }
            } else {
                Write-Host "$($red)Directory 'winfiles' not found in '$HOME'$($resetColor)"
                exit 1
            }
        } else {
            Write-Host "$($yellow)Dotfiles are set. Checking for updates...$($resetColor)"
            git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" reset --hard
            git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" pull

            if (Test-Path -Path $winfilesPath -PathType Container) {
                foreach ($item in $toCheckout['winfiles']) {
                    $sourcePath = "$winfilesPath/$item"

                    if (Test-Path -Path $sourcePath -PathType Container) {
                        Get-ChildItem -Path $sourcePath | ForEach-Object {
                            Move-Item -Path $_.FullName -Destination $HOME -Force
                        }
                    } elseif (Test-Path -Path $sourcePath -PathType Leaf) {
                        Move-Item -Path $sourcePath -Destination $HOME -Force
                    }
                }
            } else {
                Write-Host "$($red)Directory 'winfiles' not found in '$HOME'$($resetColor)"
                exit 1
            }
        }
    } else {
        Write-Host "$($red)Git is not installed$($resetColor)"
        exit 1
    }

    # set powershell profile
    $profileFiles = Get-ChildItem -Path $dotProfilePath -File -Recurse
    if ($profileFiles) {
        $profilePathExists = Test-Path -Path $profilePath -PathType Container

        if (-not $profilePathExists) {
            $null = New-Item -Path $profilePath -ItemType Directory
        }

        foreach ($file in $profileFiles) {
            $sourceFile = Join-Path -Path $dotProfilePath -ChildPath $file.Name
            $targetFile = Join-Path -Path $profilePath -ChildPath $file.Name
            Invoke-HashAndCopyOrCopy -sourceFile $sourceFile -targetFile $targetFile
        }
    } else {
        Write-Host "$($red)PowerShell profile config is missing from dotfiles$($resetColor)"
    }

    # set windows terminal config
    if (Get-Command -Name wt -ErrorAction SilentlyContinue) {
        $wtFiles = Get-ChildItem -Path $dotWTPath -File -Recurse
        if ($wtFiles) {
            $wtPathExists = Test-Path -Path $wtPath -PathType Container

            if (-not $wtPathExists) {
                $null = New-Item -Path $wtPath -ItemType Directory
            }

            foreach ($file in $wtFiles) {
                $sourceFile = Join-Path -Path $dotWTPath -ChildPath $file.Name
                $targetFile = Join-Path -Path $wtPath -ChildPath 'settings.json'
                Invoke-HashAndCopyOrCopy -sourceFile $sourceFile -targetFile $targetFile
            }
        } else {
            Write-Host "$($red)Windows Terminal config is missing from dotfiles$($resetColor)"
        }
    } else {
        Write-Host "$($red)Windows Terminal is not installed$($resetColor)"
    }

    # set winget config
    if (Get-Command -Name winget -ErrorAction SilentlyContinue) {
        $wingetFiles = Get-ChildItem -Path $dotWingetPath -File -Recurse
        if ($wingetFiles) {
            $wingetPathExists = Test-Path -Path $wingetPath -PathType Container

            if (-not $wingetPathExists) {
                $null = New-Item -Path $wingetPath -ItemType Directory
            }

            foreach ($file in $wingetFiles) {
                $sourceFile = Join-Path -Path $dotWingetPath -ChildPath $file.Name
                $targetFile = Join-Path -Path $wingetPath -ChildPath 'settings.json'
                $backupFile = Join-Path -Path $wingetPath -ChildPath 'settings.json.backup'
                Invoke-HashAndCopyOrCopy -SourceFile $sourceFile -TargetFile $targetFile
                Invoke-HashAndCopyOrCopy -SourceFile $sourceFile -TargetFile $backupFile
            }
        } else {
            Write-Host "$($red)Winget config is missing from dotfiles$($resetColor)"
        }
    } else {
        Write-Host "$($red)Winget is not installed$($resetColor)"
    }

    # set wsl config
    $wslFiles = Get-ChildItem -Path $dotWSLPath -File -Recurse
    if ($wslFiles) {
        $wslPathExists = Test-Path -Path "$wslPath/.wslconfig" -PathType Leaf

        if (-not $wslPathExists) {
            foreach ($file in $wslFiles) {
                $sourceFile = Join-Path -Path $dotWSLPath -ChildPath $file.Name
                $targetFile = Join-Path -Path $wslPath -ChildPath '.wslconfig'
                Invoke-HashAndCopyOrCopy -sourceFile $sourceFile -targetFile $targetFile
            }
        }
    } else {
        Write-Host "$($red)WSL config is missing from dotfiles$($resetColor)"
    }

    exit 0 # success
} catch {
    "Error in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
    exit 1
}
