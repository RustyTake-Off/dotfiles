# ╒══════╗        ╒═══════╗
# │ ╓──┐ ║════════╗  ╓─┐  ║
# │ ╚══╛ ║──┐  ╓──╜  ║ │  ║  RustyTake-Off
# │ ╓─┐ ╓╜  │  ║  │  ║ │  ║  https://github.com/RustyTake-Off
# │ ║ │ ╚╗  │  ║  │  ╚═╛  ║
# └─╜ └──╜  └──╜  └───────╜
# WinUp - script for setting up Windows.

#Requires -RunAsAdministrator

<#
.SYNOPSIS
Script for setting up Windows.

.DESCRIPTION
This script makes the configuration of a Windows environment easier and more convenient by downloading drivers,
installing fonts, applications, and PowerShell modules.

.NOTES
You might want to not change the Execution Policy permanently so to change it only for the current process
run the bellow command and then run the script.
PS> Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process

To change Execution Policy permanently run bellow command which only allows trusted publishers.
PS> Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

This script also needs to be run from elevated terminal as admin.

.EXAMPLE
Use-WinUp.ps1 -Command help
Prints help message

.EXAMPLE
Use-WinUp.ps1 -Command drivers -SubCommand min
Downloads minimum needed drivers

.EXAMPLE
Use-WinUp.ps1 -Command drivers -SubCommand all
Downloads all drivers

.EXAMPLE
Use-WinUp.ps1 -Command fonts
Downloads and installs fonts

.EXAMPLE
Use-WinUp.ps1 -Command ctt
Invokes the CTT - winutil script

.EXAMPLE
Use-WinUp.ps1 -Command apps -SubCommand base
Installs base applications

.EXAMPLE
Use-WinUp.ps1 -Command apps -SubCommand util
Installs utility applications

.EXAMPLE
Use-WinUp.ps1 -Command psmods
Installs PowerShell modules

.EXAMPLE
Use-WinUp.ps1 -Command dots
Invokes Dotfiles setup script

.EXAMPLE
Use-WinUp.ps1 -Command wsl -SubCommand Ubuntu-22.04
Installs Ubuntu-22.04 on WSL

.LINK
Repository      -   "https://github.com/RustyTake-Off/win-dotfiles",
Config file     -   "https://github.com/RustyTake-Off/win-dotfiles/blob/main/.config/config.json",
Script file     -   "https://github.com/RustyTake-Off/win-dotfiles/blob/main/.config/scripts/Use-WinUp.ps1"
#>

[CmdletBinding(SupportsShouldProcess)]

param (
    [Parameter(Mandatory = $false, Position = 0)]
    [ValidateSet('drivers', 'fonts', 'ctt', 'psmods', 'apps', 'dots', 'wsl', 'help')]
    [Alias('-c')]
    [String] $Command,

    [Parameter(Mandatory = $false, Position = 1)]
    [ValidateSet('min', 'all', 'base', 'util', 'Debian', 'Ubuntu-22.04', 'Ubuntu-20.04', 'kali-linux', 'help')]
    [Alias('-s')]
    [String] $SubCommand
)

# ================================================================================
# Main variables

$WinUpPath = "$env:USERPROFILE\Desktop\winup"
$ConfigPath = "$env:USERPROFILE\.config"
$RepositoryConfigUrl = 'https://raw.githubusercontent.com/RustyTake-Off/win-dotfiles/main/.config'

if (Test-Path -Path "$ConfigPath\config.json") {
    $WinUpConfig = Get-Content -Path "$ConfigPath\config.json" | ConvertFrom-Json
} else {
    try {
        $WinUpConfig = Invoke-RestMethod -Uri "$RepositoryConfigUrl/config.json"
    } catch {
        Write-Error "Error fetching config setup file: $_"
        Write-Error "Line: $($_.ScriptStackTrace)"
        Exit
    }
}

# ================================================================================
# Helper variables

$UserAgent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Safari/537.36'

# ================================================================================
# Miscellaneous code

if (-not (Test-Path -Path "$env:USERPROFILE\pr" -PathType Container)) {
    Write-Output "Creating 'personal' folder"
    $null = New-Item -Path "$env:USERPROFILE\pr" -ItemType Directory
}

if (-not (Test-Path -Path "$env:USERPROFILE\wk" -PathType Container)) {
    Write-Output "Creating 'work' folder"
    $null = New-Item -Path "$env:USERPROFILE\wk" -ItemType Directory
}

# ================================================================================
# Helper functions

function Get-Help {
    <#
    .DESCRIPTION
    Help message.
    #>

    process {
        Write-Host 'Available commands:' -ForegroundColor Green
        Write-Host @'
    help        -   Prints help message
    drivers
    :   min     -   Downloads minimum needed drivers
    :   all     -   Downloads all drivers
    fonts       -   Downloads and installs fonts
    ctt         -   Invokes the CTT - winutil script
    apps
    :   base    -   Installs base applications
    :   util    -   Installs utility applications
    psmods      -   Installs PowerShell modules
    dots        -   Invokes Dotfiles setup script
    wsl
    :   Debian          -   Installs Debian on WSL
    :   Ubuntu-22.04    -   Installs Ubuntu-22.04 on WSL
    :   Ubuntu-20.04    -   Installs Ubuntu-20.04 on WSL
    :   kali-linux      -   Installs kali-linux on WSL
'@
    }
}

function Set-Directory {
    <#
    .DESCRIPTION
    Creates new directory.
    #>

    param (
        [Parameter(Mandatory = $true)]
        [String] $DirectoryPath
    )

    process {
        try {
            Write-Host 'Creating ' -NoNewline; Write-Host "$DirectoryPath ..." -ForegroundColor Blue
            New-Item -Path $DirectoryPath -ItemType Directory -ErrorAction SilentlyContinue > $null
        } catch {
            Write-Error "Failed to create $DirectoryPath"
            Write-Error "Line: $($_.ScriptStackTrace)"
        }
    }
}

function Invoke-Download {
    <#
    .DESCRIPTION
    Invokes download.
    #>

    param (
        [Parameter(Mandatory = $true)]
        [String] $Url,

        [Parameter(Mandatory = $true)]
        [String] $DirectoryPath
    )

    process {
        $FileName = Split-Path -Path $Url -Leaf
        $DownloadPath = Join-Path -Path $DirectoryPath -ChildPath $FileName

        try {
            Write-Host 'Downloading ' -NoNewline; Write-Host "$Url ..." -ForegroundColor Blue
            Invoke-WebRequest -Uri $Url -UserAgent $UserAgent -OutFile $DownloadPath -ErrorAction SilentlyContinue
        } catch {
            Write-Error "Failed to download $FileName"
            Write-Error "Line: $($_.ScriptStackTrace)"
        }
    }
}

function Install-Fonts {
    <#
    .DESCRIPTION
    Installs TrueType (.ttf) or OpenType (.otf) fonts, copying them to the system fonts directory and registering
    them in the Registry.
    #>

    param (
        [Parameter(Mandatory = $true)]
        [System.IO.FileInfo]
        [Object] $FontFile
    )

    process {
        try {
            $FontsGTF = [Windows.Media.GlyphTypeface]::New($FontFile.FullName)

            $Family = $FontsGTF.Win32FamilyNames['en-US']
            if ($null -eq $Family) {
                $Family = $FontsGTF.Win32FamilyNames.Values.Item(0)
            }

            $Face = $FontsGTF.Win32FaceNames['en-US']
            if ($null -eq $Face) {
                $Face = $FontsGTF.Win32FaceNames.Values.Item(0)
            }

            $FontName = ("$Family $Face").Trim()
            switch ($FontFile.Extension) {
                '.ttf' {
                    $FontName = "$FontName (TrueType)"
                }
                '.otf' {
                    $FontName = "$FontName (OpenType)"
                }
            }

            Write-Host 'Installing ' -NoNewline; Write-Host "$FontName ..." -ForegroundColor Blue
            if (-not (Test-Path (Join-Path -Path "$env:SystemRoot\fonts" -ChildPath $FontFile.Name))) {
                Write-Host "Copying $FontName ..."
                Copy-Item -Path $FontFile.FullName -Destination (Join-Path -Path "$env:SystemRoot\fonts" -ChildPath $FontFile.Name) -Force
            } else {
                Write-Host "Font already exists: $FontName"
            }

            if (-not (Get-ItemProperty -Name $FontName -Path 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts' -ErrorAction SilentlyContinue)) {
                Write-Host "Registering $FontName ..."
                New-ItemProperty -Name $FontName -Path 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts' -PropertyType String -Value $FontFile.Name -Force -ErrorAction SilentlyContinue > $null
            } else {
                Write-Host "Font already registered: $FontName"
            }
        } catch {
            Write-Error "Error installing $FontName"
            Write-Error "Line: $($_.ScriptStackTrace)"
        }
    }
}

# ================================================================================
# Main code

function Invoke-GetDrivers {
    <#
    .DESCRIPTION
    Downloads drivers.
    #>

    param (
        [Parameter(Mandatory = $true)]
        [ValidateSet('min', 'all')]
        [String] $Type
    )

    $DriversPath = Join-Path -Path $WinUpPath -ChildPath 'drivers'
    if (-not (Test-Path -Path $DriversPath)) {
        Set-Directory -DirectoryPath $DriversPath
    }

    Write-Host 'Downloading drivers ...' -ForegroundColor Green
    foreach ($DriverUrl in $WinUpConfig.drivers.$Type) {
        Invoke-Download -DirectoryPath $DriversPath -Url $DriverUrl
    }
    Write-Host 'Download complete!' -ForegroundColor Green
}

function Invoke-InstallFonts {
    <#
    .DESCRIPTION
    Downloads and installs fonts.
    #>

    $FontsPath = Join-Path $WinUpPath 'fonts'
    if (-not (Test-Path -Path $FontsPath)) {
        Set-Directory -DirectoryPath $FontsPath
    }

    Write-Host 'Downloading fonts ...' -ForegroundColor Green
    foreach ($FontUrl in $WinUpConfig.fonts) {
        Invoke-Download -DirectoryPath $FontsPath -Url $FontUrl
    }
    Write-Host 'Download complete!' -ForegroundColor Green

    $FontsZipFiles = Get-ChildItem -Path $FontsPath -Filter '*.zip'

    Write-Host 'Extracting fonts ...' -ForegroundColor Green
    foreach ($ZipFile in $FontsZipFiles) {
        $ExtractionDirectoryPath = Join-Path -Path $FontsPath -ChildPath $($ZipFile.BaseName)
        Set-Directory -DirectoryPath $ExtractionDirectoryPath

        Write-Host 'Extracting ' -NoNewline; Write-Host $ZipFile.Name -ForegroundColor Blue -NoNewline; Write-Host ' to ' -NoNewline; Write-Host $ExtractionDirectoryPath -ForegroundColor Blue
        Expand-Archive -Path $ZipFile.FullName -DestinationPath $ExtractionDirectoryPath -Force
        Remove-Item -Path $ZipFile.FullName -Force
        Write-Host 'Extraction complete!' -ForegroundColor Green

        Write-Host "Installing fonts $($ZipFile.BaseName) ..." -ForegroundColor Green
        $Fonts = Get-ChildItem -Path $ExtractionDirectoryPath | Where-Object { ($_.Name -like '*.ttf') -or ($_.Name -like '*.otf') }
        Add-Type -AssemblyName PresentationCore
        foreach ($FontItem in $Fonts) {
            Install-Fonts -FontFile $FontItem.FullName
        }
        Write-Host "Installation of $($ZipFile.BaseName) complete!" -ForegroundColor Green
    }
}

function Invoke-CTT {
    <#
    .DESCRIPTION
    Invokes the "CTT - winutil" utility by https://github.com/ChrisTitusTech.
    #>

    Write-Host 'Invoking CTT - winutil ...' -ForegroundColor Green
    try {
        Invoke-WebRequest 'https://christitus.com/win' -UseBasicParsing | Invoke-Expression
    } catch {
        Write-Error 'Failed to invoke CTT - winutil'
        Write-Error "Line: $($_.ScriptStackTrace)"
    }
    Write-Host 'Invoke complete!' -ForegroundColor Green
}

function Get-Apps {
    <#
    .DESCRIPTION
    Installs some essential applications with winget.
    #>

    param (
        [Parameter(Mandatory = $true)]
        [ValidateSet('base', 'util')]
        [String] $Type
    )

    if (Get-Command winget) {
        $null = winget list --accept-source-agreements
    } else {
        Write-Error -Message 'Winget is not installed'
        Exit
    }
    Write-Host 'Installing applications ...' -ForegroundColor Green
    foreach ($App in $WinUpConfig.apps.$Type) {
        if ($App.source -eq 'winget') {
            if (-not (winget list --exact --id $App.name | Select-String -SimpleMatch $App.name)) {
                Write-Host 'Installing ' -NoNewline; Write-Host "$($App.name) ($($App.source)) ..." -ForegroundColor Blue
                Start-Process winget -ArgumentList "install --exact --id $($App.name) --source $($App.source) $($App.args) --accept-package-agreements --accept-source-agreements" -NoNewWindow -Wait
            } else {
                Write-Host 'App is already installed: ' -NoNewline; Write-Host "$($App.name) ($($App.source))" -ForegroundColor Blue
            }
        } elseif ($App.source -eq 'msstore') {
            if (-not (winget list --exact --id $App.id | Select-String -SimpleMatch $App.id)) {
                Write-Host 'Installing ' -NoNewline; Write-Host "$($App.id) ($($App.name))($($App.source)) ..." -ForegroundColor Blue
                Start-Process winget -ArgumentList "install --exact --id $($App.id) --source $($App.source) $($App.args) --accept-package-agreements --accept-source-agreements" -NoNewWindow -Wait
            } else {
                Write-Host 'App is already installed: ' -NoNewline; Write-Host "$($App.name) ($($App.id))($($App.source))" -ForegroundColor Blue
            }
        }
    }
    Write-Host 'Installation complete!' -ForegroundColor Green
}

function Get-PSModules {
    <#
    .DESCRIPTION
    Installs or updates PowerShell modules.
    #>

    Write-Host 'Installing Powershell modules ...' -ForegroundColor Green
    if (-not (Get-PackageProvider | Select-String -SimpleMatch NuGet)) {
        Install-PackageProvider -Name NuGet
    }
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
    foreach ($Module in $WinUpConfig.psmodules) {
        Write-Host 'Installing ' -NoNewline; Write-Host "$Module ..." -ForegroundColor Blue
        Install-Module -Name $Module -Repository PSGallery -Force
    }
    Set-PSRepository -Name PSGallery -InstallationPolicy Untrusted
    Write-Host 'Installation complete!' -ForegroundColor Green
}

function Invoke-DotfilesScript {
    <#
    .DESCRIPTION
    Invokes the Dotfiles setup script.
    #>

    Write-Host 'Invoking Dotfiles setup script ...' -ForegroundColor Green
    try {
        if (Test-Path -Path "$ConfigPath\scripts\Set-Dotfiles.ps1") {
            Invoke-Expression "$ConfigPath\scripts\Set-Dotfiles.ps1"
        } else {
            (Invoke-WebRequest -Uri "$RepositoryConfigUrl/scripts/Set-Dotfiles.ps1" -UseBasicParsing).Content | Invoke-Expression
        }
    } catch {
        Write-Error 'Failed to invoke Dotfiles setup script'
        Write-Error "Line: $($_.ScriptStackTrace)"
    }
    Write-Host 'Invoke complete!' -ForegroundColor Green
}

function Install-WSL {
    <#
    .DESCRIPTION
    Installs Windows Subsystem for Linux with different distributions.
    #>

    param (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Debian', 'Ubuntu-22.04', 'Ubuntu-20.04', 'kali-linux')]
        [String] $Distribution
    )

    Write-Host 'Invoking Dotfiles setup script ...' -ForegroundColor Green
    try {
        wsl --install --distribution $Distribution
    } catch {
        Write-Error 'Failed to invoke Dotfiles setup script'
        Write-Error "Line: $($_.ScriptStackTrace)"
    }
    Write-Host 'Invoke complete!' -ForegroundColor Green
}

# Switch with possible commands
switch ($Command) {
    'drivers' {
        switch ($SubCommand) {
            'min' {
                Invoke-GetDrivers -Type $SubCommand
            }
            'all' {
                Invoke-GetDrivers -Type $SubCommand
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
        switch ($SubCommand) {
            'base' {
                Get-Apps -Type $SubCommand
            }
            'util' {
                Get-Apps -Type $SubCommand
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
        switch ($SubCommand) {
            'Debian' {
                Install-WSL -Distribution $SubCommand
            }
            'Ubuntu-22.04' {
                Install-WSL -Distribution $SubCommand
            }
            'Ubuntu-20.04' {
                Install-WSL -Distribution $SubCommand
            }
            'kali-linux' {
                Install-WSL -Distribution $SubCommand
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
