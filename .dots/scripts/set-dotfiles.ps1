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
Version - 0.1.6
#>

[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter(HelpMessage = 'Skips cloning dotfiles and just sets them in their locations.')]
    [switch]$skipClone
)

$ErrorActionPreference = 'SilentlyContinue'

# Configuration variables
$repoUrl = 'https://github.com/RustyTake-Off/dotfiles.git'
$dotfilesPath = "$HOME/.dotfiles"
$branchName = 'winfiles'
$dotsFilesPath = "$HOME/.dots"
$dotPaths = @{
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
    $source = Test-Path -Path $sourceFile -PathType Any
    $target = Test-Path -Path $targetFile -PathType Any

    if ($source -and -not $target) {
        New-CopyFile -sourceFile $sourceFile -targetFile $targetFile
    } elseif ($source -and $target) {
        New-HashThenCopyFile -sourceFile $sourceFile -targetFile $targetFile
    } elseif (-not $source -and $target) {
        Write-ColoredMessage "File '$sourceFile' does not exist" 'red'
    }
}

# Main logic
try {
    # Clone dotfiles
    if (-not $skipClone) {
        if (-not (Get-Command -Name git)) {
            Write-ColoredMessage 'Git is not installed' 'red'
            break 1
        }

        if (-not (Test-Path -Path $dotfilesPath -PathType Container)) {
            Write-ColoredMessage 'Cloning dotfiles...' 'yellow'

            git clone --bare $repoUrl $dotfilesPath
            git --git-dir=$dotfilesPath --work-tree=$HOME checkout $branchName
            git --git-dir=$dotfilesPath --work-tree=$HOME config status.showUntrackedFiles no
        } else {
            Write-ColoredMessage 'Dotfiles are set' 'yellow'
            Write-ColoredMessage 'Checking for updates...' 'purple'

            git --git-dir=$dotfilesPath --work-tree=$HOME reset --hard
            git --git-dir=$dotfilesPath --work-tree=$HOME pull origin $branchName
        }
    } else {
        Write-ColoredMessage 'Skipping cloning dotfiles' 'yellow'
    }

    # Set configurations
    if (-not (Test-Path -Path $dotsFilesPath -PathType Container)) {
        Write-ColoredMessage "Directory '.dots' not found in '$HOME'" 'red'
        break 1
    }

    Write-ColoredMessage 'Setting config files...' 'yellow'
    foreach ($key in $dotPaths.Keys) {
        if ($key -like 'dot*') {
            $sourcePath = $dotPaths[$key]
            $targetKey = $key -replace '^dot', ''

            if ($dotPaths.ContainsKey($targetKey)) {
                $targetPath = $dotPaths[$targetKey]

                if (-not (Test-Path -Path $targetPath -PathType Container)) {
                    $null = New-Item -Path $destPath -ItemType Directory -
                }

                $files = Get-ChildItem -Path $sourcePath -File -Recurse
                foreach ($file in $files) {
                    $sourceFile = Join-Path -Path $sourcePath -ChildPath $file.Name
                    $targetFile = Join-Path -Path $targetPath -ChildPath $file.Name
                    Invoke-HashAndCopyOrCopy -sourceFile $sourceFile -targetFile $targetFile
                }
            } else {
                Write-ColoredMessage "Target key '$targetKey' does not exist" 'red'
            }
        }
    }

    Write-ColoredMessage 'Dotfiles are set...' 'green'

    $ErrorActionPreference = 'Continue'
} catch {
    Write-ColoredMessage "Error in line $($_.InvocationInfo.ScriptLineNumber): $($_.Exception.Message)" 'red'
    exit 1
}
