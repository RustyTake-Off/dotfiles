<#
.SYNOPSIS
Winup setup script

.DESCRIPTION
Script for initial setup of a fresh system install.

.EXAMPLE
winup.ps1 drivers min
Downloads minimum needed drivers

.EXAMPLE
winup.ps1 drivers all
Downloads all drivers

.EXAMPLE
winup.ps1 fonts
Downloads and installs fonts

.EXAMPLE
winup.ps1 ctt
Invokes the CTT - winutil script

.EXAMPLE
winup.ps1 apps base
Installs base applications

.EXAMPLE
winup.ps1 apps util
Installs utility applications

.EXAMPLE
winup.ps1 psmods
Installs PowerShell modules

.EXAMPLE
winup.ps1 dots
Invokes dotfiles setup script

.EXAMPLE
winup.ps1 wsl Ubuntu-22.04
Installs Ubuntu-22.04 on WSL

.LINK
GitHub      - https://github.com/RustyTake-Off
GitHub Repo - https://github.com/RustyTake-Off/dotfiles

.NOTES
Author  - RustyTake-Off
Version - 0.3.2
#>

[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter(Mandatory = $false, Position = 0)]
    [ValidateSet('drivers', 'fonts', 'ctt', 'psmods', 'apps', 'dots', 'wsl', 'help')]
    [string] $command,

    [Parameter(Mandatory = $false, Position = 1)]
    [string] $subCommand
)

# Define valid subCommands for each command
$validSubCommands = @{
    'drivers' = @('min', 'all')
    'apps'    = @('base', 'util')
    'wsl'     = @('Debian', 'Ubuntu-24.04', 'Ubuntu-22.04', 'Ubuntu-20.04', 'kali-linux')
}

# Validate subCommand based on the selected command
if ($validSubCommands.ContainsKey($command) -and -not $validSubCommands[$command].Contains($subCommand)) {
    Write-Error "Invalid subCommand '$subCommand' for command '$command'. Valid options are: $($validSubCommands[$command] -join ', ')"
    exit 1
}

# Configuration variables
$dotsPath = "$HOME/.config"
$configPath = "$HOME/.config/config.json"
if (Test-Path -Path $configPath -PathType Leaf) {
    $config = Get-Content -Path $configPath | ConvertFrom-Json
}
$repoDotsUrl = 'https://raw.githubusercontent.com/RustyTake-Off/dotfiles/main/winfiles/.dots/scripts/set-dotfiles.ps1'
$userAgent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Safari/537.36'

# ANSI escape sequences for different colors
$colors = @{
    red    = [char]27 + '[31m'
    green  = [char]27 + '[32m'
    yellow = [char]27 + '[33m'
    blue   = [char]27 + '[34m'
    purple = [char]27 + '[35m'
    reset  = [char]27 + '[0m'
}

if (-not (Test-Path -Path "$HOME\pr" -PathType Container)) {
    Write-Host "Creating $($colors.yellow)'personal'$($colors.reset) directory"
    $null = New-Item -Path "$HOME\pr" -ItemType Directory
}

if (-not (Test-Path -Path "$HOME\wk" -PathType Container)) {
    Write-Host "Creating $($colors.yellow)'work'$($colors.reset) directory"
    $null = New-Item -Path "$HOME\wk" -ItemType Directory
}

# Function definitions
function Write-ColoredMessage {
    param (
        [string]$message,
        [string]$color
    )
    Write-Host "$($colors[$color])$message$($colors.reset)"
}

function Show-Help {
    Write-ColoredMessage 'Available commands:' 'yellow'
    Write-Host @"
$($colors.yellow)  help    $($colors.reset) - Print help message
$($colors.yellow)  drivers $($colors.reset)
$($colors.yellow)  :  min  $($colors.reset) - Download minimum needed drivers
$($colors.yellow)  :  all  $($colors.reset) - Download all drivers
$($colors.yellow)  fonts   $($colors.reset) - Download and install fonts
$($colors.yellow)  ctt     $($colors.reset) - Invoke CTT - winutil script
$($colors.yellow)  apps    $($colors.reset)
$($colors.yellow)  :  base $($colors.reset) - Install base applications
$($colors.yellow)  :  util $($colors.reset) - Install utility applications
$($colors.yellow)  psmods  $($colors.reset) - Install PowerShell modules
$($colors.yellow)  dots    $($colors.reset) - Invoke dotfiles setup script
$($colors.yellow)  wsl     $($colors.reset)
$($colors.yellow)  :  Debian       $($colors.reset) - Install Debian on WSL
$($colors.yellow)  :  Ubuntu-24.04 $($colors.reset) - Install Ubuntu-24.04 on WSL
$($colors.yellow)  :  Ubuntu-22.04 $($colors.reset) - Install Ubuntu-22.04 on WSL
$($colors.yellow)  :  Ubuntu-20.04 $($colors.reset) - Install Ubuntu-20.04 on WSL
$($colors.yellow)  :  kali-linux   $($colors.reset) - Install kali-linux on WSL
"@
}

function New-Directory() {
    param (
        [string]$path
    )

    Write-ColoredMessage "Creating $path..." 'yellow'
    $null = New-Item -Path $path -ItemType Directory
}

function Invoke-Download() {
    param (
        [string]$url,
        [string]$path
    )
    $fileName = Split-Path -Path $url -Leaf
    $downloadPath = Join-Path -Path $path -ChildPath $fileName

    Write-ColoredMessage "Downloading $url..." 'yellow'
    Invoke-WebRequest -Uri $url -UserAgent $userAgent -OutFile $downloadPath -ProgressAction SilentlyContinue
}

function Install-Fonts() {
    param (
        [System.IO.FileInfo][object]$fontFile
    )
    $fontsGTF = [Windows.Media.GlyphTypeface]::New($fontFile.FullName)

    $family = $fontsGTF.Win32FamilyNames['en-US']
    if ($null -eq $family) {
        $family = $fontsGTF.Win32FamilyNames.Values.Item(0)
    }

    $face = $fontsGTF.Win32FaceNames['en-US']
    if ($null -eq $face) {
        $face = $fontsGTF.Win32FaceNames.Values.Item(0)
    }

    $fontName = ("$family $face").Trim()
    switch ($fontFile.Extension) {
        '.ttf' {
            $fontName = "$fontName (TrueType)"
        }
        '.otf' {
            $fontName = "$fontName (OpenType)"
        }
    }

    Write-ColoredMessage "Installing $fontName..." 'yellow'
    $fontPath = "$env:SystemRoot/fonts/$($fontFile.Name)"
    if (-not (Test-Path -Path $fontPath)) {
        Write-ColoredMessage "Copying font $fontName..." 'yellow'
        Copy-Item -Path $fontFile.FullName -Destination $fontPath -Force
    } else {
        Write-ColoredMessage "Font already in place $fontName" 'green'
    }

    if (-not (Get-ItemProperty -Name $fontName -Path 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts' -ErrorAction SilentlyContinue)) {
        Write-ColoredMessage "Registering $fontName..." 'yellow'
        New-ItemProperty -Name $fontName -Path 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts' -PropertyType String -Value $fontFile.Name -Force -ErrorAction SilentlyContinue | Out-Null
    } else {
        Write-ColoredMessage "Font already registered $fontName" 'green'
    }
}

function Invoke-GetDrivers {
    param (
        [string]$type
    )

    $driversPath = "$HOME/Desktop/drivers"
    if (-not (Test-Path -Path $driversPath -PathType Container)) {
        New-Directory -path $driversPath
    }

    Write-ColoredMessage 'Downloading drivers...' 'purple'
    foreach ($driverUrl in $config.drivers.$type) {
        Invoke-Download -url $driverUrl -path $driversPath
    }
    Write-ColoredMessage 'Download complete' 'green'
}

function Invoke-InstallFonts {
    $fontsPath = "$HOME/Desktop/fonts"
    if (-not (Test-Path -Path $fontsPath -PathType Container)) {
        New-Directory -path $fontsPath
    }

    Write-ColoredMessage 'Downloading fonts...' 'yellow'
    foreach ($fontUrl in $config.fonts) {
        Invoke-Download -url $fontUrl -path $fontsPath
    }
    Write-ColoredMessage 'Download complete' 'green'

    Write-ColoredMessage 'Extracting fonts...' 'yellow'
    $fontsZipFiles = Get-ChildItem -Path $fontsPath -Filter '*.zip'
    foreach ($zipFile in $fontsZipFiles) {
        $extractionDirectoryPath = "$fontsPath/$zipFile.BaseName"

        if (-not (Test-Path -Path $extractionDirectoryPath -PathType Container)) {
            New-Directory -path $extractionDirectoryPath
        }

        Write-Host "Extracting $($yellow)$($zipFile.Name)$($resetColor) to $($purple)$extractionDirectoryPath$($resetColor)"
        Expand-Archive -Path $zipFile.FullName -DestinationPath $extractionDirectoryPath -Force
        Remove-Item -Path $zipFile.FullName -Force
        Write-ColoredMessage 'Extraction complete' 'green'

        Write-ColoredMessage "Installing fonts $($zipFile.BaseName)..." 'yellow'
        $fonts = Get-ChildItem -Path $extractionDirectoryPath | Where-Object { ($_.Name -like '*.ttf') -or ($_.Name -like '*.otf') }
        Add-Type -AssemblyName PresentationCore
        foreach ($fontItem in $fonts) {
            Install-Fonts -fontFile $fontItem.FullName
        }
        Write-ColoredMessage "Installation of $($zipFile.BaseName) complete" 'green'
    }
}

function Invoke-CTT {
    Write-ColoredMessage 'Invoking CTT - winutil...' 'yellow'
    Invoke-WebRequest 'https://christitus.com/win' | Invoke-Expression
    Write-ColoredMessage 'Invocation complete' 'green'
}

function Invoke-InstallApps {
    param (
        [string]$type
    )

    if (Get-Command -Name winget) {
        $null = winget list --accept-source-agreements
    } else {
        throw 'Winget is not installed'
    }

    Write-ColoredMessage 'Installing applications...' 'yellow'
    foreach ($app in $config.apps.$type) {
        if ($app.source -eq 'winget') {
            if (-not (winget list --exact --id $app.name | Select-String -SimpleMatch $app.name)) {
                Write-Host "Installing $($yellow)$($app.name)$($resetColor) $($purple)($($app.source))$($resetColor)..."

                Start-Process winget -ArgumentList "install --exact --id $($app.name) --source $($app.source) $($app.args) --accept-package-agreements --accept-source-agreements" -NoNewWindow -Wait
            } else {
                Write-Host "App is already installed $($yellow)$($app.name)$($resetColor) $($purple)($($app.source))$($resetColor)"
            }
        } elseif ($app.source -eq 'msstore') {
            if (-not (winget list --exact --id $app.id | Select-String -SimpleMatch $app.id)) {
                Write-Host "Installing $($yellow)$($app.name)$($resetColor) $($purple)($($app.id))($($app.source))$($resetColor)..."

                Start-Process winget -ArgumentList "install --exact --id $($app.id) --source $($app.source) $($app.args) --accept-package-agreements --accept-source-agreements" -NoNewWindow -Wait
            } else {
                Write-Host "App is already installed $($yellow)$($app.name)$($resetColor) $($purple)($($app.id))($($app.source))$($resetColor)"
            }
        }
    }
    Write-ColoredMessage 'Installation complete' 'green'
}

function Invoke-InstallPSModules {
    Write-ColoredMessage 'Installing Powershell modules...' 'yellow'
    if (-not (Get-PackageProvider | Select-String -SimpleMatch NuGet)) {
        Install-PackageProvider -Name NuGet
    }

    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

    foreach ($module in $config.psmodules) {
        Write-ColoredMessage "Installing $module..." 'yellow'
        Install-Module -Name $module -Repository PSGallery -Force
    }

    Set-PSRepository -Name PSGallery -InstallationPolicy Untrusted
    Write-ColoredMessage 'Installation complete' 'green'
}

function Invoke-DotfilesScript {
    Write-ColoredMessage 'Invoking Dotfiles setup script...' 'yellow'
    $dotfilesScriptPath = "$dotsPath/scripts/set-dotfiles.ps1"
    if (Test-Path -Path $dotfilesScriptPath -PathType Leaf) {
        Invoke-Expression $dotfilesScriptPath
    } else {
        (Invoke-WebRequest -Uri $repoDotsUrl).Content | Invoke-Expression
    }
    Write-ColoredMessage 'Invocation complete' 'green'
}

function Invoke-InstallWSL {
    param (
        [string]$distro
    )

    Write-ColoredMessage "Installing WSL ($distro)..." 'purple'
    wsl --install --distribution $distro
    Write-ColoredMessage 'Installation complete' 'green'
}

# Command execution
switch ($command) {
    'drivers' {
        Invoke-GetDrivers -type $subCommand
    }
    'fonts' {
        Invoke-InstallFonts
    }
    'ctt' {
        Invoke-CTT
    }
    'apps' {
        Invoke-InstallApps -type $subCommand
    }
    'psmods' {
        Invoke-InstallPSModules
    }
    'dots' {
        Invoke-DotfilesScript
    }
    'wsl' {
        Invoke-InstallWSL -distro $subCommand
    }
    'help' {
        Show-Help
    }
    default {
        Show-Help
    }
}
