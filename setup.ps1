# ╒══════╗        ╒═══════╗
# │ ╓──┐ ║════════╗  ╓─┐  ║
# │ ╚══╛ ║──┐  ╓──╜  ║ │  ║  RustyTake-Off
# │ ╓─┐ ╓╜  │  ║  │  ║ │  ║  https://github.com/RustyTake-Off
# │ ║ │ ╚╗  │  ║  │  ╚═╛  ║
# └─╜ └──╜  └──╜  └───────╜
# Setup script

[CmdletBinding(SupportsShouldProcess)]

# ANSI escape sequences for different colors
$redColor = [char]27 + '[31m'
$greenColor = [char]27 + '[32m'
$yellowColor = [char]27 + '[33m'
$blueColor = [char]27 + '[34m'
$purpleColor = [char]27 + '[35m'
$resetColor = [char]27 + '[0m'

function CheckAndAskToInstall([string]$packageName) {
    if (-not (Get-Command -Name $packageName -ErrorAction SilentlyContinue)) {
        $packageNameCapitalized = $packageName.Substring(0, 1).ToUpper() + $packageName.Substring(1)
        Write-Host "`n$redColor$packageNameCapitalized$resetColor is not installed."


        $loop = $true
        while ($loop) {
            $choice = Read-Host "Do you want to install $yellowColor$packageNameCapitalized$resetColor (y/N)?"

            if ([string]::IsNullOrWhiteSpace($choice)) {
                $choice = 'n' # Set default value to 'n' if no input is provided
            } else {
                $choice = $choice.Trim().ToLower()
            }

            if ($choice -eq 'n') {
                Write-Host 'Stopping script.'
                return $false
            } elseif ($choice -eq 'y') {
                return $true
            } else {
                Write-Host "$($redColor)Invalid input$($resetColor) please enter 'y' or 'n'.`n"
            }
        }
    }
}

if (CheckAndAskToInstall 'winget') {
    Write-Host "Installing $($yellowColor)Winget$($resetColor) and its dependencies..."

    $tempDir = "$env:USERPROFILE\tempDir"
    if (-not ($null = Test-Path -Path $tempDir -PathType Container)) {
        Write-Host 'Creating temp directory...'
        $null = New-Item -Path $tempDir -ItemType Directory
    }

    # https://learn.microsoft.com/en-us/windows/package-manager/winget/
    $components = @(
        @{
            name     = 'VCLibs'
            fileName = 'Microsoft.VCLibs.x64.14.00.Desktop.appx'
            url      = 'https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx'
        },
        @{
            name     = 'Xaml'
            fileName = 'Microsoft.UI.Xaml.2.8.x64.appx'
            url      = 'https://github.com/microsoft/microsoft-ui-xaml/releases/download/v2.8.6/Microsoft.UI.Xaml.2.8.x64.appx'
        },
        @{
            name     = 'Winget'
            fileName = 'Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle'
            url      = 'https://aka.ms/getwinget'
        }
    )

    for ($i = 0; $i -lt $components.Count; $i++) {
        try {
            Write-Host "Downloading $purpleColor$($components[$i].name)$resetColor..."
            # Invoke-WebRequest -Uri $components[$i].url -OutFile "$tempDir\$($components[$i].fileName)"
        } catch {
            Write-Error "Failed to download $purpleColor$($components[$i].name)$redColor. Error: $_"
            Write-Error "Line: $($_.ScriptStackTrace)"
        }
    }
    for ($i = 0; $i -lt $components.Count; $i++) {
        try {
            Write-Host "Installing $purpleColor$($components[$i].fileName)$resetColor..."
            # Add-AppxPackage -Path "$tempDir\$($components[$i].fileName)"
        } catch {
            Write-Error "Failed to install $purpleColor$($components[$i].fileName)$redColor. Error: $_"
            Write-Error "Line: $($_.ScriptStackTrace)"
        }
    }

    Write-Host "Installed $($greenColor)Winget$($resetColor) and its dependencies!"
}

if (CheckAndAskToInstall 'git') {
    Write-Host "Installing $($purpleColor)Git$($resetColor)..."
    Start-Process winget -ArgumentList 'install --exact --id Git.Git --source winget --interactive --accept-package-agreements --accept-source-agreements' -NoNewWindow -Wait
    Write-Host "Installed $($greenColor)Git$($resetColor)!"
}
