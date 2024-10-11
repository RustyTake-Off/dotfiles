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
#>

[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter(Mandatory = $false, Position = 0)]
    [ValidateSet('drivers', 'fonts', 'ctt', 'psmods', 'apps', 'dots', 'wsl', 'help')]
    [string]$Command,
    [Parameter(Mandatory = $false, Position = 1)]
    [string]$SubCommand
)

# Preferences
$errAction = $ErrorActionPreference
$ErrorActionPreference = 'SilentlyContinue'

# Define valid subCommands for each command
$validSubCommands = @{
    'drivers' = @('min', 'all')
    'apps'    = @('base', 'util')
    'wsl'     = @('Debian', 'Ubuntu-24.04', 'Ubuntu-22.04', 'Ubuntu-20.04', 'kali-linux')
}

# Configuration variables
$dotsPath = "$HOME/.dots"
$configPath = "$HOME/.dots/config.json"
$config = if (Test-Path -Path $configPath) { Get-Content -Path $configPath | ConvertFrom-Json } else { $null }
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

function Show-Help {
    <#
    .SYNOPSIS
    Help message
    #>

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

function Confirm-SubCommand {
    <#
    .SYNOPSIS
    Validates sub-commands
    #>

    param (
        [string]$Command,
        [string]$SubCommand,
        [hashtable]$ValidSubCommands
    )

    if ($ValidSubCommands.ContainsKey($Command) -and -not $ValidSubCommands[$Command].Contains($SubCommand)) {
        throw "Invalid SubCommand '$SubCommand' for Command '$Command'. Valid options are: $($ValidSubCommands[$Command] -join ', ')"
    }
}

function Confirm-DirectoryExists() {
    <#
    .SYNOPSIS
    Validates if directory exists else creates it
    #>

    param (
        [string]$Path
    )

    if (-not (Test-Path -Path $Path -PathType Container)) {
        Write-ColoredMessage "Creating directory: $Path" 'yellow'
        $null = New-Item -Path $Path -ItemType Directory
    }
}

function Invoke-Download() {
    <#
    .SYNOPSIS
    Invokes download
    #>

    param (
        [string]$Url,
        [string]$DestinationPath
    )

    $fileName = Split-Path -Path $Url -Leaf
    $downloadPath = Join-Path -Path $DestinationPath -ChildPath $fileName

    Write-ColoredMessage "Downloading: $Url" 'yellow'
    Invoke-WebRequest -Uri $Url -UserAgent $userAgent -OutFile $downloadPath -ProgressAction SilentlyContinue
}

function Install-Fonts() {
    <#
    .SYNOPSIS
    Installs fonts
    #>

    param (
        [System.IO.FileInfo][object]$FontFile
    )

    $fontsGTF = [Windows.Media.GlyphTypeface]::New($FontFile.FullName)
    $family = $fontsGTF.Win32FamilyNames['en-US']
    if ($null -eq $family) {
        $family = $fontsGTF.Win32FamilyNames.Values.Item(0)
    }

    $face = $fontsGTF.Win32FaceNames['en-US']
    if ($null -eq $face) {
        $face = $fontsGTF.Win32FaceNames.Values.Item(0)
    }

    $fontName = ("$family $face").Trim()
    switch ($FontFile.Extension) {
        '.ttf' {
            $fontName = "$fontName (TrueType)"
        }
        '.otf' {
            $fontName = "$fontName (OpenType)"
        }
    }

    Write-ColoredMessage "Installing $fontName..." 'yellow'
    $fontPath = "$env:SystemRoot/fonts/$($FontFile.Name)"
    if (-not (Test-Path -Path $fontPath)) {
        Write-ColoredMessage "Copying font $fontName..." 'yellow'
        Copy-Item -Path $FontFile.FullName -Destination $fontPath -Force
    } else {
        Write-ColoredMessage "Font already in place $fontName" 'green'
    }

    if (-not (Get-ItemProperty -Name $fontName -Path 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts')) {
        Write-ColoredMessage "Registering $fontName..." 'yellow'
        New-ItemProperty -Name $fontName -Path 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts' -PropertyType String -Value $FontFile.Name -Force
    } else {
        Write-ColoredMessage "Font already registered $fontName" 'green'
    }
}

function Invoke-GetDrivers {
    <#
    .SYNOPSIS
    Downloads drivers
    #>

    param (
        [string]$Type
    )

    $driversPath = "$HOME/Desktop/drivers"
    Confirm-DirectoryExists -Path $driversPath

    Write-ColoredMessage "Downloading '$Type' drivers..." 'purple'

    foreach ($driverUrl in $config.drivers.$Type) {
        Invoke-Download -Url $driverUrl -DestinationPath $driversPath
    }

    Write-ColoredMessage 'Driver download complete' 'green'
}

function Invoke-InstallFonts {
    <#
    .SYNOPSIS
    Installs fonts
    #>

    $fontsPath = "$HOME/Desktop/fonts"
    Confirm-DirectoryExists -Path $fontsPath

    Write-ColoredMessage 'Downloading fonts...' 'yellow'
    foreach ($fontUrl in $config.fonts) {
        Invoke-Download -Url $fontUrl -DestinationPath $fontsPath
    }
    Write-ColoredMessage 'Fonts download complete' 'green'

    Write-ColoredMessage 'Extracting fonts...' 'yellow'
    $fontsZipFiles = Get-ChildItem -Path $fontsPath -Filter '*.zip'
    foreach ($zipFile in $fontsZipFiles) {
        $extractionDirectoryPath = "$fontsPath/$($zipFile.BaseName)"
        Confirm-DirectoryExists -Path $fontsPath

        Write-Host "Extracting $($colors.yellow)$($zipFile.Name)$($colors.reset) to $($colors.purple)$extractionDirectoryPath$($colors.reset)"
        Expand-Archive -Path $zipFile.FullName -DestinationPath $extractionDirectoryPath -Force
        Remove-Item -Path $zipFile.FullName -Force
        Write-ColoredMessage 'Extraction complete' 'green'

        Write-ColoredMessage "Installing fonts $($zipFile.BaseName)..." 'yellow'
        $fonts = Get-ChildItem -Path $extractionDirectoryPath | Where-Object { ($_.Name -like '*.ttf') -or ($_.Name -like '*.otf') }
        Add-Type -AssemblyName PresentationCore
        foreach ($fontItem in $fonts) {
            Install-Fonts -FontFile $fontItem.FullName
        }
        Write-ColoredMessage "Installation of $($zipFile.BaseName) complete" 'green'
    }
}

function Invoke-CTT {
    <#
    .SYNOPSIS
    Invokes Chris Titus Tech's windows utility

    .LINK
    GitHub repo - https://github.com/ChrisTitusTech/winutil
    #>

    Write-ColoredMessage 'Invoking CTT - winutil...' 'yellow'

    Invoke-WebRequest 'https://christitus.com/win' | Invoke-Expression

    Write-ColoredMessage 'Invocation complete' 'green'
}

function Invoke-InstallApps {
    <#
    .SYNOPSIS
    Installs apps
    #>

    param (
        [string]$Type
    )

    if (Get-Command -Name winget) {
        $null = winget list --accept-source-agreements
    } else {
        throw 'Winget is not installed'
    }

    Write-ColoredMessage 'Installing applications...' 'yellow'

    foreach ($app in $config.apps.$Type) {
        if ($app.source -eq 'winget') {
            if (-not (winget list --exact --id $app.name | Select-String -SimpleMatch $app.name)) {
                Write-Host "Installing $($colors.yellow)$($app.name)$($colors.reset) $($colors.purple)($($app.source))$($colors.reset)..."

                Start-Process winget -ArgumentList "install --exact --id $($app.name) --source $($app.source) $($app.args) --accept-package-agreements --accept-source-agreements" -NoNewWindow -Wait
            } else {
                Write-Host "Already installed: $($colors.yellow)$($app.name)$($colors.reset) $($colors.purple)($($app.source))$($colors.reset)"
            }
        } elseif ($app.source -eq 'msstore') {
            if (-not (winget list --exact --id $app.id | Select-String -SimpleMatch $app.id)) {
                Write-Host "Installing $($colors.yellow)$($app.name)$($colors.reset) $($colors.purple)($($app.id))($($app.source))$($colors.reset)..."

                Start-Process winget -ArgumentList "install --exact --id $($app.id) --source $($app.source) $($app.args) --accept-package-agreements --accept-source-agreements" -NoNewWindow -Wait
            } else {
                Write-Host "Already installed: $($colors.yellow)$($app.name)$($colors.reset) $($colors.purple)($($app.id))($($app.source))$($colors.reset)"
            }
        }
    }

    Write-ColoredMessage 'Installation complete' 'green'
}

function Invoke-InstallPSModules {
    <#
    .SYNOPSIS
    Installs PowerShell modules
    #>

    Write-ColoredMessage 'Installing PowerShell modules...' 'yellow'

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
    <#
    .SYNOPSIS
    Invokes dotfiles script
    #>

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
    <#
    .SYNOPSIS
    Installs WSL distro
    #>

    param (
        [string]$Distro
    )

    Write-ColoredMessage "Installing WSL ($Distro)..." 'purple'

    wsl --install --distribution $Distro

    Write-ColoredMessage 'Installation complete' 'green'
}

# Main execution logic
try {
    Confirm-SubCommand -Command $Command -SubCommand $SubCommand -ValidSubCommands $validSubCommands
    Confirm-DirectoryExists -Path "$HOME\pr"
    Confirm-DirectoryExists -Path "$HOME\wk"

    switch ($Command) {
        'drivers' {
            Invoke-GetDrivers -Type $SubCommand
        }
        'fonts' {
            Invoke-InstallFonts
        }
        'ctt' {
            Invoke-CTT
        }
        'apps' {
            Invoke-InstallApps -Type $SubCommand
        }
        'psmods' {
            Invoke-InstallPSModules
        }
        'dots' {
            Invoke-DotfilesScript
        }
        'wsl' {
            Invoke-InstallWSL -Distro $SubCommand
        }
        'help' {
            Show-Help
        }
        default {
            Show-Help
        }
    }
} catch {
    throw "Error in line $($_.InvocationInfo.ScriptLineNumber): $($_.Exception.Message)"
} finally {
    $ErrorActionPreference = $errAction
}
