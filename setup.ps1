<#
.SYNOPSIS
Dotfiles setup script

.DESCRIPTION
This script automates the setup of dotfiles in a Windows environment. It checks for required tools
(Git and Winget), installs them if necessary, clones a specified dotfiles repository, and sets up
the dotfiles in the user's profile directory.

.LINK
GitHub      - https://github.com/RustyTake-Off
GitHub Repo - https://github.com/RustyTake-Off/dotfiles

.NOTES
Author  - RustyTake-Off
Version - 0.1.9
#>

[CmdletBinding(SupportsShouldProcess)]
param()

begin {
    # Preferences
    $ErrorActionPreference = 'Stop'
    $ProgressPreference = 'SilentlyContinue'

    # Configuration variables
    $script:RepoUrl = 'https://github.com/RustyTake-Off/dotfiles.git'
    $script:DotfilesPath = Join-Path -Path $HOME -ChildPath '.dotfiles'
    $script:BranchName = 'winfiles'
    $script:DotfilesScriptPath = Join-Path -Path $HOME -ChildPath '.dots\scripts\set-dotfiles.ps1'

    # ANSI escape sequences for different colors
    $script:Colors = @{
        Red    = [char]27 + '[31m'
        Green  = [char]27 + '[32m'
        Yellow = [char]27 + '[33m'
        Blue   = [char]27 + '[34m'
        Purple = [char]27 + '[35m'
        Reset  = [char]27 + '[0m'
    }

    # Function definitions
    function Write-ColoredMessage {
        [CmdletBinding()]
        param (
            [Parameter(Mandatory)]
            [string]$Message,

            [Parameter(Mandatory)]
            [ValidateScript({
                    if ($script:Colors.ContainsKey($_)) {
                        return $true
                    } else {
                        throw "`nInvalid color. Valid colors are: $($script:Colors.Keys -join ', ')"
                    }
                })]
            [string]$Color
        )

        process {
            Write-Host "$($script:Colors[$Color])$Message$($script:Colors.Reset)"
        }
    }

    function Install-Package {
        [CmdletBinding()]
        param (
            [Parameter(Mandatory)]
            [string]$PackageName
        )

        process {
            if (Get-Command -Name $PackageName) {
                return $false
            }

            Write-ColoredMessage -Message "$PackageName is not installed" -Color 'Red'

            while ($true) {
                $choice = Read-Host -Prompt "Do you want to install $($script:Colors.Yellow)$PackageName$($script:Colors.Reset) (y/n)?"
                $choice = $choice.Trim().ToLower() -replace ' ', ''

                switch ($choice) {
                    'y' { return $true }
                    'yes' { return $true }
                    'n' { Write-ColoredMessage -Message 'Stopping script. Bye, bye' -Color 'Red'; break 1 }
                    'no' { Write-ColoredMessage -Message 'Stopping script. Bye, bye' -Color 'Red'; break 1 }
                    default { Write-ColoredMessage -Message "Invalid input, please enter 'y' or 'n'" -Color 'Red' }
                }
            }
        }
    }
}

# Main logic
process {
    try {
        # Check and install winget
        if (Install-Package -PackageName 'winget') {
            Write-ColoredMessage -Message 'Installing Winget and its dependencies...' -Color 'Yellow'

            Invoke-RestMethod -Uri 'https://github.com/asheroto/winget-install/releases/latest/download/winget-install.ps1' | Invoke-Expression

            Write-ColoredMessage -Message 'Installed Winget and its dependencies' -Color 'Green'
        } else {
            Write-ColoredMessage -Message 'Winget is installed' -Color 'Green'
        }

        # Check and install git
        if (Install-Package -PackageName 'git') {
            Write-ColoredMessage -Message 'Installing Git...' -Color 'Yellow'

            & winget install --exact --id Git.Git --source winget --interactive --accept-package-agreements --accept-source-agreements

            Write-ColoredMessage -Message 'Installed Git' -Color 'Green'
        } else {
            Write-ColoredMessage -Message 'Git is installed' -Color 'Green'
        }

        # Clone dotfiles
        if (-not (Test-Path -Path $DotfilesPath -PathType Container)) {
            Write-ColoredMessage -Message 'Cloning dotfiles...' -Color 'Yellow'

            & git clone --bare $RepoUrl $DotfilesPath
            & git --git-dir=$DotfilesPath --work-tree=$HOME checkout $BranchName
            & git --git-dir=$DotfilesPath --work-tree=$HOME config status.showUntrackedFiles no
        } else {
            throw "Directory '$DotfilesPath' already exists"
        }

        # Run dotfiles script
        if (Test-Path -Path $DotfilesScriptPath -PathType Leaf) {
            Write-ColoredMessage -Message 'Finishing dotfiles setup...' -Color 'Yellow'

            & $DotfilesScriptPath -skipClone
        } else {
            throw "Script file in path '$DotfilesScriptPath' does not exist"
        }
    } catch {
        Write-ColoredMessage -Message "Error in line $($_.InvocationInfo.ScriptLineNumber): $($_.Exception.Message)" -Color 'Red'
        exit 1
    }
}
