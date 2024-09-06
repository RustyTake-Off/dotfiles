# winfiles

**<p align="center">🐮📄 Dotfiles and configs for different things Windows 🔢🛠️</p>**

## Setup

To setup 💡 these dotfiles run bellow 🔽 command:

```powershell
(Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/RustyTake-Off/dotfiles/main/setup.ps1').Content | Invoke-Expression
```

## Updates

For updates run `setdots` alias or this command:

```powershell
(Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/RustyTake-Off/dotfiles/main/winfiles/.dots/scripts/set-dotfiles.ps1').Content | Invoke-Expression
```

**🔺NOTE**

You might need to run `Set-ExecutionPolicy` to allow outside scripts. For only this session you can do it like so:

```powershell
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
```

and for more permanent solution, like this:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
```
