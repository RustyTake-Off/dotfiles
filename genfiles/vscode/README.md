# VSCode Configuration

## Install VSCode

```powershell
winget install --id Microsoft.VisualStudioCode
```

## Load settings

[**Sync**](https://code.visualstudio.com/docs/editor/settings-sync) settings with GitHub or load [**settings.json**](https://github.com/RustyTake-Off/dotfiles/blob/main/genfiles/vscode/settings.json) file into VSCode manually.

## Extensions

### List extensions

```powershell
code --list-extensions
```

### Install extensions

```powershell
code --install-extension <author>.<extension_name>
```

### Uninstall extensions

```powershell
code --uninstall-extension <author>.<extension_name>
```

### Useful extensions

Some essential and useful extensions:

```powershell
code --install-extension aaron-bond.better-comments

code --install-extension AzurePolicy.azurepolicyextension

code --install-extension bencoleman.armview

code --install-extension DavidAnson.vscode-markdownlint

code --install-extension eamodio.gitlens

code --install-extension GitHub.remotehub

code --install-extension hashicorp.terraform

code --install-extension 4ops.terraform

code --install-extension ms-azure-devops.azure-pipelines

code --install-extension ms-azuretools.azure-dev

code --install-extension ms-azuretools.vscode-azureappservice

code --install-extension ms-azuretools.vscode-azurefunctions

code --install-extension ms-azuretools.vscode-azureresourcegroups

code --install-extension ms-azuretools.vscode-azurestaticwebapps

code --install-extension ms-azuretools.vscode-azurestorage

code --install-extension ms-azuretools.vscode-azurevirtualmachines

code --install-extension ms-azuretools.vscode-bicep

code --install-extension ms-azuretools.vscode-cosmosdb

code --install-extension ms-azuretools.vscode-docker

code --install-extension ms-kubernetes-tools.vscode-aks-tools

code --install-extension ms-kubernetes-tools.vscode-kubernetes-tools

code --install-extension ms-vscode-remote.remote-containers

code --install-extension ms-vscode-remote.remote-ssh

code --install-extension ms-vscode-remote.remote-ssh-edit

code --install-extension ms-vscode-remote.remote-wsl

code --install-extension ms-vscode-remote.vscode-remote-extensionpack

code --install-extension ms-vscode.azure-account

code --install-extension ms-vscode.azure-repos

code --install-extension ms-vscode.powershell

code --install-extension ms-vscode.remote-explorer

code --install-extension ms-vscode.remote-server

code --install-extension ms-vscode.vscode-node-azure-pack

code --install-extension ms-vsliveshare.vsliveshare

code --install-extension msazurermtools.azurerm-vscode-tools

code --install-extension oderwat.indent-rainbow

code --install-extension redhat.vscode-yaml

code --install-extension streetsidesoftware.code-spell-checker

code --install-extension vscode-icons-team.vscode-icons

code --install-extension wayou.vscode-todo-highlight

code --install-extension yzhang.markdown-all-in-one
```
