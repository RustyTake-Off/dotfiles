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
Version - 0.1.2
#>

[CmdletBinding(SupportsShouldProcess)]

$repoUrl = 'https://github.com/RustyTake-Off/dotfiles.git'
$dotfilesPath = "$HOME/.dotfiles"
$winfilesPath = "$HOME/winfiles"
$toCheckout = @{
    docs     = @('images')
    winfiles = @('.dots', '.gitconfig')
}

$scriptPath = "$HOME/.dots/scripts/set-dotfiles.ps1"

# ANSI escape sequences for different colors
$red = [char]27 + '[31m'
$green = [char]27 + '[32m'
$yellow = [char]27 + '[33m'
$blue = [char]27 + '[34m'
$purple = [char]27 + '[35m'
$resetColor = [char]27 + '[0m'

function CheckAndAskToInstall([string]$packageName) {
    <#
    .SYNOPSIS
    Checks if a specified package is installed and prompts the user to install it if not found.

    .DESCRIPTION
    This function verifies whether a given package (specified by `$packageName`) is installed on the system. If
    the package is not detected, it prompts the user to decide whether to proceed with the installation. The user
    is asked to confirm installation by entering 'y' or decline by entering 'n'. If no response is provided, the
    default action is to abort the script.

    .PARAMETER packageName
    Specifies the name of the package to be checked for installation.

    .EXAMPLE
    CheckAndAskToInstall -packageName "git"
    #>

    if (-not (Get-Command -Name $packageName -ErrorAction SilentlyContinue)) {
        $packageNameCapitalized = $packageName.Substring(0, 1).ToUpper() + $packageName.Substring(1)
        Write-Host "$($red)$packageNameCapitalized is not installed$($resetColor)"

        $loop = $true
        while ($loop) {
            $choice = Read-Host "Do you want to install $($yellow)$packageNameCapitalized$($resetColor) (y/N)?"

            if ([string]::IsNullOrWhiteSpace($choice)) {
                $choice = 'n' # set default value to 'n' if no input is provided
            } else {
                $choice = $choice.Trim().ToLower()
            }

            if ($choice -eq 'n') {
                Write-Host "$($red)Stopping script$($resetColor)"
                exit 1
            } elseif ($choice -eq 'y') {
                return $true
            } else {
                Write-Host "$($red)Invalid input please enter 'y' or 'n'$($resetColor)"
            }
        }
    }
}

try {
    # Check winget
    if (CheckAndAskToInstall 'winget') {
        Write-Host "Installing $($yellow)Winget$($resetColor) and its dependencies..."

        # https://github.com/asheroto/winget-install
        Invoke-RestMethod -Uri 'https://github.com/asheroto/winget-install/releases/latest/download/winget-install.ps1' | Invoke-Expression

        Write-Host "Installed $($green)Winget$($resetColor) and its dependencies"
    } elseif (Get-Command -Name winget) {
        Write-Host "$($green)Winget$($resetColor) is installed"
    }

    # Check git
    if (CheckAndAskToInstall 'git') {
        Write-Host "Installing $($yellow)Git$($resetColor)..."

        Start-Process winget -ArgumentList 'install --exact --id Git.Git --source winget --interactive --accept-package-agreements --accept-source-agreements' -NoNewWindow -Wait

        Write-Host "Installed $($green)Git$($resetColor)"
    } elseif (Get-Command -Name git) {
        Write-Host "$($green)Git$($resetColor) is installed"
    }

    # Get dotfiles
    if (Get-Command -Name git -ErrorAction SilentlyContinue) {
        $dotfilesPathExists = Test-Path -Path $dotfilesPath -PathType Container
        $paths = @()

        foreach ($key in $toCheckout.Keys) {
            foreach ($item in $toCheckout[$key]) {
                $paths += "$key/$item"
            }
        }

        if (-not $dotfilesPathExists) {
            Write-Host "Cloning $($yellow)dotfiles$($resetColor)..."
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
            Write-Host "$($red)Directory '.dotfiles' already exists in '$HOME'$($resetColor)"
            exit 1
        }
    } else {
        Write-Host "$($red)Git is not installed$($resetColor)"
        exit 1
    }

    if (Test-Path -Path $scriptPath -PathType Container) {
        Write-Host "Setting $($yellow)dotfiles$($resetColor)..."

        Invoke-Expression $scriptPath -skipDotfiles

        Write-Host "$($green)Dotfiles$($resetColor) are set"
    } else {
        Write-Host "$($red)Script in path '$scriptPath' does not exist$($resetColor)"
        exit 1
    }

    exit 0 # success
} catch {
    "Error in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
    exit 1
}
