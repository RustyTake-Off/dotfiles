param (
  [Parameter(Mandatory = $false, Position = 0)]
  [string]$action
)

function Get-Drivers {
  Write-Host "`nDownloading drivers + printer drivers..." -ForegroundColor Yellow

  $downloadsPath = Join-Path $Env:USERPROFILE "Downloads"
  $jsonPath = Join-Path $downloadsPath "winup"

  if (-not (Test-Path -Path $jsonPath -PathType Container)) {
    Write-Host "Creating 'winup' folder..." -ForegroundColor Yellow
    New-Item -Path $jsonPath -ItemType Directory | Out-Null
  }

  $driversUrl = "https://raw.githubusercontent.com/RustyTake-Off/dotfiles/main/winfiles/files/drivers.json"
  $driversJsonPath = Join-Path $jsonPath "drivers.json"

  Write-Host "Downloading drivers.json file..." -ForegroundColor Yellow
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

  Write-Host "Invoke of winutil completed!" -ForegroundColor Green
}

function Get-Apps {
  Write-Host "`nInstalling applications..." -ForegroundColor Yellow

  $downloadsPath = Join-Path $Env:USERPROFILE "Downloads"
  $jsonPath = Join-Path $downloadsPath "winup"

  if (-not (Test-Path -Path $jsonPath -PathType Container)) {
    Write-Host "Creating 'winup' folder..." -ForegroundColor Yellow
    New-Item -Path $jsonPath -ItemType Directory | Out-Null
  }

  $appsUrl = "https://raw.githubusercontent.com/RustyTake-Off/dotfiles/main/winfiles/files/apps.json"
  $appsJsonPath = Join-Path $jsonPath "apps.json"

  Write-Host "Downloading apps.json file..." -ForegroundColor Yellow
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

# 06. Download arkade - https://github.com/alexellis/arkade

# 07. Install Powershell modules:
#   01. PSWindowsUpdate
#   02. PSReadLine
#   03. z
#   04. PSColor
#   05. Terminal-Icons
#   06. posh-git
#   07. Az
#   08. CompletionPredictor

function Get-PSModules {
  Write-Host "`nInstalling PowerShell modules..." -ForegroundColor Yellow

  $downloadsPath = Join-Path $Env:USERPROFILE "Downloads"
  $jsonPath = Join-Path $downloadsPath "winup"

  if (-not (Test-Path -Path $jsonPath -PathType Container)) {
    Write-Host "Creating 'winup' folder..." -ForegroundColor Yellow
    New-Item -Path $jsonPath -ItemType Directory | Out-Null
  }

  $psmodulesUrl = "https://raw.githubusercontent.com/RustyTake-Off/dotfiles/main/winfiles/files/psmodules.json"
  $psmodulesJsonPath = Join-Path $jsonPath "psmodules.json"

  Write-Host "Downloading psmodules.json file..." -ForegroundColor Yellow
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


function Update-Configs {

  $wingetUrl = "https://raw.githubusercontent.com/RustyTake-Off/dotfiles/main/winfiles/files/winget.json"
  $wingetConfigPath = Join-Path $Env:LOCALAPPDATA "\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState"
  $wingetSettingsPath = Join-Path $wingetConfigPath "settings.json"

  Write-Host "Downloading winget.json file..." -ForegroundColor Yellow
  Start-BitsTransfer -Source $wingetUrl -Destination $wingetSettingsPath
  Write-Host "Copying winget settings.json file..." -ForegroundColor Yellow




}
# 08. Setup powershell profile

# 12. Setup Windows Terminal

switch ($action) {
  "drivers" {
    Get-Drivers
  }
  "ctt" {
    Invoke-CTT
  }
  "apps" {
    Get-Apps
  }
  "psmods" {
    Get-PSModules
  }
  "configs" {
    Update-Configs
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