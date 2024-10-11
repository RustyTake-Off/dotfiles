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
#>

[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter(HelpMessage = 'Skips cloning dotfiles and just sets them in their locations.')]
    [switch]$SkipClone
)

# Preferences
$errAction = $ErrorActionPreference
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
    <#
    .SYNOPSIS
    Write message with color
    #>

    param (
        [Parameter(Mandatory = $true)]
        [string]$Message,
        [Parameter(Mandatory = $true)]
        [ValidateScript({
                if (-not $colors.ContainsKey($_)) {
                    throw "Invalid color '$($_)'. Available colors are: $($colors.Keys -join ', ')"
                }
                $true
            })]
        [string]$Color
    )

    Write-Host "$($colors[$Color])$Message$($colors.reset)"
}

function Invoke-DotfilesClone {
    <#
    .SYNOPSIS
    Clone or update dotfiles
    #>

    if (-not (Get-Command -Name git)) {
        throw 'Git is not installed.'
    }

    if (-not (Test-Path -Path $dotfilesPath)) {
        Write-ColoredMessage 'Cloning dotfiles...' 'yellow'

        git clone --bare $repoUrl $dotfilesPath
        git --git-dir=$dotfilesPath --work-tree=$HOME checkout $branchName
        git --git-dir=$dotfilesPath --work-tree=$HOME config status.showUntrackedFiles no
    } else {
        Write-ColoredMessage 'Checking for updates...' 'purple'

        git --git-dir=$dotfilesPath --work-tree=$HOME reset --hard
        $output = git --git-dir=$dotfilesPath --work-tree=$HOME pull origin $branchName

        if ($output -match 'Already up to date.') {
            Write-ColoredMessage 'Already up to date.' 'green'
            return $true
        }
    }
}

function Invoke-FileCopy {
    <#
    .SYNOPSIS
    Copy file with hash comparison
    #>

    param (
        [Parameter(Mandatory = $true)]
        [string]$SourceFile,
        [Parameter(Mandatory = $true)]
        [string]$TargetFile
    )

    if (-not (Test-Path -Path $TargetFile) -or (Get-FileHash -Path $SourceFile).Hash -ne (Get-FileHash -Path $TargetFile).Hash) {
        Write-Host "$($colors.yellow)Copying file:$($colors.reset) $($(Split-Path -Path $SourceFile) -replace [Regex]::Escape($HOME), '...')/$((Get-Item $SourceFile).Name) -> $($(Split-Path -Path $TargetFile) -replace [Regex]::Escape($HOME), '...')/$((Get-Item $TargetFile).Name)"
        Copy-Item -Path $SourceFile -Destination $TargetFile -Force
    } else {
        Write-Host "$($colors.green)File up-to-date:$($colors.reset) $($(Split-Path -Path $SourceFile) -replace [Regex]::Escape($HOME), '...')/$((Get-Item $SourceFile).Name) -> $($(Split-Path -Path $TargetFile) -replace [Regex]::Escape($HOME), '...')/$((Get-Item $TargetFile).Name)"
    }
}

function Set-ConfigurationFiles {
    <#
    .SYNOPSIS
    Set up configuration files from dotfiles
    #>

    foreach ($key in $dotPaths.Keys) {
        if ($key -like 'dot*') {
            $sourcePath = $dotPaths[$key]
            $targetKey = $key -replace '^dot', ''
            $targetPath = $dotPaths[$targetKey]

            if (-not (Test-Path -Path $targetPath -PathType Container)) {
                $null = New-Item -Path $targetPath -ItemType Directory -Force
            }

            Get-ChildItem -Path $sourcePath -File | ForEach-Object {
                $sourceFile = $_.FullName
                $targetFile = Join-Path -Path $targetPath -ChildPath $_.Name
                Invoke-FileCopy -SourceFile $sourceFile -TargetFile $targetFile
            }
        }
    }
}

# Main execution logic
try {
    if (-not $SkipClone) {
        if (Invoke-DotfilesClone) {
            return
        }
    } else {
        Write-ColoredMessage 'Skipping dotfiles cloning' 'yellow'
    }

    if (-not (Test-Path -Path $dotsFilesPath -PathType Container)) {
        throw "Directory '.dots' not found in '$HOME'"
    }

    Write-ColoredMessage 'Setting up configuration files...' 'yellow'
    Set-ConfigurationFiles
    Write-ColoredMessage 'Dotfiles setup complete' 'green'
} catch {
    throw "Error in line $($_.InvocationInfo.ScriptLineNumber): $($_.Exception.Message)"
} finally {
    $ErrorActionPreference = $errAction
}
