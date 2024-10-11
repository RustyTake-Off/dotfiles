<#
.SYNOPSIS
Dotfiles setup script

.DESCRIPTION
This script automates the setup of dotfiles in a Windows environment. It checks for
required tools (Git and Winget), installs them if necessary, clones a specified
dotfiles repository, and sets up the dotfiles in the user's profile directory.

.LINK
GitHub      - https://github.com/RustyTake-Off
GitHub Repo - https://github.com/RustyTake-Off/dotfiles

.NOTES
Author  - RustyTake-Off
#>

[CmdletBinding(SupportsShouldProcess)]
param()

# Preferences
$errAction = $ErrorActionPreference
$ErrorActionPreference = 'SilentlyContinue'
$progressAction = $ProgressPreference
$ProgressPreference = 'SilentlyContinue'

# Configuration variables
$repoUrl = 'https://github.com/RustyTake-Off/dotfiles.git'
$dotfilesPath = "$HOME/.dotfiles"
$branchName = 'winfiles'
$dotfilesScriptPath = "$HOME/.dots/scripts/set-dotfiles.ps1"

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

function Install-Package {
    <#
    .SYNOPSIS
    Installs packages
    #>

    param (
        [Parameter(Mandatory)]
        [string]$PackageName
    )

    if (Get-Command -Name $PackageName) {
        return $false
    }

    Write-ColoredMessage "$PackageName is not installed" 'red'

    while ($true) {
        $choice = Read-Host -Prompt "Do you want to install $($colors.yellow)$PackageName$($colors.reset) (y/n)?"
        $choice = $choice.Trim().ToLower() -replace ' ', ''

        switch ($choice) {
            'y' { return $true }
            'yes' { return $true }
            'n' { Write-ColoredMessage 'Stopping script. Bye, bye' 'red'; break 1 }
            'no' { Write-ColoredMessage 'Stopping script. Bye, bye' 'red'; break 1 }
            default { Write-ColoredMessage "Invalid input, please enter 'y' or 'n'" 'red' }
        }
    }
}

# Main execution logic
try {
    # Check and install winget
    if (Install-Package -PackageName 'winget') {
        Write-ColoredMessage 'Installing Winget and its dependencies...' 'yellow'

        Invoke-RestMethod -Uri 'https://github.com/asheroto/winget-install/releases/latest/download/winget-install.ps1' | Invoke-Expression

        Write-ColoredMessage 'Installed Winget and its dependencies' 'green'
    } else {
        Write-ColoredMessage 'Winget is installed' 'green'
    }

    # Check and install git
    if (Install-Package -PackageName 'git') {
        Write-ColoredMessage 'Installing Git...' 'yellow'

        Start-Process winget -ArgumentList 'install --exact --id Git.Git --source winget --interactive --accept-package-agreements --accept-source-agreements' -NoNewWindow -Wait

        Write-ColoredMessage 'Installed Git' 'green'
    } else {
        Write-ColoredMessage 'Git is installed' 'green'
    }

    # Clone dotfiles
    if (-not (Test-Path -Path $dotfilesPath -PathType Container)) {
        Write-ColoredMessage 'Cloning dotfiles...' 'yellow'

        git clone --bare $repoUrl $dotfilesPath
        git --git-dir=$dotfilesPath --work-tree=$HOME checkout $branchName
        git --git-dir=$dotfilesPath --work-tree=$HOME config status.showUntrackedFiles no
    } else {
        throw "Directory '$dotfilesPath' already exists"
    }

    # Run dotfiles script
    if (Test-Path -Path $dotfilesScriptPath -PathType Leaf) {
        Write-ColoredMessage 'Finishing dotfiles setup...' 'yellow'

        & $dotfilesScriptPath -SkipClone
    } else {
        throw "Script file in path '$dotfilesScriptPath' does not exist"
    }
} catch {
    throw "Error in line $($_.InvocationInfo.ScriptLineNumber): $($_.Exception.Message)"
} finally {
    $ErrorActionPreference = $errAction
    $ProgressPreference = $progressAction
}
