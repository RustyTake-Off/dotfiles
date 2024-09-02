# dotfiles

**<p align="center">🐶📄 Dotfiles and configs for different things 🔢🍎🐧🛠️</p>**

Repository 🏤 contains my personal dotfiles and configuration files for various tools and environments.

## Key Files and Directories

* **genfiles**: Includes generic application and miscellaneous configurations.
* **winfiles**: Configuration files and scripts tailored for Windows.
* **wslfiles**: Configuration files and scripts tailored for WSL/Linux.
* **setup.ps1**: Script for setting up the environment on Windows.
* **setup.sh**: Script for setting up the environment on WSL/Linux.

## Setup

To setup 💡 these dotfiles run either of bellow 🔽 commands:

**For Windows**

```powershell
(Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/RustyTake-Off/dotfiles/main/winfiles/.dots/scripts/set-dotfiles.ps1').Content | Invoke-Expression
```

**For WSL/Linux**

```bash
curl -fsS https://raw.githubusercontent.com/RustyTake-Off/dotfiles/main/wslfiles/.dots/scripts/set_dotfiles.sh | bash
```
