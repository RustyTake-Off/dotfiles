# VSCode Configuration

## Install VSCode

To install Visual Studio Code (VSCode), use the following PowerShell command:

```powershell
winget install --id Microsoft.VisualStudioCode --exact
```

## Load settings

You can [**sync**](https://code.visualstudio.com/docs/editor/settings-sync) your settings with GitHub or manually load the [**settings.json**](https://github.com/RustyTake-Off/dotfiles/blob/main/genfiles/vscode/vscode.json) file into VSCode.

## Extensions

### List extensions

To list the installed extensions in VSCode, use the following PowerShell command:

```powershell
code --list-extensions
```

### Install extensions

To install extensions in VSCode, use the following PowerShell command:

```powershell
code --install-extension <author>.<extension_name>
```

### Uninstall extensions

To uninstall extensions in VSCode, use the following PowerShell command:

```powershell
code --uninstall-extension <author>.<extension_name>
```

### Useful extensions

Here are some essential and useful extensions for VSCode:

| Extension                                    |
| -------------------------------------------- |
| aaron-bond.better-comments                   |
| AzurePolicy.azurepolicyextension             |
| bencoleman.armview                           |
| DavidAnson.vscode-markdownlint               |
| eamodio.gitlens                              |
| GitHub.remotehub                             |
| hashicorp.terraform                          |
| 4ops.terraform                               |
| ms-azure-devops.azure-pipelines              |
| ms-azuretools.azure-dev                      |
| ms-azuretools.vscode-azureappservice         |
| ms-azuretools.vscode-azurefunctions          |
| ms-azuretools.vscode-azureresourcegroups     |
| ms-azuretools.vscode-azurestaticwebapps      |
| ms-azuretools.vscode-azurestorage            |
| ms-azuretools.vscode-azurevirtualmachines    |
| ms-azuretools.vscode-bicep                   |
| ms-azuretools.vscode-cosmosdb                |
| ms-azuretools.vscode-docker                  |
| ms-kubernetes-tools.vscode-aks-tools         |
| ms-kubernetes-tools.vscode-kubernetes-tools  |
| ms-vscode-remote.remote-containers           |
| ms-vscode-remote.remote-ssh                  |
| ms-vscode-remote.remote-ssh-edit             |
| ms-vscode-remote.remote-wsl                  |
| ms-vscode-remote.vscode-remote-extensionpack |
| ms-vscode.azure-account                      |
| ms-vscode.azure-repos                        |
| ms-vscode.powershell                         |
| ms-vscode.remote-explorer                    |
| ms-vscode.remote-server                      |
| ms-vscode.vscode-node-azure-pack             |
| ms-vsliveshare.vsliveshare                   |
| msazurermtools.azurerm-vscode-tools          |
| oderwat.indent-rainbow                       |
| redhat.vscode-yaml                           |
| streetsidesoftware.code-spell-checker        |
| vscode-icons-team.vscode-icons               |
| wayou.vscode-todo-highlight                  |
| yzhang.markdown-all-in-one                   |

You can install these extensions by using the corresponding `code --install-extension` command for each extension.
