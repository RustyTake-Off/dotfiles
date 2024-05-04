<#
.SYNOPSIS
Completions for various cli tools

.DESCRIPTION
Loads completions for various cli tools, modules.

.LINK
GitHub      - https://github.com/RustyTake-Off
GitHub Repo - https://github.com/RustyTake-Off/dotfiles

.NOTES
Author  - RustyTake-Off
Version - 0.1.0
#>

try {
    # completion, history for powershell
    if (Get-Module -Name PSReadLine) {
        $psMinimumVersion = [version]'7.1.999'

        if (($Host.Name -eq 'ConsoleHost') -and ($PSVersionTable.PSVersion -ge $psMinimumVersion)) {
            Set-PSReadLineOption -PredictionSource HistoryAndPlugin
        } else {
            Set-PSReadLineOption -PredictionSource History
        }
        # Set-PSReadLineOption -EditMode Vi
        Set-PSReadLineOption -HistoryNoDuplicates:$true
        Set-PSReadLineOption -HistorySearchCursorMovesToEnd:$true
        Set-PSReadLineOption -PredictionViewStyle ListView
        Set-PSReadLineOption -Colors @{
            Command   = 'Yellow'
            Parameter = 'Green'
            String    = 'DarkCyan'
        }
        Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
        Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    }

    # completion for git
    if (Get-Module -Name posh-git) {
        $GitPromptSettings.EnablePromptStatus = $false
        $GitPromptSettings.EnableFileStatus = $false
    } elseif (-not (Get-Module -Name posh-git)) {
        Import-Module -Name posh-git
        $GitPromptSettings.EnablePromptStatus = $false
        $GitPromptSettings.EnableFileStatus = $false
    }

    # completion for winget - https://learn.microsoft.com/en-us/windows/package-manager/winget/tab-completion#enable-tab-completion
    if (Get-Command -Name winget -ErrorAction SilentlyContinue) {
        Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
            param($wordToComplete, $commandAst, $cursorPosition)
            [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
            $Local:word = $wordToComplete.Replace('"', '""')
            $Local:ast = $commandAst.ToString().Replace('"', '""')
            winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
                [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
            }
        }
    }

    # completion for azure-cli - https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows?view=azure-cli-latest&tabs=winget#enable-tab-completion-in-powershell
    if (Get-Command -Name az -ErrorAction SilentlyContinue) {
        Register-ArgumentCompleter -Native -CommandName az -ScriptBlock {
            param($commandName, $wordToComplete, $cursorPosition)
            $completion_file = New-TemporaryFile
            $env:ARGCOMPLETE_USE_TEMPFILES = 1
            $env:_ARGCOMPLETE_STDOUT_FILENAME = $completion_file
            $env:COMP_LINE = $wordToComplete
            $env:COMP_POINT = $cursorPosition
            $env:_ARGCOMPLETE = 1
            $env:_ARGCOMPLETE_SUPPRESS_SPACE = 0
            $env:_ARGCOMPLETE_IFS = "`n"
            $env:_ARGCOMPLETE_SHELL = 'powershell'
            az 2>&1 | Out-Null
            Get-Content $completion_file | Sort-Object | ForEach-Object {
                [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
            }
            Remove-Item $completion_file, Env:\_ARGCOMPLETE_STDOUT_FILENAME, Env:\ARGCOMPLETE_USE_TEMPFILES, Env:\COMP_LINE, Env:\COMP_POINT, Env:\_ARGCOMPLETE, Env:\_ARGCOMPLETE_SUPPRESS_SPACE, Env:\_ARGCOMPLETE_IFS, Env:\_ARGCOMPLETE_SHELL
        }
    }

    exit 0 # success
} catch {
    "Error in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
    exit 1
}
