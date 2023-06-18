# winfiles 🔢

This directory contains `dotfiles` and configuration files for Windows, allowing you to easily set up and customize your Windows environment.

## win_up script

The `win_up` PowerShell script automates the process of downloading and installing drivers, applications, PowerShell modules, and configuration files on Windows. It offers various actions that can be executed individually, such as downloading drivers, invoking the CTT - winutil, installing applications, installing PowerShell modules, and downloading configuration and settings files.

## Usage

To use the script, follow these steps:

1. Download the script by executing the following command and saving it to your machine:

```powershell
Invoke-WebRequest -Uri "https://github.com/RustyTake-Off/dotfiles/raw/main/winfiles/win_up.ps1" -OutFile "$env:USERPROFILE\win_up.ps1"
```

2. Run the script using the following command:

```powershell
.\win_up.ps1 <action_name>
```

Replace `<action_name>` with one of the available actions:

| Action  | Description                                                                                                         |
| ------- | ------------------------------------------------------------------------------------------------------------------- |
| drivers | Downloads drivers.                                                                                                  |
| ctt     | Invokes the CTT - winutil by downloading and executing a script from christitus.com.                                |
| apps    | Installs applications by downloading a list from the apps.json file and using the winget package manager.           |
| psmods  | Installs PowerShell modules by downloading a list from the psmodules.json file and using the Install-Module cmdlet. |
| configs | Downloads configuration and settings files and places them in the appropriate locations.                            |

It is recommended to execute the actions in the following order:

1. drivers
2. ctt
3. apps
4. psmods
5. configs

 Note: Make sure to understand and review the code before executing it, especially when downloading and executing scripts from external sources.
