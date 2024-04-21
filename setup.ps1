# ╒══════╗        ╒═══════╗
# │ ╓──┐ ║════════╗  ╓─┐  ║
# │ ╚══╛ ║──┐  ╓──╜  ║ │  ║  RustyTake-Off
# │ ╓─┐ ╓╜  │  ║  │  ║ │  ║  https://github.com/RustyTake-Off
# │ ║ │ ╚╗  │  ║  │  ╚═╛  ║  https://github.com/RustyTake-Off/dotfiles
# └─╜ └──╜  └──╜  └───────╜
# setup script

[CmdletBinding(SupportsShouldProcess)]

# directories to checkout from repo
$gitDirs = '.dots .gitconfig'

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

    .DESCRIPTION

    .PARAMETER packageName

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
                Write-Host 'Stopping script.'
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
    # (Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/asheroto/winget-install/master/winget-install.ps1').Content | Invoke-Expression

    Write-Host "Installed $($greenColor)Winget$($resetColor) and its dependencies!"
} elseif (Get-Command -Name winget -ErrorAction SilentlyContinue) {
    Write-Host "$($greenColor)Winget$($resetColor) is installed."
}

if (CheckAndAskToInstall 'git') {
    Write-Host "Installing $($yellowColor)Git$($resetColor)..."

    # Start-Process winget -ArgumentList 'install --exact --id Git.Git --source winget --interactive --accept-package-agreements --accept-source-agreements' -NoNewWindow -Wait

    Write-Host "Installed $($greenColor)Git$($resetColor)!"
} elseif (Get-Command -Name git -ErrorAction SilentlyContinue) {
    Write-Host "$($greenColor)Git$($resetColor) is installed."
}

try {
    if (Get-Command -Name 'git' -ErrorAction SilentlyContinue) {
        git clone --bare 'https://github.com/RustyTake-Off/dotfiles.git' "$env:USERPROFILE\.dotfiles"

        git --git-dir="$env:USERPROFILE\.dotfiles" --work-tree=$env:USERPROFILE checkout $gitDirs

        git --git-dir="$env:USERPROFILE\.dotfiles" --work-tree=$env:USERPROFILE config status.showUntrackedFiles no
    } else {
        Write-Host "$($redColor)Git$($resetColor) is not installed!"
        exit 1
    }
} catch {
    Write-Error "Failed setting up dotfiles: $_"
    Write-Error "Line: $($_.ScriptStackTrace)"
    exit 1
}
