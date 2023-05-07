

$DriversArray = @(
    "https://dl.dell.com/FOLDER04001557M/9/Intel-Chipset-Device-Software_HMDR4_WIN_10.1.1.38_A05_06.EXE",
    "https://dl.dell.com/FOLDER05463466M/4/Realtek-Memory-Card-Reader-Driver_R16KJ_WIN_10.0.17763.21313_A02_02.EXE",
    "https://dl.dell.com/FOLDER06762917M/3/STMicroelectronics-Free-Fall-Data-Protection-Driver_FXX2G_WIN_4.10.106_A02.EXE",
    "https://dl.dell.com/FOLDER05629954M/5/Intel-HID-Event-Filter-Driver_33CDY_WIN_2.2.1.377_A11_04.EXE",
    "https://dl.dell.com/FOLDER07448178M/2/Dell-Touchpad-Driver_2VV2N_WIN_10.3201.101.216_A10.EXE",
    "https://dl.dell.com/FOLDER06444713M/1/Dell-Touchpad-Settings-Application_CPPN8_WIN64_10.1.11.0_A03.EXE",
    "https://dl.dell.com/FOLDER08377421M/3/Intel-9560-9260-8265-7265-3165-Bluetooth-UWD-Driver_MCC7Y_WIN64_22.130.0.2_A34_02.EXE",
    "https://dl.dell.com/FOLDER08377396M/5/Intel-9560-9260-8265-7265-3165-Wi-Fi-Driver_FCCJ9_WIN_22.130.0.5_A30_04.EXE",
    "https://dl.dell.com/FOLDER06114266M/2/Realtek-High-Definition-Audio-Driver_88XXX_WIN_6.0.8895.1_A23_01.EXE",
    "https://download.brother.com/welcome/dlf004452/dcp-j315w-inst-B1-cd5.EXE"
)

$SoftwareArray = @(
    "File-New-Project.EarTrumpet",
    "7zip.7zip",
    "Microsoft.VCRedist.2005.x64",
    "Microsoft.VCRedist.2008.x64",
    "Microsoft.VCRedist.2010.x64",
    "Microsoft.VCRedist.2012.x64",
    "Microsoft.VCRedist.2013.x64",
    "Microsoft.VCRedist.2015+.x64",
    "Brave.Brave",
    "KeePassXCTeam.KeePassXC",
    "Microsoft.WindowsTerminal",
    "Microsoft.PowerShell",
    "Git.Git",
    "Microsoft.VisualStudioCode",
    "Microsoft.AzureCLI",
    "Notepad++.Notepad++"
    "CPUID.HWMonitor",
    "SumatraPDF.SumatraPDF",
    "JanDeDobbeleer.OhMyPosh",
    "TheDocumentFoundation.LibreOffice",
    "Docker.DockerDesktop"
)

$VSCodeExtArray = @(
    "aaron-bond.better-comments",
    "AzurePolicy.azurepolicyextension",
    "bencoleman.armview",
    "DavidAnson.vscode-markdownlint",
    "eamodio.gitlens",
    "GitHub.remotehub",
    "hashicorp.terraform",
    "ms-azure-devops.azure-pipelines",
    "ms-azuretools.azure-dev",
    "ms-azuretools.vscode-azureappservice",
    "ms-azuretools.vscode-azurefunctions",
    "ms-azuretools.vscode-azureresourcegroups",
    "ms-azuretools.vscode-azurestaticwebapps",
    "ms-azuretools.vscode-azurestorage",
    "ms-azuretools.vscode-azurevirtualmachines",
    "ms-azuretools.vscode-bicep",
    "ms-azuretools.vscode-cosmosdb",
    "ms-azuretools.vscode-docker",
    "ms-dotnettools.vscode-dotnet-runtime",
    "ms-kubernetes-tools.vscode-aks-tools",
    "ms-kubernetes-tools.vscode-kubernetes-tools",
    "ms-vscode-remote.remote-containers",
    "ms-vscode-remote.remote-ssh",
    "ms-vscode-remote.remote-ssh-edit",
    "ms-vscode-remote.remote-wsl",
    "ms-vscode-remote.vscode-remote-extensionpack",
    "ms-vscode.azure-account",
    "ms-vscode.azure-repos",
    "ms-vscode.powershell",
    "ms-vscode.remote-explorer",
    "ms-vscode.remote-server",
    "ms-vscode.vscode-node-azure-pack",
    "ms-vsliveshare.vsliveshare",
    "msazurermtools.azurerm-vscode-tools",
    "oderwat.indent-rainbow",
    "redhat.vscode-yaml",
    "streetsidesoftware.code-spell-checker",
    "vscode-icons-team.vscode-icons",
    "wayou.vscode-todo-highlight",
    "yzhang.markdown-all-in-one"
)

$Command = $args[0]


Function Test-WingetInstalled {
    return $null -ne (winget --version)
}

Function Test-VSCodeInstalled {
    return $null -ne (code --version)
}


switch ($Command) {
    "drivers" {
        <#
        .SYNOPSIS
            Downloads drivers.
        #>

        New-Item -Name drivers -ItemType Directory -Path $HOME\Desktop -Force
        Write-Host "Directory created or already exists!"

        foreach ($Driver in $DriversArray) {
            Start-BitsTransfer $Driver -Destination $HOME\Desktop\drivers
            Write-Host "Downloading driver: $Driver"
        }
    }
    "software" {
        <#
        .SYNOPSIS
            Installs software using winget.
        #>

        if (Test-WingetInstalled) {
            foreach ($Software in $SoftwareArray) {
                $Installed = winget list --exact -q $Software -v
                if ($Installed -cmatch $Software) {
                    Write-Host "Skipping: $Software (already installed)"
                }
                else {
                    Write-Host "Installing: $Software"
                    winget install -e -h --accept-source-agreements --accept-package-agreements --id $Software
                }
            }
        }
        else {
            Write-Error "Winget is not installed on this system."
            exit 1
        }
    }
    "code" {
        <#
        .SYNOPSIS
            Installs VSCode extensions.
        #>

        if (Test-VSCodeInstalled) {
            foreach ($Extension in $VSCodeExtArray) {
                $Installed = code --list-extensions | Select-String -Pattern "$Extension" -Quiet
                if ($Installed) {
                    Write-Host "Skipping: $Extension (already installed)"
                }
                else {
                    Write-Host "Installing: $Extension"
                    code --install-extension $Extension
                }
            }
        }
        else {
            Write-Error "VSCode is not installed on this system."
            exit 1
        }
    }
    default {
        @"

            Available commands:
                drivers         - downloads drivers
                software        - installs software
                code            - installs vscodes extensions

"@
        exit 1
    }
    
}
