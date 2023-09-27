# winfiles 🔢

This directory contains `dotfiles` and configuration files for Windows, allowing to easier set up and customize of Windows environment.

## winup script 📎

The `winup` PowerShell 🟦 script automates the process of downloading and installing drivers, fonts, applications, PowerShell modules, and configuration files on Windows. It offers various actions that can be executed individually, such as downloading drivers, invoking the CTT - winutil, installing applications, installing PowerShell modules, and installing configuration and settings files. The configurations used in the script are taken from [here](https://github.com/RustyTake-Off/dotfiles/tree/main/winfiles/files).

## Usage ✋

To use the script, follow these steps 🐾:

1. Download the script by executing the following command and saving it to locally:

```powershell
Invoke-WebRequest -Uri "https://github.com/RustyTake-Off/dotfiles/raw/main/winfiles/winup.ps1" -OutFile "$env:USERPROFILE\winup.ps1"
```

2. Run the script using the following command:

```powershell
.\winup.ps1 <action_name>
```

Replace `<action_name>` with one of the available actions:

| Action  | Description                              |
| ------- | ---------------------------------------- |
| drivers | Downloads drivers                        |
| fonts   | Downloads and installs fonts             |
| apps    | Installs some base applications          |
| psmods  | Installs PowerShell modules              |
| ctt     | Invokes the CTT - winutil                |
| configs | Installs configuration and settings files |

It is recommended to execute the actions in the following order 🌌:

1. drivers
2. fonts
3. ctt
4. apps
5. psmods
6. configs

❗ Note: Make sure to understand and review the code before executing it, especially when downloading and executing scripts from external sources.
