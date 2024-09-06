# dotfiles

**<p align="center">🐶📄 Dotfiles and configs for different things 🔢🍎🐧🛠️</p>**

Repository 🏤 contains my personal dotfiles and configuration files for various tools and environments.

## Key Files and Directories

* **genfiles**: Includes generic application and miscellaneous configurations.
* **shared**: Includes shared configurations and settings.
* **winfiles**: Configuration files and scripts tailored for Windows.
* **wslfiles**: Configuration files and scripts tailored for WSL/Linux.
* **setup.ps1**: Script for setting up the environment on Windows.
* **setup.sh**: Script for setting up the environment on WSL/Linux.

## Setup

To setup 💡 these dotfiles run either of bellow 🔽 commands:

**For Windows |  [winfiles](../winfiles)  | [setup.ps1](../setup.ps1)**

```powershell
(Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/RustyTake-Off/dotfiles/main/setup.ps1').Content | Invoke-Expression
```

**For Linux/WSL | [wslfiles](../wslfiles) | [setup.sh](../setup.sh)**

```bash
curl -fsS https://raw.githubusercontent.com/RustyTake-Off/dotfiles/main/setup.sh | bash
```
