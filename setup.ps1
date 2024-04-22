# ╒══════╗        ╒═══════╗
# │ ╓──┐ ║════════╗  ╓─┐  ║
# │ ╚══╛ ║──┐  ╓──╜  ║ │  ║  RustyTake-Off
# │ ╓─┐ ╓╜  │  ║  │  ║ │  ║  https://github.com/RustyTake-Off
# │ ║ │ ╚╗  │  ║  │  ╚═╛  ║  https://github.com/RustyTake-Off/dotfiles
# └─╜ └──╜  └──╜  └───────╜
# Dotfiles setup script

<#
.SYNOPSIS
This script is designed to streamline the process of setting up personalized configurations by leveraging
version-controlled dotfiles, ensuring consistency and ease of deployment across different systems. It installs
necessary tools like Git and Winget, clones the dotfiles repository, and checks out specified directories/files
into the user's profile directory.

.DESCRIPTION
The script begins by defining directories to be checked out from a specified dotfiles repository. It checks for
the presence of required tools (Git and Winget) and prompts the user for installation if not found. Upon
installation of these tools, it proceeds to clone the dotfiles repository and checks out the specified directories/
files into the user's profile directory.

The script utilizes ANSI escape sequences to display colored output for clarity and user interaction. It handles
user input to confirm installation choices and gracefully exits if prerequisites are not met. Additionally, error
handling is implemented to provide informative messages in case of failures during the setup process.
#>

[CmdletBinding(SupportsShouldProcess)]

# directories to checkout from cloned dotfiles repository
$toCheckout = @{
    docs     = @('images')
    winfiles = @('.dots', '.gitconfig')
}

# ANSI escape sequences for different colors
$redColor = [char]27 + '[31m'
$greenColor = [char]27 + '[32m'
$yellowColor = [char]27 + '[33m'
$blueColor = [char]27 + '[34m'
$purpleColor = [char]27 + '[35m'
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
        Write-Host "$redColor$packageNameCapitalized$resetColor is not installed."

        $loop = $true
        while ($loop) {
            $choice = Read-Host "Do you want to install $yellowColor$packageNameCapitalized$resetColor (y/N)?"

            if ([string]::IsNullOrWhiteSpace($choice)) {
                $choice = 'n' # set default value to 'n' if no input is provided
            } else {
                $choice = $choice.Trim().ToLower()
            }

            if ($choice -eq 'n') {
                Write-Host "$($redColor)Stopping$($resetColor) script."
                exit 1
            } elseif ($choice -eq 'y') {
                return $true
            } else {
                Write-Host "$($redColor)Invalid input$($resetColor) please enter 'y' or 'n'."
            }
        }
    }
}

if (CheckAndAskToInstall 'winget') {
    Write-Host "Installing $($yellowColor)Winget$($resetColor) and its dependencies..."

    # https://github.com/ChrisTitusTech/winutil
    # https://github.com/asheroto/winget-install
    (Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/asheroto/winget-install/master/winget-install.ps1').Content | Invoke-Expression

    Write-Host "Installed $($greenColor)Winget$($resetColor) and its dependencies."
} elseif (Get-Command -Name winget -ErrorAction SilentlyContinue) {
    Write-Host "$($greenColor)Winget$($resetColor) is installed."
}

if (CheckAndAskToInstall 'git') {
    Write-Host "Installing $($yellowColor)Git$($resetColor)..."

    Start-Process winget -ArgumentList 'install --exact --id Git.Git --source winget --interactive --accept-package-agreements --accept-source-agreements' -NoNewWindow -Wait

    Write-Host "Installed $($greenColor)Git$($resetColor)."
} elseif (Get-Command -Name git -ErrorAction SilentlyContinue) {
    Write-Host "$($greenColor)Git$($resetColor) is installed."
}

if (-not (Test-Path -Path "$env:USERPROFILE\.dotfiles" -PathType Container)) {
    if (Get-Command -Name 'git' -ErrorAction SilentlyContinue) {
        $paths = @()

        foreach ($key in $toCheckout.Keys) {
            foreach ($item in $toCheckout[$key]) {
                $paths += "$key\$item"
            }
        }

        Write-Host "Cloning $($yellowColor)dotfiles$($resetColor)..."
        try {
            git clone --bare 'https://github.com/RustyTake-Off/dotfiles.git' "$env:USERPROFILE\.dotfiles"
            git --git-dir="$env:USERPROFILE\.dotfiles" --work-tree="$env:USERPROFILE" checkout $paths
            git --git-dir="$env:USERPROFILE\.dotfiles" --work-tree="$env:USERPROFILE" config status.showUntrackedFiles no
        } catch {
            Write-Error 'Failed cloning dotfiles.'
            Write-Error $_
            Write-Error $_.ScriptStackTrace
            exit 1
        }

        $winfilesPath = Join-Path -Path $env:USERPROFILE -ChildPath 'winfiles'
        if (Test-Path -Path $winfilesPath -PathType Container) {
            foreach ($item in $toCheckout['winfiles']) {
                $sourcePath = Join-Path -Path $winfilesPath -ChildPath $item
                if (Test-Path -Path $sourcePath -PathType Container) {
                    Get-ChildItem -Path $sourcePath | ForEach-Object {
                        Move-Item -Path $_.FullName -Destination $env:USERPROFILE -Force
                    }
                } elseif (Test-Path -Path $sourcePath -PathType Leaf) {
                    Move-Item -Path $sourcePath -Destination $env:USERPROFILE -Force
                }
            }
        } else {
            Write-Host "Directory $($redColor)winfiles$($resetColor) not found in $($env:USERPROFILE)."
            exit 1
        }
    } else {
        Write-Host "$($redColor)Git$($resetColor) is not installed."
        exit 1
    }
} else {
    Write-Host "Directory $($purpleColor)dotfiles$($resetColor) already exists. $($redColor)Stopping$($resetColor) script."
    exit 1
}
