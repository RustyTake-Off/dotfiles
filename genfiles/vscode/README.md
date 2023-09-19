# VSCode Configuration

Configuration for VSCode 📘

- [VSCode Configuration](#vscode-configuration)
  - [Install VSCode](#install-vscode)
  - [Load settings](#load-settings)
  - [Extensions](#extensions)
    - [Install extension](#install-extension)
    - [List installed extensions](#list-installed-extensions)
    - [Uninstall extension](#uninstall-extension)
    - [Useful extensions](#useful-extensions)

## Install VSCode

To install **Visual Studio Code (VSCode)** 📘, use the following PowerShell command:

```powershell
winget install --exact --id Microsoft.VisualStudioCode
```

## Load settings

You can [**sync**](https://code.visualstudio.com/docs/editor/settings-sync) your settings 🛠️ with GitHub or manually load the [**settings.json**](https://github.com/RustyTake-Off/dotfiles/blob/main/genfiles/vscode/vscode-config.json) file into VSCode.

## Extensions

### Install extension

To install 💻 extensions in VSCode, use the following PowerShell command:

```powershell
code --install-extension <author>.<extension_name>
```

### List installed extensions

To list 🗃️ the installed extensions 📎 in VSCode, use the following PowerShell command:

```powershell
code --list-extensions
```

### Uninstall extension

To uninstall ❌ extensions in VSCode, use the following PowerShell command:

```powershell
code --uninstall-extension <author>.<extension_name>
```

### Useful extensions

Here are some essential and useful 👷 extensions for VSCode:

| Extension 📎                                  | Description 📰                                           |
| -------------------------------------------- | ------------------------------------------------------- |
| 4ops.terraform                               | Terraform support for Visual Studio Code                |
| aaron-bond.better-comments                   | Enhances comments in your code for better readability   |
| AzurePolicy.azurepolicyextension             | Azure Policy extension for Azure DevOps                 |
| bencoleman.armview                           | View and interact with Azure Resource Manager templates |
| bierner.emojisense                           | Provides emoji suggestions and autocompletions          |
| christian-kohler.path-intellisense           | Provides intelligent path autocompletion                |
| codezombiech.gitignore                       | Easily create .gitignore files for your projects        |
| DavidAnson.vscode-markdownlint               | Markdown linting and style checking                     |
| donjayamanne.githistory                      | View and manage Git history within VS Code              |
| eamodio.gitlens                              | Supercharge the Git capabilities in VS Code             |
| editorconfig.editorconfig                    | EditorConfig support for consistent coding styles       |
| esbenp.prettier-vscode                       | Code formatter using Prettier                           |
| GitHub.remotehub                             | GitHub integration for VS Code                          |
| github.vscode-github-actions                 | GitHub Actions workflow support                         |
| github.vscode-pull-request-github            | Manage pull requests and issues from GitHub             |
| hashicorp.terraform                          | Terraform language support                              |
| ibm.output-colorizer                         | Colorizes log files for better readability              |
| mhutchie.git-graph                           | Visualize and explore Git history                       |
| ms-azure-devops.azure-pipelines              | Azure Pipelines extension for Azure DevOps              |
| ms-azuretools.azure-dev                      | Azure Tools for Visual Studio Code                      |
| ms-azuretools.vscode-azureappservice         | Azure App Service extension for VS Code                 |
| ms-azuretools.vscode-azurefunctions          | Azure Functions tools for VS Code                       |
| ms-azuretools.vscode-azureresourcegroups     | Manage Azure Resource Groups in VS Code                 |
| ms-azuretools.vscode-azurestaticwebapps      | Azure Static Web Apps support                           |
| ms-azuretools.vscode-azurestorage            | Azure Storage tools for VS Code                         |
| ms-azuretools.vscode-azurevirtualmachines    | Azure Virtual Machines management in VS Code            |
| ms-azuretools.vscode-bicep                   | Bicep language support                                  |
| ms-azuretools.vscode-cosmosdb                | Azure Cosmos DB support for VS Code                     |
| ms-azuretools.vscode-docker                  | Docker support for Visual Studio Code                   |
| ms-kubernetes-tools.vscode-aks-tools         | Azure Kubernetes Service tools for VS Code              |
| ms-kubernetes-tools.vscode-kubernetes-tools  | Kubernetes support for Visual Studio Code               |
| ms-vscode-remote.remote-containers           | Develop in containers with VS Code Remote               |
| ms-vscode-remote.remote-ssh                  | SSH remote development in VS Code                       |
| ms-vscode-remote.remote-ssh-edit             | Edit files on SSH remote hosts in VS Code               |
| ms-vscode-remote.remote-wsl                  | WSL remote development in VS Code                       |
| ms-vscode-remote.vscode-remote-extensionpack | VS Code Remote Extension Pack                           |
| ms-vscode.azure-account                      | Azure account management in VS Code                     |
| ms-vscode.azure-repos                        | Azure Repos integration for VS Code                     |
| ms-vscode.powershell                         | PowerShell support for Visual Studio Code               |
| ms-vscode.remote-explorer                    | Explore remote development environments                 |
| ms-vscode.remote-server                      | VS Code Server for remote development                   |
| ms-vscode.vscode-node-azure-pack             | Azure Node.js extension pack                            |
| ms-vsliveshare.vsliveshare                   | Real-time collaborative development in VS Code          |
| msazurermtools.azurerm-vscode-tools          | Azure Resource Manager tools for VS Code                |
| oderwat.indent-rainbow                       | Rainbow indentation for code blocks                     |
| pnp.polacode                                 | Create beautiful screenshots of your code               |
| postman.postman-for-vscode                   | Postman integration for VS Code                         |
| rangav.vscode-thunder-client                 | Thunder client for RESTful API testing                  |
| redhat.vscode-yaml                           | YAML support for Visual Studio Code                     |
| richie5um2.vscode-sort-json                  | Alphabetically sorts the keys in selected JSON objects  |
| streetsidesoftware.code-spell-checker        | Spelling checker for your code                          |
| tyriar.sort-lines                            | Sort lines of text in Visual Studio Code                |
| vscode-icons-team.vscode-icons               | Icons for Visual Studio Code                            |
| wayou.vscode-todo-highlight                  | Highlight TODOs and FIXMEs in your code                 |
| yzhang.markdown-all-in-one                   | All-in-one extension for Markdown                       |

You can install these extensions 📎 by using this command `code --install-extension <author>.<extension_name>` for each extension.

[back to top ☝️](#vscode-configuration)
