# VSCode Configuration

📄 Configurations and settings for VSCode things. 🛠️

- [VSCode Configuration](#vscode-configuration)
  - [Current settings files](#current-settings-files)
  - [Load settings](#load-settings)
  - [Extensions](#extensions)
    - [Install extension](#install-extension)
    - [List installed extensions](#list-installed-extensions)
    - [Uninstall extension](#uninstall-extension)
  - [Useful extensions](#useful-extensions)
    - [Miscellaneous extensions](#miscellaneous-extensions)
    - [Git/GitHub extensions](#gitgithub-extensions)
    - [Linters/Formatters/Intellisense/LSPs/Debuggers/Languages extensions](#lintersformattersintellisenselspsdebuggerslanguages-extensions)
    - [API extensions](#api-extensions)
    - [AI assistance extensions](#ai-assistance-extensions)
    - [Infrastructure as Code extensions](#infrastructure-as-code-extensions)
    - [Azure extensions](#azure-extensions)
    - [Live Preview extensions](#live-preview-extensions)
    - [Markdown extensions](#markdown-extensions)
    - [Containers extensions](#containers-extensions)
    - [Remote Development extensions](#remote-development-extensions)

## Current settings files

| Name                    | Description               |
| :---------------------- | :------------------------ |
| [VSCode](./vscode.json) | Settings file for VSCode. |

## Load settings

You can [**sync your settings**](https://code.visualstudio.com/docs/editor/settings-sync) 🛠️ with GitHub or ✋ manually load the [**vscode.json**](./vscode.json) file into VSCode.

## Extensions

### Install extension

To install 💻 extensions in VSCode, use the GUI or the following command:

```powershell
code --install-extension <author>.<extension_name>
```

### List installed extensions

To list 🗃️ the installed extensions 📎 in VSCode, use the following command:

```powershell
code --list-extensions
```

### Uninstall extension

To uninstall ❌ extensions in VSCode, use the following command:

```powershell
code --uninstall-extension <author>.<extension_name>
```

## Useful extensions

Here are some essential and useful 👷 extensions for VSCode.

> Note: Try not to bloat VSCode with too many unnecessary extensions that you might not need

### Miscellaneous extensions

| Extension 📎                           | Description 📰                                          |
| ------------------------------------- | ------------------------------------------------------ |
| aaron-bond.better-comments            | Enhances comments in your code for better readability  |
| bierner.emojisense                    | Adds suggestions and autocomplete for emojis           |
| christian-kohler.path-intellisense    | Provides intelligent path autocompletion               |
| editorconfig.editorconfig             | EditorConfig support for consistent coding styles      |
| formulahendry.code-runner             | Run code snippet or code file for multiple languages   |
| github.github-vscode-theme            | GitHub theme for VS Code                               |
| ibm.output-colorizer                  | Colorizes log files for better readability             |
| ms-vsliveshare.vsliveshare            | Real-time collaborative development in VS Code         |
| oderwat.indent-rainbow                | Rainbow indentation for code blocks                    |
| pkief.material-icon-theme             | Material Design Icons for Visual Studio Code           |
| pnp.polacode                          | Create beautiful screenshots of your code              |
| redhat.vscode-yaml                    | YAML support for Visual Studio Code                    |
| richie5um2.vscode-sort-json           | Alphabetically sorts the keys in selected JSON objects |
| streetsidesoftware.code-spell-checker | Spelling checker for your code                         |
| tyriar.sort-lines                     | Sort lines of text in Visual Studio Code               |
| vscode-icons-team.vscode-icons        | Icons for Visual Studio Code                           |
| wayou.vscode-todo-highlight           | Highlight TODOs and FIXMEs in your code                |

[back to top ☝️](#vscode-configuration)

### Git/GitHub extensions

| Extension 📎                       | Description 📰                                    |
| --------------------------------- | ------------------------------------------------ |
| codezombiech.gitignore            | Easily create .gitignore files for your projects |
| donjayamanne.githistory           | View and manage Git history within VS Code       |
| eamodio.gitlens                   | Supercharge the Git capabilities in VS Code      |
| GitHub.remotehub                  | GitHub integration for VS Code                   |
| github.vscode-github-actions      | GitHub Actions workflow support                  |
| github.vscode-pull-request-github | Manage pull requests and issues from GitHub      |
| mhutchie.git-graph                | Visualize and explore Git history                |

### Linters/Formatters/Intellisense/LSPs/Debuggers/Languages extensions

| Extension 📎                             | Description 📰                                                                                                  |
| --------------------------------------- | -------------------------------------------------------------------------------------------------------------- |
| bradlc.vscode-tailwindcss               | Intelligent Tailwind CSS tooling for VS Code                                                                   |
| charliermarsh.ruff                      | Visual Studio Code extension with support for the Ruff linter for python                                       |
| donjayamanne.python-environment-manager | View and manage Python environments & packages                                                                 |
| ecmel.vscode-html-css                   | CSS Intellisense for HTML                                                                                      |
| esbenp.prettier-vscode                  | Code formatter using Prettier                                                                                  |
| kevinrose.vsc-python-indent             | Correct Python indentation                                                                                     |
| ms-python.black-formatter               | Formatting support for Python files using the Black formatter                                                  |
| ms-python.debugpy                       | Python debugger                                                                                                |
| ms-python.python                        | Python linting and formatting support                                                                          |
| ms-python.vscode-pylance                | Performant, feature-rich language server for Python in VS Code                                                 |
| ms-toolsai.jupyter                      | Jupyter notebook support, interactive programming and computing that supports Intellisense, debugging and more |
| ms-toolsai.jupyter-keymap               | Jupyter keymaps for notebooks                                                                                  |
| ms-toolsai.jupyter-renderers            | Renderers for Jupyter Notebooks                                                                                |
| ms-toolsai.vscode-jupyter-cell-tags     | Jupyter Cell Tags support for VS Code                                                                          |
| ms-toolsai.vscode-jupyter-slideshow     | Jupyter Slide Show support for VS Code                                                                         |
| ms-vscode.powershell                    | PowerShell support for Visual Studio Code                                                                      |
| njpwerner.autodocstring                 | Generates python docstrings automatically                                                                      |
| timonwong.shellcheck                    | Linter for Shell scripts                                                                                       |

[back to top ☝️](#vscode-configuration)

### API extensions

| Extension 📎                  | Description 📰                          |
| ---------------------------- | -------------------------------------- |
| humao.rest-client            | REST Client for Visual Studio Code     |
| postman.postman-for-vscode   | Postman integration for VS Code        |
| rangav.vscode-thunder-client | Thunder client for RESTful API testing |

### AI assistance extensions

| Extension 📎                                         | Description 📰                                                                            |
| --------------------------------------------------- | ---------------------------------------------------------------------------------------- |
| visualstudioexptteam.intellicode-api-usage-examples | AI-assisted development                                                                  |
| visualstudioexptteam.vscodeintellicode              | See relevant code examples from GitHub for over 100K different APIs right in your editor |

### Infrastructure as Code extensions

| Extension 📎                | Description 📰                                           |
| -------------------------- | ------------------------------------------------------- |
| 4ops.terraform             | Terraform support for Visual Studio Code                |
| bencoleman.armview         | View and interact with Azure Resource Manager templates |
| hashicorp.terraform        | Terraform language support                              |
| ms-azuretools.vscode-bicep | Bicep language support                                  |

[back to top ☝️](#vscode-configuration)

### Azure extensions

| Extension 📎                               | Description 📰                                |
| ----------------------------------------- | -------------------------------------------- |
| AzurePolicy.azurepolicyextension          | Azure Policy extension for Azure DevOps      |
| ms-azure-devops.azure-pipelines           | Azure Pipelines extension for Azure DevOps   |
| ms-azuretools.azure-dev                   | Azure Tools for Visual Studio Code           |
| ms-azuretools.vscode-azureappservice      | Azure App Service extension for VS Code      |
| ms-azuretools.vscode-azurefunctions       | Azure Functions tools for VS Code            |
| ms-azuretools.vscode-azureresourcegroups  | Manage Azure Resource Groups in VS Code      |
| ms-azuretools.vscode-azurestaticwebapps   | Azure Static Web Apps support                |
| ms-azuretools.vscode-azurestorage         | Azure Storage tools for VS Code              |
| ms-azuretools.vscode-azurevirtualmachines | Azure Virtual Machines management in VS Code |
| ms-azuretools.vscode-cosmosdb             | Azure Cosmos DB support for VS Code          |
| ms-kubernetes-tools.vscode-aks-tools      | Azure Kubernetes Service tools for VS Code   |
| ms-vscode.azure-account                   | Azure account management in VS Code          |
| ms-vscode.azure-repos                     | Azure Repos integration for VS Code          |
| ms-vscode.vscode-node-azure-pack          | Azure Node.js extension pack                 |
| msazurermtools.azurerm-vscode-tools       | Azure Resource Manager tools for VS Code     |

### Live Preview extensions

| Extension 📎           | Description 📰                                                                         |
| --------------------- | ------------------------------------------------------------------------------------- |
| ms-vscode.live-server | Hosts a local server in your workspace for you to preview your webpages on            |
| ritwickdey.liveserver | Launch a development local Server with live reload feature for static & dynamic pages |

[back to top ☝️](#vscode-configuration)

### Markdown extensions

| Extension 📎                    | Description 📰                                                                    |
| ------------------------------ | -------------------------------------------------------------------------------- |
| bierner.markdown-mermaid       | Adds Mermaid diagram and flowchart support to VS Code's builtin markdown preview |
| DavidAnson.vscode-markdownlint | Markdown linting and style checking                                              |
| yzhang.markdown-all-in-one     | All-in-one extension for Markdown                                                |

### Containers extensions

| Extension 📎                                 | Description 📰                             |
| ------------------------------------------- | ----------------------------------------- |
| ms-azuretools.vscode-docker                 | Docker support for Visual Studio Code     |
| ms-kubernetes-tools.vscode-kubernetes-tools | Kubernetes support for Visual Studio Code |

### Remote Development extensions

| Extension 📎                                  | Description 📰                             |
| -------------------------------------------- | ----------------------------------------- |
| ms-vscode-remote.remote-containers           | Develop in containers with VS Code Remote |
| ms-vscode-remote.remote-ssh                  | SSH remote development in VS Code         |
| ms-vscode-remote.remote-ssh-edit             | Edit files on SSH remote hosts in VS Code |
| ms-vscode-remote.remote-wsl                  | WSL remote development in VS Code         |
| ms-vscode-remote.vscode-remote-extensionpack | VS Code Remote Extension Pack             |
| ms-vscode.remote-explorer                    | Explore remote development environments   |
| ms-vscode.remote-server                      | VS Code Server for remote development     |

[back to top ☝️](#vscode-configuration)
