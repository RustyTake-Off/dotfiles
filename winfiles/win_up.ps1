<#

.NOTES
  Author: RustyTake-Off
  GitHub: https://github.com/RustyTake-Off/dotfiles/tree/main/winfiles

.SYNOPSIS
  The script "win_up.ps1" automates the download and installation of drivers, applications, PowerShell modules, and configuration files on Windows. It provides various actions that can be executed individually. These actions include downloading drivers, invoking the CTT - winutil from christitus.com, installing applications using the winget package manager, installing PowerShell modules using Install-Module cmdlet, and downloading configuration and settings files.

.DESCRIPTION
  This PowerShell script automates the process of downloading and installing
  drivers, applications, PowerShell modules, and configuration files on Windows.
  It provides several actions that can be performed individually,
  such as downloading drivers, invoking the CTT - winutil, installing applications,
  installing PowerShell modules, and downloading configuration and settings files.

  Run this command to set the execution policy:
  PS> Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

  Download the script by executing the following command and saving it to your machine:

  PS> Invoke-WebRequest -Uri "https://github.com/RustyTake-Off/dotfiles/raw/main/winfiles/win_up.ps1" -OutFile "$env:USERPROFILE\win_up.ps1"

  The available actions are:
  - drivers: Downloads drivers.
  - ctt: Invokes the CTT - winutil by downloading and executing a script from christitus.com.
  - apps: Installs applications by downloading a list from a JSON file and using the winget package manager.
  - psmods: Installs PowerShell modules by downloading a list from a JSON file and using the Install-Module cmdlet.
  - configs: Downloads configuration and settings files and places them in the appropriate locations.

  It is recommended to execute the actions in the following order:
  1. drivers
  2. ctt
  3. apps
  4. psmods
  5. configs

  Note: It is crucial to review the code before execution, especially when it involves
  downloading and executing scripts from external sources, to ensure security and understanding
  of the actions being performed.

#>


param (
  [Parameter(Mandatory = $false, Position = 0)]
  [string]$action
)


function Get-WinupDriver {
  Write-Host "`nDownloading drivers..." -ForegroundColor Yellow

  $driversPath = Join-Path $Env:USERPROFILE 'Downloads\winup\drivers'

  if (-not (Test-Path -Path $driversPath -PathType Container)) {
    Write-Host 'Creating ' -NoNewline -ForegroundColor Yellow; Write-Host "'drivers' " -NoNewline -ForegroundColor Blue; Write-Host 'folder...' -ForegroundColor Yellow
    New-Item -Path $driversPath -ItemType Directory | Out-Null
  }

  $driversJsonPath = Join-Path $driversPath 'drivers.json'
  $driversUrl = 'https://raw.githubusercontent.com/RustyTake-Off/dotfiles/main/winfiles/files/drivers.json'

  Write-Host 'Downloading ' -NoNewline -ForegroundColor Yellow; Write-Host 'drivers.json ' -NoNewline -ForegroundColor Blue; Write-Host 'file...' -ForegroundColor Yellow
  Invoke-WebRequest -Uri $driversUrl -OutFile $driversJsonPath

  $driversJson = Get-Content -Raw -Path $driversJsonPath | ConvertFrom-Json

  foreach ($driverUrl in $driversJson.drivers) {
    Write-Host 'Downloading ' -NoNewline; Write-Host "$driverUrl" -ForegroundColor Blue
    $outputFileName = Split-Path -Leaf $driverUrl
    $outputFilePath = Join-Path $driversPath $outputFileName
    Start-BitsTransfer -Source $driverUrl -Destination $outputFilePath
  }

  Write-Host "Download of drivers completed!`n" -ForegroundColor Green

  # --------------------
  # fonts
  $fontsPath = Join-Path $Env:USERPROFILE 'Downloads\winup\fonts'
  $fontsFilePath = Join-Path $fontsPath 'fonts.zip'

  if (-not (Test-Path -Path $fontsPath -PathType Container)) {
    Write-Host 'Creating ' -NoNewline -ForegroundColor Yellow; Write-Host "'fonts' " -NoNewline -ForegroundColor Blue; Write-Host 'folder...' -ForegroundColor Yellow
    New-Item -Path $fontsPath -ItemType Directory | Out-Null
  }

  $fontsUrl = 'https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaCode.zip'

  Write-Host 'Downloading ' -NoNewline -ForegroundColor Yellow; Write-Host 'fonts ' -NoNewline -ForegroundColor Blue; Write-Host 'file...' -ForegroundColor Yellow
  Invoke-WebRequest -Uri $fontsUrl -OutFile $fontsFilePath

  Write-Host 'Extracting ' -NoNewline -ForegroundColor Yellow; Write-Host 'fonts.zip ' -NoNewline -ForegroundColor Blue; Write-Host 'file...' -ForegroundColor Yellow
  Expand-Archive -Path $fontsFilePath -DestinationPath $fontsPath -Force
  Remove-Item -Path $fontsFilePath

  Write-Host "Download of fonts completed!`n" -ForegroundColor Green
}


function Invoke-WinupCTT {
  Write-Host "`nInvoking CTT - winutil..." -ForegroundColor Yellow

  Invoke-WebRequest -useb https://christitus.com/win | Invoke-Expression

  Write-Host "`nInvoke of winutil completed!`n" -ForegroundColor Green
}


function Get-WinupApp {
  Write-Host "`nInstalling applications..." -ForegroundColor Yellow

  $appsPath = Join-Path $Env:USERPROFILE 'Downloads\winup'

  if (-not (Test-Path -Path $appsPath -PathType Container)) {
    Write-Host 'Creating ' -NoNewline -ForegroundColor Yellow; Write-Host "'winup' " -NoNewline -ForegroundColor Blue; Write-Host 'folder...' -ForegroundColor Yellow
    New-Item -Path $appsPath -ItemType Directory | Out-Null
  }

  $appsJsonPath = Join-Path $appsPath 'apps.json'
  $appsUrl = 'https://raw.githubusercontent.com/RustyTake-Off/dotfiles/main/winfiles/files/apps.json'

  Write-Host 'Downloading ' -NoNewline -ForegroundColor Yellow; Write-Host 'apps.json ' -NoNewline -ForegroundColor Blue; Write-Host 'file...' -ForegroundColor Yellow
  Invoke-WebRequest -Uri $appsUrl -OutFile $appsJsonPath

  $appsJson = Get-Content -Raw -Path $appsJsonPath | ConvertFrom-Json

  foreach ($appName in $appsJson.apps) {
    if (-not (winget list --exact --id $appName)) {
      Write-Host 'Installing ' -NoNewline; Write-Host "$appName" -ForegroundColor Blue
      winget install --exact --id $appName --source winget --silent --accept-package-agreements --accept-source-agreements
    } else {
      Write-Host "$appName " -ForegroundColor Blue -NoNewline; Write-Host 'is already installed. ' -NoNewline; Write-Host 'Skipping installation...' -ForegroundColor Red
    }
  }

  Write-Host "Installation of applications completed!`n" -ForegroundColor Green
}


function Get-WinupPSModule {
  Write-Host "`nInstalling PowerShell modules..." -ForegroundColor Yellow

  $psModsPath = Join-Path $Env:USERPROFILE 'Downloads\winup'

  if (-not (Test-Path -Path $psModsPath -PathType Container)) {
    Write-Host 'Creating ' -NoNewline -ForegroundColor Yellow; Write-Host "'winup' " -NoNewline -ForegroundColor Blue; Write-Host 'folder...' -ForegroundColor Yellow
    New-Item -Path $psModsPath -ItemType Directory | Out-Null
  }

  $psmodulesJsonPath = Join-Path $psModsPath 'psmodules.json'
  $psmodulesUrl = 'https://raw.githubusercontent.com/RustyTake-Off/dotfiles/main/winfiles/files/psmodules.json'

  Write-Host 'Downloading ' -NoNewline -ForegroundColor Yellow; Write-Host 'psmodules.json ' -NoNewline -ForegroundColor Blue; Write-Host 'file...' -ForegroundColor Yellow
  Invoke-WebRequest -Uri $psmodulesUrl -OutFile $psmodulesJsonPath

  $psmodulesJson = Get-Content -Raw -Path $psmodulesJsonPath | ConvertFrom-Json

  foreach ($psModsName in $psmodulesJson.psmodules) {
    if (-not (Get-Module -ListAvailable -Name $psModsName)) {
      Write-Host 'Installing ' -NoNewline; Write-Host "$psModsName" -ForegroundColor Blue
      Install-Module -Name $psModsName -Repository PSGallery -Force -AcceptLicense
    } else {
      Write-Host "$psModsName " -ForegroundColor Blue -NoNewline; Write-Host 'is already installed. ' -NoNewline; Write-Host 'Skipping installation...' -ForegroundColor Red
    }
  }

  Write-Host "Installation of PowerShell modules completed!`n" -ForegroundColor Green
}


function Set-WinupConfig {
  Write-Host "`nSetting configuration files in all the right places..." -ForegroundColor Yellow

  # --------------------
  # winget settings
  $wingetSettingsPath = Join-Path $Env:LOCALAPPDATA '\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState'
  $wingetSettingsFilePath = Join-Path $wingetSettingsPath 'settings.json'
  $wingetSettingsContent = Get-Content -Raw -Path $wingetSettingsFilePath | ConvertFrom-Json

  if ($wingetSettingsContent.visual.progressBar -eq 'rainbow') {
    $wingetUrl = 'https://raw.githubusercontent.com/RustyTake-Off/dotfiles/main/winfiles/files/winget.json'

    Write-Host 'Downloading ' -NoNewline -ForegroundColor Yellow; Write-Host 'winget.json ' -NoNewline -ForegroundColor Blue; Write-Host 'file...' -ForegroundColor Yellow
    Invoke-WebRequest -Uri $wingetUrl -OutFile $wingetSettingsPath\settings.json

    Write-Host 'Creating ' -NoNewline -ForegroundColor Yellow; Write-Host 'winget settings.json.backup ' -NoNewline -ForegroundColor Blue; Write-Host 'file...' -ForegroundColor Yellow
    Copy-Item -Path $wingetSettingsFilePath -Destination $wingetSettingsPath\settings.json.backup
  } else {
    Write-Host 'Winget ' -ForegroundColor Blue -NoNewline; Write-Host 'settings are already applied properly. ' -NoNewline; Write-Host 'Skipping...' -ForegroundColor Red
  }

  # --------------------
  # images for windows-terminal
  $imagesPath = Join-Path $env:USERPROFILE '\shared\images'
  $imagesFilePath = Join-Path $imagesPath '\images.zip'

  if (-not (Test-Path -Path $imagesPath -PathType Container)) {
    Write-Host 'Creating ' -NoNewline -ForegroundColor Yellow; Write-Host "'images' " -NoNewline -ForegroundColor Blue; Write-Host 'folder...' -ForegroundColor Yellow
    New-Item -Path $imagesPath -ItemType Directory | Out-Null
  }

  $imagesUrl = 'https://github.com/RustyTake-Off/dotfiles/raw/main/winfiles/files/images/images.zip'

  Write-Host 'Downloading ' -NoNewline -ForegroundColor Yellow; Write-Host 'images.zip ' -NoNewline -ForegroundColor Blue; Write-Host 'file...' -ForegroundColor Yellow
  Invoke-WebRequest -Uri $imagesUrl -OutFile $imagesPath\images.zip

  Write-Host 'Extracting ' -NoNewline -ForegroundColor Yellow; Write-Host 'images.zip ' -NoNewline -ForegroundColor Blue; Write-Host 'file...' -ForegroundColor Yellow
  Expand-Archive -Path $imagesFilePath -DestinationPath $imagesPath -Force
  Remove-Item -Path $imagesFilePath

  # --------------------
  # windows-terminal settings
  $winTerminalSettingsPath = Join-Path $env:LOCALAPPDATA '\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState'
  $winTerminalUrl = 'https://raw.githubusercontent.com/RustyTake-Off/dotfiles/main/winfiles/files/windows-terminal.json'

  Write-Host 'Downloading ' -NoNewline -ForegroundColor Yellow; Write-Host 'windows-terminal.json ' -NoNewline -ForegroundColor Blue; Write-Host 'file...' -ForegroundColor Yellow
  Invoke-WebRequest -Uri $winTerminalUrl -OutFile $winTerminalSettingsPath\settings.json

  # --------------------
  # powershell profiles
  $powershellProfileFilePath = Join-Path $env:USERPROFILE '\Documents\PowerShell'

  if (-not (Test-Path -Path $powershellProfileFilePath -PathType Container)) {
    Write-Host 'Creating ' -NoNewline -ForegroundColor Yellow; Write-Host "'PowerShell' " -NoNewline -ForegroundColor Blue; Write-Host 'folder...' -ForegroundColor Yellow
    New-Item -Path $powershellProfileFilePath -ItemType Directory | Out-Null
  }

  $powershellMSUrl = 'https://raw.githubusercontent.com/RustyTake-Off/dotfiles/main/winfiles/files/Microsoft.PowerShell_profile.ps1'
  $powershellVSUrl = 'https://raw.githubusercontent.com/RustyTake-Off/dotfiles/main/winfiles/files/Microsoft.VSCode_profile.ps1'

  Write-Host 'Downloading ' -NoNewline -ForegroundColor Yellow; Write-Host 'Microsoft.PowerShell_profile.ps1 ' -NoNewline -ForegroundColor Blue; Write-Host 'file...' -ForegroundColor Yellow
  Invoke-WebRequest -Uri $powershellMSUrl -OutFile $powershellProfileFilePath\Microsoft.PowerShell_profile.ps1

  Write-Host 'Downloading ' -NoNewline -ForegroundColor Yellow; Write-Host 'Microsoft.VSCode_profile.ps1 ' -NoNewline -ForegroundColor Blue; Write-Host 'file...' -ForegroundColor Yellow
  Invoke-WebRequest -Uri $powershellVSUrl -OutFile $powershellProfileFilePath\Microsoft.VSCode_profile.ps1

  Write-Host "Configuration files placement completed!`n" -ForegroundColor Green
}


switch ($action) {
  'drivers' {
    Get-WinupDriver
  }
  'ctt' {
    Invoke-WinupCTT
  }
  'apps' {
    Get-WinupApp
  }
  'psmods' {
    Get-WinupPSModule
  }
  'configs' {
    Set-WinupConfig
  }
  default {
    Write-Host "
`rAvailable actions to take:
  drivers     - Downloads drivers
  ctt         - Invokes the CTT - winutil
  apps        - Installs applications
  psmods      - Installs PowerShell modules
  configs     - Download configuration and settings files
"
  }
}
