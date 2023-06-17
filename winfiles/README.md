# winfiles 🔢

Dotfiles and configs for Windows.

## win_up script

This PowerShell script automates the process of downloading and installing drivers, applications, PowerShell modules, and configuration files on Windows. It provides several actions that can be performed individually, such as downloading drivers, invoking the CTT - winutil, installing applications, installing PowerShell modules, and downloading configuration and settings files.

## Usage

Download the script by invoking it and saving on your machine.

```powershell
Invoke-WebRequest -Uri "https://github.com/RustyTake-Off/dotfiles/raw/main/winfiles/win_up.ps1" -OutFile "$env:USERPROFILE\win_up.ps1"
```

## Running the Script

To run the script, use the following command:

```powershell
.\win_up.ps1 <action_name>
```

Replace <action_name> with one of the available actions:

| Action  | Description                                                                                                         |
| ------- | ------------------------------------------------------------------------------------------------------------------- |
| drivers | Downloads drivers.                                                                                                  |
| ctt     | Invokes the CTT - winutil by downloading and executing a script from christitus.com.                                |
| apps    | Installs applications by downloading a list from the apps.json file and using the winget package manager.           |
| psmods  | Installs PowerShell modules by downloading a list from the psmodules.json file and using the Install-Module cmdlet. |
| configs | Downloads configuration and settings files and places them in the appropriate locations.                            |

 Note: Make sure to understand and review the code before executing it, especially when downloading and executing scripts from external sources.
