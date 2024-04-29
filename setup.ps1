# ╒══════╗        ╒═══════╗
# │ ╓──┐ ║════════╗  ╓─┐  ║
# │ ╚══╛ ║──┐  ╓──╜  ║ │  ║  RustyTake-Off
# │ ╓─┐ ╓╜  │  ║  │  ║ │  ║  https://github.com/RustyTake-Off
# │ ║ │ ╚╗  │  ║  │  ╚═╛  ║  https://github.com/RustyTake-Off/dotfiles
# └─╜ └──╜  └──╜  └───────╜
# Dotfiles setup script

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
GitHub - https://github.com/RustyTake-Off
GitHub Repo - https://github.com/RustyTake-Off/dotfiles

.NOTES
Author - RustyTake-Off
#>

[CmdletBinding(SupportsShouldProcess)]

# directories to checkout from cloned dotfiles repository
$toCheckout = @{
    docs     = @('images')
    winfiles = @('.dots', '.gitconfig')
}

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
        Write-Host "$red$packageNameCapitalized$resetColor is not installed."

        $loop = $true
        while ($loop) {
            $choice = Read-Host "Do you want to install $yellow$packageNameCapitalized$resetColor (y/N)?"

            if ([string]::IsNullOrWhiteSpace($choice)) {
                $choice = 'n' # set default value to 'n' if no input is provided
            } else {
                $choice = $choice.Trim().ToLower()
            }

            if ($choice -eq 'n') {
                Write-Host "$($red)Stopping$($resetColor) script."
                exit 1
            } elseif ($choice -eq 'y') {
                return $true
            } else {
                Write-Host "$($red)Invalid input$($resetColor) please enter 'y' or 'n'."
            }
        }
    }
}

try {
    if (CheckAndAskToInstall 'winget') {
        Write-Host "Installing $($yellow)Winget$($resetColor) and its dependencies..."

        # https://github.com/asheroto/winget-install
        # https://github.com/ChrisTitusTech/winutil
        Invoke-RestMethod -Uri 'https://github.com/asheroto/winget-install/releases/latest/download/winget-install.ps1' | Invoke-Expression

        Write-Host "Installed $($green)Winget$($resetColor) and its dependencies."
    } elseif (Get-Command -Name winget) {
        Write-Host "$($green)Winget$($resetColor) is installed."
    }

    if (CheckAndAskToInstall 'git') {
        Write-Host "Installing $($yellow)Git$($resetColor)..."

        Start-Process winget -ArgumentList 'install --exact --id Git.Git --source winget --interactive --accept-package-agreements --accept-source-agreements' -NoNewWindow -Wait

        Write-Host "Installed $($green)Git$($resetColor)."
    } elseif (Get-Command -Name git) {
        Write-Host "$($green)Git$($resetColor) is installed."
    }

    if (-not (Test-Path -Path "$HOME/.dotfiles" -PathType Container)) {
        if (Get-Command -Name 'git') {
            $paths = @()

            foreach ($key in $toCheckout.Keys) {
                foreach ($item in $toCheckout[$key]) {
                    $paths += "$key/$item"
                }
            }

            Write-Host "Cloning $($yellow)dotfiles$($resetColor)..."
            git clone --bare 'https://github.com/RustyTake-Off/dotfiles.git' "$HOME/.dotfiles"
            git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" checkout $paths
            git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" config status.showUntrackedFiles no

            $winfilesPath = Resolve-Path -Path "$HOME/winfiles"
            if (Test-Path -Path $winfilesPath -PathType Container) {
                foreach ($item in $toCheckout['winfiles']) {
                    $sourcePath = Resolve-Path -Path "$winfilesPath/$item"
                    if (Test-Path -Path $sourcePath -PathType Container) {
                        Get-ChildItem -Path $sourcePath | ForEach-Object {
                            Move-Item -Path $_.FullName -Destination $HOME -Force
                        }
                    } elseif (Test-Path -Path $sourcePath -PathType Leaf) {
                        Move-Item -Path $sourcePath -Destination $HOME -Force
                    }
                }
            } else {
                Write-Host "Directory $($red)winfiles$($resetColor) not found in $($HOME)."
                exit 1
            }
        } else {
            Write-Host "$($red)Git$($resetColor) is not installed."
            exit 1
        }
    } else {
        Write-Host "Directory $($purple)dotfiles$($resetColor) already exists. $($red)Stopping$($resetColor) script."
        exit 1
    }

    exit 0 # success
} catch {
    "Error in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
    exit 1
}
