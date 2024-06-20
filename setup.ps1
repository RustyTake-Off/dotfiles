<#
.SYNOPSIS
Dotfiles setup script

.DESCRIPTION
The script begins by defining directories to be checked out from a specified dotfiles repository. It checks for
the presence of required tools (Git and Winget) and prompts the user for installation if not found. Upon
installation of these tools, it proceeds to clone the dotfiles repository and checks out the specified directories/
files into the user's profile directory.

The script utilizes ANSI escape sequences to display colored output for clarity and user interaction. It handles
user input to confirm installation choices and gracefully exits if prerequisites are not met. Additionally, error
handling is implemented to provide informative messages in case of failures during the setup process.

.LINK
GitHub      - https://github.com/RustyTake-Off
GitHub Repo - https://github.com/RustyTake-Off/dotfiles

.NOTES
Author  - RustyTake-Off
Version - 0.1.7
#>

[CmdletBinding(SupportsShouldProcess)]
$ErrorActionPreference = 'SilentlyContinue'

# Configuration variables
$repoUrl = 'https://github.com/RustyTake-Off/dotfiles.git'
$dotfilesPath = "$HOME/.dotfiles"
$winfilesPath = "$HOME/winfiles"
$dotfilesScriptPath = "$HOME/.dots/scripts/set-dotfiles.ps1"
$toCheckout = @{
    docs     = @('images')
    winfiles = @('.config', '.dots', '.gitconfig')
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

function CheckAndAskToInstall {
    param (
        [string]$packageName
    )

    if (Get-Command -Name $packageName -ErrorAction SilentlyContinue) {
        return $false
    }

    Write-ColoredMessage "$packageName is not installed" 'red'

    while ($true) {
        $choice = Read-Host "Do you want to install $($colors.yellow)$packageName$($colors.reset) (y/N)?"
        $choice = $choice.Trim().ToLower() -replace ' ', ''

        switch ($choice) {
            'y' { return $true }
            'n' { Write-ColoredMessage 'Stopping script. Bye, bye' 'red'; break 1 }
            default { Write-ColoredMessage "Invalid input, please enter 'y' or 'n'" 'red' }
        }
    }
}

# Main logic
try {
    # Check and install winget
    if (CheckAndAskToInstall 'winget') {
        Write-ColoredMessage 'Installing Winget and its dependencies...' 'yellow'
        Invoke-RestMethod -Uri 'https://github.com/asheroto/winget-install/releases/latest/download/winget-install.ps1' | Invoke-Expression
        Write-ColoredMessage 'Installed Winget and its dependencies' 'green'
    } else {
        Write-ColoredMessage 'Winget is installed' 'green'
    }

    # Check and install git
    if (CheckAndAskToInstall 'git') {
        Write-ColoredMessage 'Installing Git...' 'yellow'
        Start-Process winget -ArgumentList 'install --exact --id Git.Git --source winget --interactive --accept-package-agreements --accept-source-agreements' -NoNewWindow -Wait
        Write-ColoredMessage 'Installed Git' 'green'
    } else {
        Write-ColoredMessage 'Git is installed' 'green'
    }

    # Clone dotfiles
    if (-not (Test-Path -Path $dotfilesPath -PathType Container)) {
        $paths = $toCheckout.GetEnumerator() | ForEach-Object {
            $key = $_.Key
            $_.Value | ForEach-Object { "$key/$_" }
        }

        Write-ColoredMessage 'Cloning dotfiles...' 'yellow'

        git clone --bare $repoUrl $dotfilesPath
        git --git-dir=$dotfilesPath --work-tree=$HOME checkout HEAD $paths
        git --git-dir=$dotfilesPath --work-tree=$HOME config status.showUntrackedFiles no
    } else {
        Write-ColoredMessage "Directory '.dotfiles' already exists in '$HOME'" 'red'
        break 1
    }

    # Move winfiles
    if (Test-Path -Path $winfilesPath -PathType Container) {
        Write-ColoredMessage "Moving 'winfiles' contents" 'yellow'
        foreach ($item in $toCheckout['winfiles']) {
            $sourcePath = "$winfilesPath\$item"
            Write-ColoredMessage "Moving '$sourcePath'" 'purple'
            if (Test-Path -Path $sourcePath -PathType Container) {
                Move-Item -Path $sourcePath -Destination $HOME -Force
            } elseif (Test-Path -Path $sourcePath -PathType Leaf) {
                Move-Item -Path $sourcePath -Destination $HOME -Force
            }
        }
        Write-ColoredMessage "Removing '$winfilesPath'" 'yellow'
        Remove-Item -Path $winfilesPath -Recurse
    } else {
        Write-ColoredMessage "Directory 'winfiles' not found in '$HOME'" 'red'
        break 1
    }

    # Run dotfiles script
    if (Test-Path -Path $dotfilesScriptPath -PathType Leaf) {
        Write-ColoredMessage 'Finishing dotfiles setup...' 'yellow'
        & $dotfilesScriptPath -skipClone
    } else {
        Write-ColoredMessage "Script file in path '$dotfilesScriptPath' does not exist" 'red'
        break 1
    }

    $ErrorActionPreference = 'Continue'
    exit 0
} catch {
    Write-ColoredMessage "Error in line $($_.InvocationInfo.ScriptLineNumber): $($_.Exception.Message)" 'red'
    exit 1
}
