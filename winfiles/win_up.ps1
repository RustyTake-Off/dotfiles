<#

.SYNOPSIS
    Script to automate the download and installation of drivers, applications,
    PowerShell modules, and configuration files on Windows.

.DESCRIPTION
    This PowerShell script automates the process of downloading and installing
    drivers, applications, PowerShell modules, and configuration files on Windows.
    It provides several actions that can be performed individually,
    such as downloading drivers, invoking the CTT - winutil, installing applications,
    installing PowerShell modules, and downloading configuration and settings files.

    Run this command to set the execution policy:
    PS> Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

    The available actions are:
    - drivers: Downloads drivers.
    - ctt: Invokes the CTT - winutil by downloading and executing a script from christitus.com.
    - apps: Installs applications by downloading a list from a JSON file and using the winget package manager.
    - psmods: Installs PowerShell modules by downloading a list from a JSON file and using the Install-Module cmdlet.
    - configs: Downloads configuration and settings files and places them in the appropriate locations.

    Note: Make sure to understand and review the code before executing it,
    especially when downloading and executing scripts from external sources.

#>


param (
  [Parameter(Mandatory = $false, Position = 0)]
  [string]$action
)


function Get-Driver {
  Write-Host "`nDownloading drivers..." -ForegroundColor Yellow

  $downloadsPath = Join-Path $Env:USERPROFILE "Downloads"
  $jsonPath = Join-Path $downloadsPath "winup"
  $driversPath = Join-Path $jsonPath "drivers"

  if (-not (Test-Path -Path $jsonPath -PathType Container)) {
    Write-Host "Creating " -NoNewline -ForegroundColor Yellow; Write-Host "'drivers' " -NoNewline -ForegroundColor Blue; Write-Host "folder..." -ForegroundColor Yellow
    New-Item -Path $driversPath -ItemType Directory | Out-Null
  }

  $driversJsonPath = Join-Path $jsonPath "drivers.json"
  $driversUrl = "https://raw.githubusercontent.com/RustyTake-Off/dotfiles/main/winfiles/files/drivers.json"

  Write-Host "Downloading " -NoNewline -ForegroundColor Yellow; Write-Host "drivers.json " -NoNewline -ForegroundColor Blue; Write-Host "file..." -ForegroundColor Yellow
  Start-BitsTransfer -Source $driversUrl -Destination $jsonPath

  $driversJson = Get-Content -Raw -Path $driversJsonPath | ConvertFrom-Json

  foreach ($driverUrl in $driversJson.drivers) {
    Write-Host "Downloading " -NoNewline; Write-Host "$driverUrl" -ForegroundColor Blue
    $outputFileName = Split-Path -Leaf $driverUrl
    $outputFilePath = Join-Path $driversPath $outputFileName
    Start-BitsTransfer -Source $driverUrl -Destination $outputFilePath
  }

  Write-Host "Download of drivers completed!" -ForegroundColor Green
}


function Invoke-CTT {
  Write-Host "`nInvoking CTT - winutil..." -ForegroundColor Yellow

  Invoke-WebRequest -useb https://christitus.com/win | Invoke-Expression

  Write-Host "`nInvoke of winutil completed!" -ForegroundColor Green
}


function Get-App {
  Write-Host "`nInstalling applications..." -ForegroundColor Yellow

  $downloadsPath = Join-Path $Env:USERPROFILE "Downloads"
  $jsonPath = Join-Path $downloadsPath "winup"

  if (-not (Test-Path -Path $jsonPath -PathType Container)) {
    Write-Host "Creating " -NoNewline -ForegroundColor Yellow; Write-Host "'winup' " -NoNewline -ForegroundColor Blue; Write-Host "folder..." -ForegroundColor Yellow
    New-Item -Path $jsonPath -ItemType Directory | Out-Null
  }

  $appsJsonPath = Join-Path $jsonPath "apps.json"
  $appsUrl = "https://raw.githubusercontent.com/RustyTake-Off/dotfiles/main/winfiles/files/apps.json"

  Write-Host "Downloading " -NoNewline -ForegroundColor Yellow; Write-Host "apps.json " -NoNewline -ForegroundColor Blue; Write-Host "file..." -ForegroundColor Yellow
  Start-BitsTransfer -Source $appsUrl -Destination $jsonPath

  $appsJson = Get-Content -Raw -Path $appsJsonPath | ConvertFrom-Json

  foreach ($appName in $appsJson.apps) {
    if (-not (winget list --exact --id $appName)) {
      Write-Host "Installing " -NoNewline; Write-Host "$appName" -ForegroundColor Blue
      winget install --exact --id $appName --silent --no-upgrade
    }
    else {
      Write-Host "$appName " -ForegroundColor Blue -NoNewline; Write-Host "is already installed. " -NoNewline; Write-Host "Skipping installation..." -ForegroundColor Red
    }
  }

  Write-Host "Installation of applications completed!" -ForegroundColor Green
}


function Get-PSModule {
  Write-Host "`nInstalling PowerShell modules..." -ForegroundColor Yellow

  $downloadsPath = Join-Path $Env:USERPROFILE "Downloads"
  $jsonPath = Join-Path $downloadsPath "winup"

  if (-not (Test-Path -Path $jsonPath -PathType Container)) {
    Write-Host "Creating " -NoNewline -ForegroundColor Yellow; Write-Host "'winup' " -NoNewline -ForegroundColor Blue; Write-Host "folder..." -ForegroundColor Yellow
    New-Item -Path $jsonPath -ItemType Directory | Out-Null
  }

  $psmodulesJsonPath = Join-Path $jsonPath "psmodules.json"
  $psmodulesUrl = "https://raw.githubusercontent.com/RustyTake-Off/dotfiles/main/winfiles/files/psmodules.json"

  Write-Host "Downloading " -NoNewline -ForegroundColor Yellow; Write-Host "psmodules.json " -NoNewline -ForegroundColor Blue; Write-Host "file..." -ForegroundColor Yellow
  Start-BitsTransfer -Source $psmodulesUrl -Destination $jsonPath

  $psmodulesJson = Get-Content -Raw -Path $psmodulesJsonPath | ConvertFrom-Json

  foreach ($psmName in $psmodulesJson.psmodules) {
    if (-not (Get-Module -ListAvailable -Name $psmName)) {
      Write-Host "Installing " -NoNewline; Write-Host "$psmName" -ForegroundColor Blue
      Install-Module $psmName -Force -AcceptLicense
    }
    else {
      Write-Host "$psmName " -ForegroundColor Blue -NoNewline; Write-Host "is already installed. " -NoNewline; Write-Host "Skipping installation..." -ForegroundColor Red
    }
  }

  Write-Host "Installation of PowerShell modules completed!" -ForegroundColor Green
}


function Set-Config {
  Write-Host "`nSetting configuration files in all the right places..." -ForegroundColor Yellow

  # winget settings
  $wingetConfigPath = Join-Path $Env:LOCALAPPDATA "\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState"
  $wingetSettingsPath = Join-Path $wingetConfigPath "settings.json"
  $wingetSettingsBackupPath = Join-Path $wingetConfigPath "settings.json.backup"
  $wingetUrl = "https://raw.githubusercontent.com/RustyTake-Off/dotfiles/main/winfiles/files/winget.json"

  Write-Host "Downloading " -NoNewline -ForegroundColor Yellow; Write-Host "winget.json " -NoNewline -ForegroundColor Blue; Write-Host "file..." -ForegroundColor Yellow
  Start-BitsTransfer -Source $wingetUrl -Destination $wingetSettingsPath

  Write-Host "Creating " -NoNewline -ForegroundColor Yellow; Write-Host "winget settings.json.backup " -NoNewline -ForegroundColor Blue; Write-Host "file..." -ForegroundColor Yellow
  Copy-Item -Path $wingetSettingsPath -Destination $wingetSettingsBackupPath

  # images
  $imagesPath = Join-Path $env:USERPROFILE "\shared\images"
  $imagesFilePath = Join-Path $imagesPath "\images.zip"

  if (-not (Test-Path -Path $imagesPath -PathType Container)) {
    Write-Host "Creating " -NoNewline -ForegroundColor Yellow; Write-Host "'images' " -NoNewline -ForegroundColor Blue; Write-Host "folder..." -ForegroundColor Yellow
    New-Item -Path $imagesPath -ItemType Directory | Out-Null
  }

  $imagesUrl = "https://github.com/RustyTake-Off/dotfiles/raw/main/winfiles/files/images/images.zip"

  Write-Host "Downloading " -NoNewline -ForegroundColor Yellow; Write-Host "images.zip " -NoNewline -ForegroundColor Blue; Write-Host "file..." -ForegroundColor Yellow
  Start-BitsTransfer -Source $imagesUrl -Destination $imagesPath

  Write-Host "Extracting " -NoNewline -ForegroundColor Yellow; Write-Host "images.zip " -NoNewline -ForegroundColor Blue; Write-Host "file..." -ForegroundColor Yellow
  Expand-Archive -Path $imagesFilePath -DestinationPath $imagesPath -Force
  Remove-Item -Path $imagesFilePath

  # windows terminal
  $winTerminalConfigPath = Join-Path $env:LOCALAPPDATA "\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
  $winTerminalSettingsPath = Join-Path $winTerminalConfigPath "settings.json"
  $winTerminalUrl = "https://raw.githubusercontent.com/RustyTake-Off/dotfiles/main/winfiles/files/windows-terminal.json"

  Write-Host "Downloading " -NoNewline -ForegroundColor Yellow; Write-Host "windows-terminal.json " -NoNewline -ForegroundColor Blue; Write-Host "file..." -ForegroundColor Yellow
  Start-BitsTransfer -Source $winTerminalUrl -Destination $winTerminalSettingsPath

  # powershell profiles
  $powershellProfileFilePath = Join-Path $env:USERPROFILE "\Documents\PowerShell"

  if (-not (Test-Path -Path $powershellProfileFilePath -PathType Container)) {
    Write-Host "Creating " -NoNewline -ForegroundColor Yellow; Write-Host "'PowerShell' " -NoNewline -ForegroundColor Blue; Write-Host "folder..." -ForegroundColor Yellow
    New-Item -Path $powershellProfileFilePath -ItemType Directory | Out-Null
  }

  $powershellMSUrl = "https://raw.githubusercontent.com/RustyTake-Off/dotfiles/main/winfiles/files/Microsoft.PowerShell_profile.ps1"
  $powershellVSUrl = "https://raw.githubusercontent.com/RustyTake-Off/dotfiles/main/winfiles/files/Microsoft.VSCode_profile.ps1"

  Write-Host "Downloading " -NoNewline -ForegroundColor Yellow; Write-Host "Microsoft.PowerShell_profile.ps1 " -NoNewline -ForegroundColor Blue; Write-Host "file..." -ForegroundColor Yellow
  Start-BitsTransfer -Source $powershellMSUrl -Destination $powershellProfileFilePath

  Write-Host "Downloading " -NoNewline -ForegroundColor Yellow; Write-Host "Microsoft.VSCode_profile.ps1 " -NoNewline -ForegroundColor Blue; Write-Host "file..." -ForegroundColor Yellow
  Start-BitsTransfer -Source $powershellVSUrl -Destination $powershellProfileFilePath

  Write-Host "Configuration files placement completed!" -ForegroundColor Green
}

switch ($action) {
  "drivers" {
    Get-Driver
  }
  "ctt" {
    Invoke-CTT
  }
  "apps" {
    Get-App
  }
  "psmods" {
    Get-PSModule
  }
  "configs" {
    Set-Config
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