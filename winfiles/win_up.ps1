param (
  [Parameter(Mandatory = $false, Position = 0)]
  [string]$action
)
# 01. Download and install updates
# 02. Download and install all drivers + printer
function Get-Drivers {
  Write-Host "`nDownloading drivers + printer drivers..." -ForegroundColor Yellow

  $downloadsPath = Join-Path $Env:USERPROFILE "Downloads"
  $driversPath = Join-Path $downloadsPath "drivers"

  if (-not (Test-Path -Path $driversPath -PathType Container)) {
    Write-Host "Creating 'drivers' folder..." -ForegroundColor Yellow
    New-Item -Path $driversPath -ItemType Directory | Out-Null
  }

  $driversUrl = "https://raw.githubusercontent.com/RustyTake-Off/dotfiles/main/winfiles/files/drivers.json"
  $driversJsonPath = Join-Path $driversPath "drivers.json"

  Write-Host "Downloading drivers.json file..." -ForegroundColor Yellow
  Start-BitsTransfer -Source $driversUrl -Destination $driversPath

  $driversJson = Get-Content -Raw -Path $driversJsonPath | ConvertFrom-Json

  foreach ($driverUrl in $driversJson.drivers) {
    Write-Host "Downloading: $driverUrl"
    $outputFileName = Split-Path -Leaf $driverUrl
    $outputFilePath = Join-Path $driversPath $outputFileName
    Start-BitsTransfer -Source $driverUrl -Destination $outputFilePath
  }

  Write-Host "Download completed!" -ForegroundColor Green
}

# 03. Invoke CTT - winutil
function Get-CTT {
  Write-Host "`nInvoking CTT - winutil" -ForegroundColor Yellow

  Invoke-WebRequest -useb https://christitus.com/win | Invoke-Expression
}

# 04. Install utility applications:
#   01. Microsoft.VCRedist.2005.x64
#   02. Microsoft.VCRedist.2008.x64
#   03. Microsoft.VCRedist.2010.x64
#   04. Microsoft.VCRedist.2012.x64
#   05. Microsoft.VCRedist.2013.x64
#   06. Microsoft.VCRedist.2015+.x64
#   07. File-New-Project.EarTrumpet
#   08. 7zip.7zip
#   09. CPUID.HWMonitor
#   10. Notepad++.Notepad++
#   11. SumatraPDF.SumatraPDF
#   12. Brave.Brave
#   13. KeePassXCTeam.KeePassXC
#   14. Greenshot.Greenshot
#   15. VideoLAN.VLC
#   16. TheDocumentFoundation.LibreOffice
#   17. Microsoft.PowerToys

# 05. Install work applications:
#   01. Git.Git
#   02. Microsoft.PowerShell
#   03. Microsoft.AzureCLI
#   04. Microsoft.WindowsTerminal
#   05. Microsoft.VisualStudioCode

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

# 08. Setup powershell profile

# 09. Install WSL
# 10. Setup WSL config

# 12. Setup Windows Terminal

switch ($action) {
  "drivers" {
    Get-Drivers
  }
  "ctt" {
    Get-CTT
  }
  default {
    Write-Host """
    Available actions to take:
      -drivers
      -ctt

    """
  }
}