<#
.SYNOPSIS
Dotfiles setup script

.DESCRIPTION
Loads dotfiles and sets them up on the system in their respective locations.

.LINK
GitHub      - https://github.com/RustyTake-Off
GitHub Repo - https://github.com/RustyTake-Off/dotfiles

.NOTES
Author  - RustyTake-Off
Version - 0.1.5
#>

[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter(HelpMessage = 'Skips getting dotfiles and just sets them in their locations.')]
    [switch]$skipDotfiles
)

# Configuration variables
$repoUrl      = 'https://github.com/RustyTake-Off/dotfiles.git'
$dotfilesPath = "$HOME/.dotfiles"
$winfilesPath = "$HOME/winfiles"
$toCheckout = @{
    docs     = @('images')
    winfiles = @('.dots', '.gitconfig')
}
$paths = @{
    dotProfilePath = "$HOME/.dots/powershell_profile"
    profilePath    = "$HOME/Documents/PowerShell"
    dotWTPath      = "$HOME/.dots/windows_terminal"
    wtPath         = "$env:LOCALAPPDATA/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState"
    dotWingetPath  = "$HOME/.dots/winget"
    wingetPath     = "$env:LOCALAPPDATA/Packages/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe/LocalState"
    dotWSLPath     = "$HOME/.dots/wsl"
    wslPath        = "$HOME"
}

# ANSI escape sequences for different colors
$colors = @{
    red    = [char]27 + '[31m'
    green  = [char]27 + '[32m'
    yellow = [char]27 + '[33m'
    blue   = [char]27 + '[34m'
    purple = [char]27 + '[35m'
    reset  = [char]27 + '[0m'
}

# Function definitions
function Write-ColoredMessage {
    param (
        [string]$message,
        [string]$color
    )
    Write-Host "$($colors[$color])$message$($colors.reset)"
}

function New-CopyFile {
    param (
        [string]$sourceFile,
        [string]$targetFile
    )

    Write-Host "Copying $($colors.yellow)$($(Split-Path -Path $sourceFile) -replace [Regex]::Escape($HOME), '...')/$((Get-Item $sourceFile).Name)$($colors.reset) -> $($colors.purple)$($(Split-Path -Path $targetFile) -replace [Regex]::Escape($HOME), '...')/$((Get-Item $targetFile).Name)$($colors.reset)"
    Copy-Item -Path $sourceFile -Destination $targetFile -Force
}

function New-HashThenCopyFile {
    param (
        [string]$sourceFile,
        [string]$targetFile
    )
    $hashOne = Get-FileHash -Path $sourceFile -Algorithm SHA256
    $hashTwo = Get-FileHash -Path $targetFile -Algorithm SHA256

    if ($hashOne.Hash -ne $hashTwo.Hash) {
        New-CopyFile -sourceFile $sourceFile -targetFile $targetFile
    } else {
        Write-Host "File already set $($colors.yellow)$($(Split-Path -Path $sourceFile) -replace [Regex]::Escape($HOME), '...')/$((Get-Item $sourceFile).Name)$($colors.reset) -> $($colors.purple)$($(Split-Path -Path $targetFile) -replace [Regex]::Escape($HOME), '...')/$((Get-Item $targetFile).Name)$($colors.reset)"
    }
}

function Invoke-HashAndCopyOrCopy {
    param (
        [string]$sourceFile,
        [string]$targetFile
    )
    $source = Test-Path -Path $sourceFile -PathType Leaf
    $target = Test-Path -Path $targetFile -PathType Leaf

    if ($source -and -not $target) {
        New-CopyFile -sourceFile $sourceFile -targetFile $targetFile
    } elseif ($source -and $target) {
        New-HashThenCopyFile -sourceFile $sourceFile -targetFile $targetFile
    } elseif (-not $source -and $target) {
        Write-ColoredMessage "File '$sourceFile' does not exist" 'red'
    }
}

function Set-Configuration {
    param (
        [string]$dotPath,
        [string]$destPath,
        [string]$targetFile = '',
        [string]$backupFile = ''
    )

    if ($targetFile) {
        $sourceFiles = Get-ChildItem -Path $dotPath -File -Recurse
        if ($sourceFiles.Count -eq 0) {
            Write-ColoredMessage "Configuration files are missing from $dotPath" 'red'
            return
        }

        if (-not (Test-Path -Path $destPath -PathType Container)) {
            $null = New-Item -Path $destPath -ItemType Directory
        }

        $targetFilePath = Join-Path -Path $destPath -ChildPath $targetFile
        $backupFilePath = if ($backupFile) { Join-Path -Path $destPath -ChildPath $backupFile } else { $null }

        foreach ($file in $sourceFiles) {
            $sourceFile = $file.FullName
            Invoke-HashAndCopyOrCopy -sourceFile $sourceFile -targetFile $targetFilePath
            if ($backupFilePath) {
                Invoke-HashAndCopyOrCopy -sourceFile $sourceFile -targetFile $backupFilePath
            }
        }
    }
}

# Main logic
try {
    # Clone dotfiles
    if (-not $skipDotfiles) {
        if (-not (Get-Command -Name git -ErrorAction SilentlyContinue)) {
            throw "Git is not installed"
        }

        function Move-Winfiles {
            param (
                [string]$winfilesPath,
                [hashtable]$toCheckout
            )

            if (-not (Test-Path -Path $winfilesPath -PathType Container)) {
                throw "Directory 'winfiles' not found in '$HOME'"
            }

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
        }

        if (-not (Test-Path -Path $dotfilesPath -PathType Container)) {
            $paths = $toCheckout.GetEnumerator() | ForEach-Object { $_.Value | ForEach-Object { "$($_.Key)/$_" } }

            Write-ColoredMessage "Cloning dotfiles..." 'yellow'

            git clone --bare $repoUrl $dotfilesPath
            git --git-dir=$dotfilesPath --work-tree=$HOME checkout $paths
            git --git-dir=$dotfilesPath --work-tree=$HOME config status.showUntrackedFiles no

            Move-Winfiles -winfilesPath $winfilesPath -toCheckout $toCheckout
        } else {
            Write-ColoredMessage "Dotfiles are set. Checking for updates..." 'yellow'

            git --git-dir=$dotfilesPath --work-tree=$HOME reset --hard
            git --git-dir=$dotfilesPath --work-tree=$HOME pull

            Move-Winfiles -winfilesPath $winfilesPath -toCheckout $toCheckout
        }
    } else {
        Write-ColoredMessage 'Skipping dotfiles' 'yellow'
    }

    # Set configurations
    foreach ($key in $paths.Keys) {
        if ($key -match 'dotProfilePath') {
            Set-Configuration -dotPath $paths.dotProfilePath -destPath $paths.profilePath
        } elseif ($key -match 'dotWTPath') {
            Set-Configuration -dotPath $paths.dotWTPath -destPath $paths.wtPath -targetFile 'settings.json'
        } elseif ($key -match 'dotWingetPath') {
            Set-Configuration -dotPath $paths.dotWingetPath -destPath $paths.wingetPath -targetFile 'settings.json' -backupFile 'settings.json.backup'
        } elseif ($key -match 'dotWSLPath') {
            Set-Configuration -dotPath $paths.dotWSLPath -destPath $paths.wslPath -targetFile '.wslconfig'
        }
    }

    $ErrorActionPreference = 'Continue'
    exit 0
} catch {
    Write-ColoredMessage "Error in line $($_.InvocationInfo.ScriptLineNumber): $($_.Exception.Message)" 'red'
    exit 1
}
