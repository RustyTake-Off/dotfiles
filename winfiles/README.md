# winfiles

🐮📄 Dotfiles and configs for different things Windows. 🔢🛠️

    🔺 TODO: Update all of this! 🔺

## How to install ⏺️ dotfiles?

### Automatic setup

Open terminal as admin and first run this 🗽 command to be temporarily bypassed `ExecutionPolicy`

```powershell
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
```

If that is not a concerns run bellow command, it will require that all scripts and configuration files downloaded from the Internet be signed by a trusted publisher.

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
```

Use the command bellow to 🚀 quickly setup 🔵 dotfiles:

```powershell
Invoke-Expression (Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/RustyTake-Off/win-dotfiles/main/.config/scripts/Set-Dotfiles.ps1' -UseBasicParsing).Content | Invoke-Expression
```

Invoking ☀️ this script will:

* Create `pr` and `wk` folders in user directory
* Clone this repository and save it in the user directory (if the repo is present it will be updated)
* Create `SymbolicLinks` for:
  * PowerShell profiles
  * PowerShell scripts
  * Winget config
  * WSL config
* Copy Windows Terminal config (for some reason using `SymbolicLinks` breaks Windows Terminal updates)

---

### (Optionally) Manual setup

For more ✋ hands on approach here are the 🐾 steps to set it up.

Clone repo in 🐻 `bare` mode into `.dotfiles` directory.

```powershell
git clone --bare 'https://github.com/RustyTake-Off/win-dotfiles.git' "$env:USERPROFILE\.dotfiles"
```

Checkout repo into 🏠 home directory.

```powershell
git --git-dir="$env:USERPROFILE\.dotfiles" --work-tree=$env:USERPROFILE checkout
```

Set git to not show untracked files.

```powershell
git --git-dir="$env:USERPROFILE\.dotfiles" --work-tree=$env:USERPROFILE config status.showUntrackedFiles no
```

Lastly run this script.

```powershell
pwsh "$env:USERPROFILE\.config\scripts\Set-Dotfiles.ps1"
```

Everything should be in place 🙂

### Updating

Updating 🔵 dotfiles is done by using a `dot function` which is already in the 🚰 PowerShell profile. Normally it would be an alias but for some reason the `Set-Alias` with this command doesn't work so it's easier to put it into a `function`.

```powershell
function dot {
    git --git-dir="$env:USERPROFILE\.dotfiles" --work-tree=$env:USERPROFILE $Args
}
```

To update dotfiles run:

```powershell
dot pull
```

Another way is to use the `Set-Dotfiles` script in admin terminal. In 🚰 PowerShell profile there is an `admin function` which auto opens admin terminal and runs passed command there.

```powershell
function admin {
    if (-not $Args) {
        Start-Process wt -Verb RunAs -ArgumentList "pwsh -NoExit -ExecutionPolicy Bypass -Command `
        cd $(Get-Location)"
    } else {
        Start-Process wt -Verb RunAs -ArgumentList "pwsh -NoExit -ExecutionPolicy Bypass -Command `
        cd $(Get-Location) `
        $Args"
    }
}
```

To use it, run this command:

```powershell
admin Set-Dotfiles.ps1
```

## Windows environment setup script

> Note: Use-WinUp script also needs to be run as admin.

You might want to not change the `Execution Policy` permanently 🧊 so to change it only for the current process run the bellow command and then use the script.

```powershell
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
```

If that is not a concerns run bellow command, it will require that all scripts and configuration files downloaded from the Internet be signed by a trusted publisher.

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
```

Since it is a setup script you won't ❌ have `git` installed so to download this script run the bellow 👇 command which will get the script and save it on the desktop.

```powershell
Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/RustyTake-Off/win-dotfiles/main/.config/scripts/Use-WinUp.ps1' -UseBasicParsing -OutFile "$env:USERPROFILE\Desktop\Use-WinUp.ps1"
```

Then go to where it is saved and use the script.

```powershell
Set-Location -Path "$env:USERPROFILE\Desktop"
```
