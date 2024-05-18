<#
.SYNOPSIS
Winup setup script

.DESCRIPTION
Script for initial setup of a fresh system install.

.EXAMPLE
winup.ps1 -command drivers -subCommand min
Downloads minimum needed drivers

.EXAMPLE
winup.ps1 -command drivers -subCommand all
Downloads all drivers

.EXAMPLE
winup.ps1 -command fonts
Downloads and installs fonts

.EXAMPLE
winup.ps1 -command ctt
Invokes the CTT - winutil script

.EXAMPLE
winup.ps1 -command apps -subCommand base
Installs base applications

.EXAMPLE
winup.ps1 -command apps -subCommand util
Installs utility applications

.EXAMPLE
winup.ps1 -command psmods
Installs PowerShell modules

.EXAMPLE
winup.ps1 -command dots
Invokes dotfiles setup script

.EXAMPLE
winup.ps1 -command wsl -subCommand Ubuntu-22.04
Installs Ubuntu-22.04 on WSL

.LINK
GitHub      - https://github.com/RustyTake-Off
GitHub Repo - https://github.com/RustyTake-Off/dotfiles

.NOTES
Author  - RustyTake-Off
Version - 0.2.1
#>

[CmdletBinding(SupportsShouldProcess)]
$ErrorActionPreference = 'SilentlyContinue'

param (
    [Parameter(Mandatory = $false, Position = 0)]
    [ValidateSet('drivers', 'fonts', 'ctt', 'psmods', 'apps', 'dots', 'wsl', 'help')]
    [Alias('-c')]
    [String] $command,

    [Parameter(Mandatory = $false, Position = 1)]
    [ValidateSet('min', 'all', 'base', 'util', 'Debian', 'Ubuntu-24.04', 'Ubuntu-22.04', 'Ubuntu-20.04', 'kali-linux', 'help')]
    [Alias('-s')]
    [String] $subCommand
)

$dotsPath = "$HOME/.dots"
$configPath = "$HOME/.dots/config.json"
if (Test-Path -Path $configPath -PathType Leaf) {
    $config = Get-Content -Path configPath | ConvertFrom-Json
}
$repoDotsUrl = 'https://raw.githubusercontent.com/RustyTake-Off/dotfiles/main/winfiles/.dots/'

# ANSI escape sequences for different colors
$red = [char]27 + '[31m'
$green = [char]27 + '[32m'
$yellow = [char]27 + '[33m'
$blue = [char]27 + '[34m'
$purple = [char]27 + '[35m'
$resetColor = [char]27 + '[0m'

$userAgent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Safari/537.36'

if (-not (Test-Path -Path "$HOME\pr" -PathType Container)) {
    Write-Host "Creating '$($yellow)personal$($resetColor)' directory"
    $null = New-Item -Path "$HOME\pr" -ItemType Directory
}

if (-not (Test-Path -Path "$HOME\wk" -PathType Container)) {
    Write-Host "Creating '$($yellow)work$($resetColor)' directory"
    $null = New-Item -Path "$HOME\wk" -ItemType Directory
}

function Get-Help {
    Write-Host "Available $($yellow)commands$($resetColor):"
    Write-Host @"
$($yellow)  help    $($resetColor) - Print help message
$($yellow)  drivers $($resetColor)
$($yellow)  :  min  $($resetColor) - Download minimum needed drivers
$($yellow)  :  all  $($resetColor) - Download all drivers
$($yellow)  fonts   $($resetColor) - Download and install fonts
$($yellow)  ctt     $($resetColor) - Invoke CTT - winutil script
$($yellow)  apps    $($resetColor)
$($yellow)  :  base $($resetColor) - Install base applications
$($yellow)  :  util $($resetColor) - Install utility applications
$($yellow)  psmods  $($resetColor) - Install PowerShell modules
$($yellow)  dots    $($resetColor) - Invoke dotfiles setup script
$($yellow)  wsl     $($resetColor)
$($yellow)  :  Debian       $($resetColor) - Install Debian on WSL
$($yellow)  :  Ubuntu-24.04 $($resetColor) - Install Ubuntu-24.04 on WSL
$($yellow)  :  Ubuntu-22.04 $($resetColor) - Install Ubuntu-22.04 on WSL
$($yellow)  :  Ubuntu-20.04 $($resetColor) - Install Ubuntu-20.04 on WSL
$($yellow)  :  kali-linux   $($resetColor) - Install kali-linux on WSL
"@
}

function New-Directory([string]$path) {
    Write-Host "Creating $($yellow)$path$($resetColor)..."

    $null = New-Item -Path $path -ItemType Directory
}

function Invoke-Download([string]$url, [string]$path) {
    $fileName = Split-Path -Path $url -Leaf
    $downloadPath = Join-Path -Path $path -ChildPath $fileName

    Write-Host "Downloading $($yellow)$url$($resetColor)..."
    Invoke-WebRequest -Uri $url -UserAgent $userAgent -OutFile $downloadPath -ProgressAction SilentlyContinue
}

function Install-Fonts([System.IO.FileInfo][object]$fontFile) {
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

    Write-Host "Installing $($yellow)$fontName$($resetColor)..."
    $fontPath = "$env:SystemRoot/fonts/$($fontFile.Name)"
    if (-not (Test-Path -Path $fontPath)) {
        Write-Host "Copying font $($yellow)$fontName$($resetColor)..."
        Copy-Item -Path $fontFile.FullName -Destination $fontPath -Force
    } else {
        Write-Host "Font already in place $($green)$fontName$($resetColor)"
    }

    if (-not (Get-ItemProperty -Name $fontName -Path 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts' -ErrorAction SilentlyContinue)) {
        Write-Host "Registering $($yellow)$fontName$($resetColor)..."
        $null = New-ItemProperty -Name $fontName -Path 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts' -PropertyType String -Value $fontFile.Name -Force -ErrorAction SilentlyContinue
    } else {
        Write-Host "Font already registered $($green)$fontName$($resetColor)"
    }
}

function Invoke-GetDrivers {
    param (
        [Parameter(Mandatory)]
        [string]$type
    )

    $driversPath = "$HOME/Desktop/drivers"
    if (-not (Test-Path -Path $driversPath -PathType Container)) {
        New-Directory -path $driversPath
    }

    Write-Host "Downloading $($purple)drivers$($resetColor)..."

    foreach ($driverUrl in $config.drivers.$type) {
        Invoke-Download -url $driverUrl -path $driversPath
    }

    Write-Host "Download $($green)complete$($resetColor)"
}

function Invoke-InstallFonts {
    $fontsPath = "$HOME/Desktop/fonts"
    if (-not (Test-Path -Path $fontsPath -PathType Container)) {
        New-Directory -path $fontsPath
    }

    Write-Host "Downloading $($purple)fonts$($resetColor)..."

    foreach ($fontUrl in $config.fonts) {
        Invoke-Download -url $fontUrl -path $fontsPath
    }

    Write-Host "Download $($green)complete$($resetColor)"

    Write-Host "Extracting $($yellow)fonts$($resetColor)..."
    $fontsZipFiles = Get-ChildItem -Path $fontsPath -Filter '*.zip'
    foreach ($zipFile in $fontsZipFiles) {
        $extractionDirectoryPath = "$fontsPath/$zipFile.BaseName"

        if (-not (Test-Path -Path $extractionDirectoryPath -PathType Container)) {
            New-Directory -path $extractionDirectoryPath
        }

        Write-Host "Extracting $($yellow)$($zipFile.Name)$($resetColor) to $($purple)$extractionDirectoryPath$($resetColor)"
        Expand-Archive -Path $zipFile.FullName -DestinationPath $extractionDirectoryPath -Force
        Remove-Item -Path $zipFile.FullName -Force
        Write-Host "Extraction $($green)complete$($resetColor)"

        Write-Host "Installing fonts $($yellow)$($zipFile.BaseName)$($resetColor)..."
        $fonts = Get-ChildItem -Path $extractionDirectoryPath | Where-Object { ($_.Name -like '*.ttf') -or ($_.Name -like '*.otf') }
        Add-Type -AssemblyName PresentationCore
        foreach ($fontItem in $fonts) {
            Install-Fonts -fontFile $fontItem.FullName
        }

        Write-Host "Installation of $($green)$($zipFile.BaseName) complete$($resetColor)"
    }
}

function Invoke-CTT {
    Write-Host "Invoking $($yellow)CTT - winutil$($resetColor)..."

    Invoke-WebRequest 'https://christitus.com/win' | Invoke-Expression

    Write-Host "Invocation $($green)complete$($resetColor)"
}

function Get-Apps {
    param (
        [Parameter(Mandatory)]
        [string]$type
    )

    if (Get-Command -Name winget) {
        $null = winget list --accept-source-agreements
    } else {
        throw 'Winget is not installed'
    }

    Write-Host "Installing $($yellow)applications$($resetColor)..."

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

    Write-Host "Installation $($green)complete$($resetColor)"
}

function Get-PSModules {
    Write-Host "Installing $($yellow)Powershell modules$($resetColor)..."

    if (-not (Get-PackageProvider | Select-String -SimpleMatch NuGet)) {
        Install-PackageProvider -Name NuGet
    }

    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

    foreach ($module in $config.psmodules) {
        Write-Host "Installing $($yellow)$module$($resetColor)..."
        Install-Module -Name $module -Repository PSGallery -Force
    }

    Set-PSRepository -Name PSGallery -InstallationPolicy Untrusted

    Write-Host "Installation $($green)complete$($resetColor)"
}

function Invoke-DotfilesScript {
    Write-Host "Invoking $($yellow)Dotfiles$($resetColor) setup script..."

    $dotfilesScriptPath = "$dotsPath/scripts/set-dotfiles.ps1"
    if (Test-Path -Path $dotfilesScriptPath -PathType Leaf) {
        Invoke-Expression $dotfilesScriptPath
    } else {
            (Invoke-WebRequest -Uri "$repoDotsUrl/scripts/set-dotfiles.ps1").Content | Invoke-Expression
    }

    Write-Host "Invocation $($green)complete$($resetColor)"
}

function Install-WSL {
    param (
        [Parameter(Mandatory)]
        [string]$distribution
    )

    Write-Host "Installing $($yellow)$distribution$($resetColor) on WSL..."

    wsl --install --distribution $distribution

    Write-Host "Installation $($green)complete$($resetColor)"
}

try {
    switch ($command) {
        'drivers' {
            switch -regex ($subCommand) {
                'min|all' {
                    Invoke-GetDrivers -type $subCommand
                }
                'help' {
                    Get-Help
                }
                default {
                    Get-Help
                }
            }
        }
        'fonts' {
            Invoke-InstallFonts
        }
        'ctt' {
            Invoke-CTT
        }
        'apps' {
            switch -regex ($subCommand) {
                'base|util' {
                    Get-Apps -type $subCommand
                }
                'help' {
                    Get-Help
                }
                default {
                    Get-Help
                }
            }
        }
        'psmods' {
            Get-PSModules
        }
        'dots' {
            Invoke-DotfilesScript
        }
        'wsl' {
            switch -regex ($subCommand) {
                'Debian|Ubuntu-24.04|Ubuntu-22.04|Ubuntu-20.04|kali-linux' {
                    Install-WSL -distribution $subCommand
                }
                'help' {
                    Get-Help
                }
                default {
                    Get-Help
                }
            }
        }
        'help' {
            Get-Help
        }
        default {
            Get-Help
        }
    }

    $ErrorActionPreference = 'Continue'
    exit 0 # success
} catch {
    "Error in line $($_.InvocationInfo.ScriptLineNumber): $($red)$($Error[0])$($resetColor)"
    exit 1
}
