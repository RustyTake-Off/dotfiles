<#
.SYNOPSIS
This is a configuration script for the Microsoft.PowerShell_profile.ps1 file.

.DESCRIPTION
This is a configuration script for the Microsoft.PowerShell_profile.ps1 file.

Run this command to set the execution policy:
    PS> Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

This file should be stored in $PROFILE
If $PROFILE doesn't exist, you can make one with the following command:
    PS> New-Item $PROFILE -ItemType File -Force

This will create the file and the containing subdirectory if it doesn't already
have it.

The script sets up various configurations and imports modules to enhance the
PowerShell console experience.
Here's a breakdown of what the script does:

Script imports several PowerShell modules:
-   Terminal-Icons: This module adds support for displaying icons in the console.
-   posh-git: Integrates Git functionality into the console prompt, making it
    easier to work with Git repositories from the command line.
-   z: This module enables directory jumping capabilities using the 'z' command,
    allowing users to quickly navigate to frequently accessed directories.

Defines useful functions for traversing files and folders:
-   '.': Sets the current location to the parent directory.
-   '..': Sets the current location to the grandparent directory.
-   '...', '....', '.....': Sets the current location to increasingly higher-level
    parent directories.
-   'hm': Sets the current location to the user profile directory.
-   'hpr': Sets the current location to the user profile's pr subdirectory.
-   'hwk': Sets the current location to the user profile's wk subdirectory.

Defines functions for computing file hashes (MD5, SHA1, SHA256) to verify
successful downloads.

The script also registers argument completers for two commands:
-   'winget': Enables tab completion for the 'winget' command, making it easier
    to complete package names.
-   'az': Provides tab completion for the 'az' command (Azure CLI), enhancing
    the command line experience when interacting with Azure resources.

Overall, this script enhances the PowerShell console with features like Git
integration, directory jumping, improved history navigation, and convenient
key bindings for code editing.

.LINK
https://github.com/RustyTake-Off/dotfiles/blob/main/winfiles/files/Microsoft.PowerShell_profile.ps1

.NOTES
Make sure to understand and review the code before executing it, especially
when downloading and executing scripts from external sources.
#>

# Import modules
Import-Module -Name Terminal-Icons
Import-Module -Name posh-git
Import-Module -Name z

# Useful functions
# Traversing files and folders
function cd. { Set-Location .. }
function cd.. { Set-Location ..\.. }
function cd... { Set-Location ..\..\.. }
function cd.... { Set-Location ..\..\..\.. }
function cd..... { Set-Location ..\..\..\..\.. }
function hm { Set-Location $env:USERPROFILE }
function hpr { Set-Location $env:USERPROFILE\pr }
function hwk { Set-Location $env:USERPROFILE\wk }

# Compute file hashes - useful for checking successful downloads
function md5 { Get-FileHash -Algorithm MD5 $args }
function sha1 { Get-FileHash -Algorithm SHA1 $args }
function sha256 { Get-FileHash -Algorithm SHA256 $args }

function touch ($file) {
    '' | Out-File $file -Encoding ASCII
}

function which ($name) {
    Get-Command $name | Select-Object -ExpandProperty Definition
}

# Make it easier to edit this profile once it's installed
function Edit-Profile {
    if ($host.Name -match 'ise') {
        $psISE.CurrentPowerShellTab.Files.Add($PROFILE)
    } else {
        notepad $PROFILE
    }
}

function Reset-Profile {
    & $PROFILE
}

# PSReadLine configuration
$psMinimumVersion = [version]'7.1.999'

if (($Host.Name -eq 'ConsoleHost') -and ($PSVersionTable.PSVersion -ge $psMinimumVersion)) {
    Set-PSReadLineOption -PredictionSource HistoryAndPlugin
} else {
    Set-PSReadLineOption -PredictionSource History
}

Set-PSReadLineOption -EditMode Windows
Set-PSReadLineOption -HistorySearchCursorMovesToEnd:$true
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -Colors @{ InlinePrediction = 'Blue' }

Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

Set-PSReadLineKeyHandler -Key '(', '{', '[' `
    -BriefDescription InsertPairedBraces `
    -LongDescription 'Insert matching braces' `
    -ScriptBlock {
    param($key, $arg)

    $closeChar = switch ($key.KeyChar) {
        <#case#> '(' { [char]')'; break }
        <#case#> '{' { [char]'}'; break }
        <#case#> '[' { [char]']'; break }
    }

    $selectionStart = $null
    $selectionLength = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetSelectionState([ref]$selectionStart, [ref]$selectionLength)

    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

    if ($selectionStart -ne -1) {
        # Text is selected, wrap it in brackets
        [Microsoft.PowerShell.PSConsoleReadLine]::Replace($selectionStart, $selectionLength, $key.KeyChar + $line.SubString($selectionStart, $selectionLength) + $closeChar)
        [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($selectionStart + $selectionLength + 2)
    } else {
        # No text is selected, insert a pair
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert("$($key.KeyChar)$closeChar")
        [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor + 1)
    }
}

Set-PSReadLineKeyHandler -Key ')', ']', '}' `
    -BriefDescription SmartCloseBraces `
    -LongDescription 'Insert closing brace or skip' `
    -ScriptBlock {
    param($key, $arg)

    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

    if ($line[$cursor] -eq $key.KeyChar) {
        [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor + 1)
    } else {
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert("$($key.KeyChar)")
    }
}

Set-PSReadLineKeyHandler -Key Backspace `
    -BriefDescription SmartBackspace `
    -LongDescription 'Delete previous character or matching quotes/parens/braces' `
    -ScriptBlock {
    param($key, $arg)

    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

    if ($cursor -gt 0) {
        $toMatch = $null
        if ($cursor -lt $line.Length) {
            switch ($line[$cursor]) {
                <#case#> '"' { $toMatch = '"'; break }
                <#case#> "'" { $toMatch = "'"; break }
                <#case#> ')' { $toMatch = '('; break }
                <#case#> ']' { $toMatch = '['; break }
                <#case#> '}' { $toMatch = '{'; break }
            }
        }

        if ($toMatch -ne $null -and $line[$cursor - 1] -eq $toMatch) {
            [Microsoft.PowerShell.PSConsoleReadLine]::Delete($cursor - 1, 2)
        } else {
            [Microsoft.PowerShell.PSConsoleReadLine]::BackwardDeleteChar($key, $arg)
        }
    }
}

# Sometimes you enter a command but realize you forgot to do something else first.
# This binding will let you save that command in the history so you can recall it,
# but it doesn't actually execute. It also clears the line with RevertLine so the
# undo stack is reset - though redo will still reconstruct the command line.
Set-PSReadLineKeyHandler -Key Alt+w `
    -BriefDescription SaveInHistory `
    -LongDescription 'Save current line in history but do not execute' `
    -ScriptBlock {
    param($key, $arg)

    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
    [Microsoft.PowerShell.PSConsoleReadLine]::AddToHistory($line)
    [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
}

# Insert text from the clipboard as a here string
Set-PSReadLineKeyHandler -Key Ctrl+V `
    -BriefDescription PasteAsHereString `
    -LongDescription 'Paste the clipboard text as a here string' `
    -ScriptBlock {
    param($key, $arg)

    Add-Type -Assembly PresentationCore
    if ([System.Windows.Clipboard]::ContainsText()) {
        # Get clipboard text - remove trailing spaces, convert \r\n to \n, and remove the final \n.
        $text = ([System.Windows.Clipboard]::GetText() -replace "\p{Zs}*`r?`n", "`n").TrimEnd()
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert("@'`n$text`n'@")
    } else {
        [Microsoft.PowerShell.PSConsoleReadLine]::Ding()
    }
}

# Tab completion
# Tab completion for winget https://learn.microsoft.com/en-us/windows/package-manager/winget/tab-completion
Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
    [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
    $Local:word = $wordToComplete.Replace('"', '""')
    $Local:ast = $commandAst.ToString().Replace('"', '""')
    winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}

# Tab completion for azcli https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows?view=azure-cli-latest&tabs=winget#enable-tab-completion-on-powershell
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