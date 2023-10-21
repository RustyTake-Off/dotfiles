<#
.SYNOPSIS
This script automates various system configuration tasks on a Windows system.

.DESCRIPTION
This PowerShell script provides a set of functions and options to perform
various system configuration tasks, such as downloading drivers, installing
fonts, setting up configurations, and more, based on the content of a JSON
configuration file under this link:
https://github.com/RustyTake-Off/dotfiles/blob/main/winfiles/files/config.json

Run this command to set the execution policy:
    PS> Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

.PARAMETER Action
Specifies the action to perform. Choose from the following options:
-   drivers: Downloads drivers specified in the JSON configuration file.
-   fonts: Downloads and installs fonts specified in the JSON configuration
    file.
-   apps: Installs some base applications using the Windows Package Manager
    (winget).
-   psmods: Installs PowerShell modules from the PowerShell Gallery.
-   ctt: Invokes a script for Windows optimization (CTT - winutil).
-   configs: Sets up configurations for various applications.

.EXAMPLE
    PS> .\winup.ps1 -Action fonts

.EXAMPLE
    PS> .\winup.ps1 -Action psmods

.EXAMPLE
    PS> .\winup.ps1 -Action ctt

.NOTES
Make sure to understand and review the code before executing it, especially
when downloading and executing scripts from external sources.
#>

[CmdletBinding()]

param (
    [Parameter(Mandatory = $false, Position = 0)]
    [String]
    $Action
)

# ================================================================================
# Main variables
$WinupFolderPath = Join-Path -Path $env:USERPROFILE\Desktop -ChildPath 'winup'
$WinfilesUrl = 'https://raw.githubusercontent.com/RustyTake-Off/dotfiles/main/winfiles/files'
$JsonConfigContent = Invoke-WebRequest -Uri "$WinfilesUrl/config.json" | ConvertFrom-Json
$ImagesZipUrl = 'https://github.com/RustyTake-Off/dotfiles/raw/main/genfiles/media/images.zip'

# ================================================================================
# Misc variables
$UserAgent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Safari/537.36'

# ================================================================================
# Misc functions
function Get-WUPFolder {
    param (
        [Parameter(Mandatory = $true)]
        [String]
        $FolderPath
    )

    process {
        try {
            if (-not (Test-Path -Path $FolderPath -PathType Container)) {
                Write-Host 'Creating ' -NoNewline; Write-Host "$FolderPath..." -ForegroundColor Blue
                New-Item -Path $FolderPath -ItemType Directory -ErrorAction SilentlyContinue > $null
            }
        } catch {
            Write-Host "Failed to create $FolderPath" -ForegroundColor Red
            Write-Host $_.Exception.Message -ForegroundColor Red
        }
    }
}

function Invoke-WUPDownload {
    param (
        [Parameter(Mandatory = $true)]
        [String]
        $DriverUrl,

        [Parameter(Mandatory = $true)]
        [String]
        $FolderPath
    )

    process {
        $FileName = Split-Path -Path $DriverUrl -Leaf
        $DownloadPath = Join-Path $FolderPath $FileName

        try {
            Write-Host 'Downloading ' -NoNewline; Write-Host "$DriverUrl..." -ForegroundColor Blue
            Invoke-WebRequest -Uri $DriverUrl -UserAgent $UserAgent -OutFile $DownloadPath -ErrorAction SilentlyContinue
        } catch {
            Write-Host "Failed to download $FileName" -ForegroundColor Red
            Write-Host $_.Exception.Message -ForegroundColor Red
        }
    }
}

function Install-WUPFont {
    param (
        [Parameter(Mandatory = $true)]
        [Object]
        [System.IO.FileInfo]
        $FontFile
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

            Write-Host 'Installing ' -NoNewline; Write-Host "$FontName..." -ForegroundColor Blue

            if (!(Test-Path (Join-Path -Path "$env:SystemRoot\fonts" -ChildPath $FontFile.Name))) {
                Write-Host "Copying $FontName..."
                Copy-Item -Path $FontFile.FullName -Destination (Join-Path -Path "$env:SystemRoot\fonts" -ChildPath $FontFile.Name) -Force
            } else {
                Write-Host "Font already exists: $FontName"
            }

            if (!(Get-ItemProperty -Name $FontName -Path 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts' -ErrorAction SilentlyContinue)) {
                Write-Host "Registering $FontName..."
                New-ItemProperty -Name $FontName -Path 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts' -PropertyType String -Value $FontFile.Name -Force -ErrorAction SilentlyContinue > $null
            } else {
                Write-Host "Font already registered: $FontName"
            }

        } catch {
            Write-Host "Error installing $FontName" -ForegroundColor Red
            Write-Host $_.Exception.Message -ForegroundColor Red
        }
    }
}

# ================================================================================
# Main functions
function Get-WUPDrivers {
    <#
    .SYNOPSIS
    Downloads drivers.

    .DESCRIPTION
    This function downloads drivers using Invoke-WebRequest. It reads a JSON file
    containing a list of driver URLs and downloads them to a specified folder.
    #>

    $DriversFolderPath = Join-Path $WinupFolderPath 'drivers'

    Get-WUPFolder -FolderPath $DriversFolderPath

    Write-Host 'Downloading drivers...' -ForegroundColor Green
    foreach ($DriverUrl in $JsonConfigContent.drivers) {
        Invoke-WUPDownload -FolderPath $DriversFolderPath -DriverUrl $DriverUrl
    }
    Write-Host 'Download complete!' -ForegroundColor Green
}

function Install-WUPFonts {
    <#
    .SYNOPSIS
    Downloads and extracts fonts.

    .DESCRIPTION
    This function downloads and extracts fonts to a specified folders.
    #>

    $FontsFolderPath = Join-Path $WinupFolderPath 'fonts'

    Get-WUPFolder -FolderPath $fontsFolderPath

    Write-Host 'Downloading fonts...' -ForegroundColor Green
    foreach ($FontUrl in $JsonConfigContent.fonts) {
        Invoke-WUPDownload -FolderPath $FontsFolderPath -DriverUrl $FontUrl
    }
    Write-Host 'Download complete!' -ForegroundColor Green

    $ZipFiles = Get-ChildItem -Path $FontsFolderPath -Filter '*.zip'

    Write-Host 'Extracting fonts...' -ForegroundColor Green
    foreach ($ZipFile in $ZipFiles) {
        $BaseName = $ZipFile.BaseName
        $ExtractionFolderPath = Join-Path -Path $FontsFolderPath -ChildPath $BaseName

        Get-WUPFolder -FolderPath $ExtractionFolderPath

        Write-Host 'Extracting ' -NoNewline; Write-Host $ZipFile.Name -ForegroundColor Blue -NoNewline; Write-Host ' to ' -NoNewline; Write-Host $ExtractionFolderPath -ForegroundColor Blue
        Expand-Archive -Path $ZipFile.FullName -DestinationPath $ExtractionFolderPath -Force
        Remove-Item -Path $ZipFile.FullName -Force
        Write-Host 'Extraction complete!' -ForegroundColor Green

        Write-Host "Installing fonts $BaseName..." -ForegroundColor Green
        $Fonts = Get-ChildItem -Path $ExtractionFolderPath | Where-Object { ($_.Name -like '*.ttf') -or ($_.Name -like '*.otf') }
        Add-Type -AssemblyName PresentationCore
        foreach ($FontItem in $Fonts) {
            Install-WUPFont -FontFile $FontItem.FullName
        }
        Write-Host "Installation of $BaseName complete!" -ForegroundColor Green
    }
}

function Install-WUPApps {
    <#
    .SYNOPSIS
    Installs essential applications.

    .DESCRIPTION
    This function installs some essential applications with winget.
    #>

    Write-Host 'Installing applications...' -ForegroundColor Green
    foreach ($App in $JsonConfigContent.apps) {
        if (-not (winget list --exact --id $App)) {
            Write-Host 'Installing ' -NoNewline; Write-Host "$App..." -ForegroundColor Blue
            Start-Process -FilePath winget -ArgumentList "install --exact --id $App --silent --accept-package-agreements --accept-source-agreements" -NoNewWindow -Wait
        } else {
            Write-Host 'App is already installed: ' -NoNewline; Write-Host $App -ForegroundColor Blue
        }
    }
    Write-Host 'Installation complete!' -ForegroundColor Green
}

function Install-WUPPowerShellModules {
    <#
    .SYNOPSIS
    Installs Powershell modules.

    .DESCRIPTION
    This function installs some essential Powershell modules.
    #>

    Write-Host 'Installing Powershell modules...' -ForegroundColor Green
    foreach ($Module in $JsonConfigContent.psmodules) {
        if (-not (Get-Module -ListAvailable | Where-Object { $_.Name -like $Module })) {
            Write-Host 'Installing ' -NoNewline; Write-Host "$Module..." -ForegroundColor Blue
            Start-Process -FilePath Install-Module -ArgumentList "-Name $Module -Repository PSGallery -Force"
        } else {
            Write-Host 'Module is already installed: ' -NoNewline; Write-Host $Module -ForegroundColor Blue
            Write-Host 'Trying to update module: ' -NoNewline; Write-Host $Module -ForegroundColor Blue
            Update-Module -Name $Module -Force
        }
    }
    Write-Host 'Installation complete!' -ForegroundColor Green
}

function Invoke-WUPCtt {
    <#
    .SYNOPSIS
    Invokes the CTT - winutil script.

    .DESCRIPTION
    This function invokes the CTT - winutil script, which is designed to optimize
    Windows settings and performance.
    #>

    Write-Host 'Invoking CTT - winutil...' -ForegroundColor Green
    try {
        Invoke-WebRequest -useb 'https://christitus.com/win' | Invoke-Expression
    } catch {
        Write-Host 'Failed to invoke CTT - winutil' -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red
    }
    Write-Host 'Invoke complete!' -ForegroundColor Green
}

function Set-WUPConfigs {
    <#
    .SYNOPSIS
    Installs configurations.

    .DESCRIPTION
    This function installs some configurations for applications like Windows Terminal, Powershell...
    #>

    Write-Host 'Setting up configs...' -ForegroundColor Green

    # winget
    $WingetConfigPath = Join-Path -Path $env:LOCALAPPDATA -ChildPath '\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState'
    Write-Host 'Setting up ' -NoNewline; Write-Host 'Winget ' -ForegroundColor Blue -NoNewline; Write-Host 'config...'

    Get-WUPFolder -FolderPath $WingetConfigPath

    $JsonConfigContent.winget | ConvertTo-Json | Set-Content -Path (Join-Path -Path $WingetConfigPath -ChildPath 'settings.json')
    $JsonConfigContent.winget | ConvertTo-Json | Set-Content -Path (Join-Path -Path $WingetConfigPath -ChildPath 'settings.json.backup')

    # images for windows terminal
    $ImagesPath = Join-Path -Path $env:USERPROFILE -ChildPath '\media\images'
    Write-Host 'Setting up ' -NoNewline; Write-Host 'images...' -ForegroundColor Blue

    Get-WUPFolder -FolderPath $ImagesPath

    Invoke-WebRequest -Uri $ImagesZipUrl -OutFile "$ImagesPath\images.zip"
    Expand-Archive -Path "$ImagesPath\images.zip" -DestinationPath $imagesPath -Force
    Remove-Item -Path "$ImagesPath\images.zip"

    # windows terminal
    $WinTerminalConfigPath = Join-Path -Path $env:LOCALAPPDATA -ChildPath '\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState'
    Write-Host 'Setting up ' -NoNewline; Write-Host 'Windows Terminal ' -ForegroundColor Blue -NoNewline; Write-Host 'config...'

    Get-WUPFolder -FolderPath $WinTerminalConfigPath

    $JsonConfigContent.win_terminal | ConvertTo-Json -Depth 100 | Set-Content -Path (Join-Path -Path $WinTerminalConfigPath -ChildPath 'settings.json')

    # powershell profiles
    $PowershellProfileFilePath = Join-Path $env:USERPROFILE '\Documents\PowerShell'
    Write-Host 'Setting up ' -NoNewline; Write-Host 'Powershell ' -ForegroundColor Blue -NoNewline; Write-Host 'profiles...'

    Get-WUPFolder -FolderPath $PowershellProfileFilePath

    foreach ($PSProfileItem in @('PowerShell', 'VSCode')) {
        $PSProfile = 'Microsoft.' + $PSProfileItem + '_profile.ps1'
        Write-Host $PSProfileItem -ForegroundColor Blue -NoNewline; Write-Host 'profile...'
        Invoke-WebRequest -Uri "$WinfilesUrl/$PSProfile" -OutFile "$powershellProfileFilePath\$PSProfile"
    }

    # wsl config
    Write-Host 'Setting up ' -NoNewline; Write-Host 'WSL ' -ForegroundColor Blue -NoNewline; Write-Host 'config...'
    Invoke-WebRequest -Uri "$WinfilesUrl/.wslconfig" -OutFile $env:USERPROFILE

    Write-Host 'Done setting up configs!' -ForegroundColor Green
}

function Install-WUPVSCodeExtensions {
    <#
    .SYNOPSIS
    Installs VSCode extensions.

    .DESCRIPTION
    This function installs VSCode extensions.
    #>

    if (code --version) {
        Write-Host 'Installing VSCode extensions...' -ForegroundColor Green
        foreach ($Ext in $JsonConfigContent.vscode_ext) {
            if (-not (code --list-extensions | Select-String -Pattern $Ext)) {
                Write-Host 'Installing ' -NoNewline; Write-Host "$Ext..." -ForegroundColor Blue
                Start-Process -FilePath code -ArgumentList "--install-extension $Ext --force" -NoNewWindow -Wait
            } else {
                Write-Host 'Extension is already installed: ' -NoNewline; Write-Host $Ext -ForegroundColor Blue
            }
        }
        Write-Host 'Installation complete!' -ForegroundColor Green
    } else {
        Write-Host 'It looks like ' -NoNewline; Write-Host 'VSCode ' -ForegroundColor Blue -NoNewline; Write-Host 'is not installed.'
        exit
    }
}

switch ($Action) {
    'drivers' {
        Get-WUPDrivers
    }
    'fonts' {
        Install-WUPFonts
    }
    'apps' {
        Install-WUPApps
    }
    'psmods' {
        Install-WUPPowerShellModules
    }
    'ctt' {
        Invoke-WUPCtt
    }
    'configs' {
        Set-WUPConfigs
    }
    'code' {
        Install-WUPVSCodeExtensions
    }
    default {
        Write-Host 'Available actions to take:' -ForegroundColor Green
        Write-Host '
    drivers   -   Downloads drivers
    fonts     -   Downloads and installs fonts
    apps      -   Installs some base applications
    psmods    -   Installs PowerShell modules
    ctt       -   Invokes the CTT - winutil
    configs   -   Sets config files
    code      -   Installs VSCode extensions
            '
    }
}