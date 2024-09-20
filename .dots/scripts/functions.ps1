<#
.SYNOPSIS
Various functions

.DESCRIPTION
Loads useful functions for doing various things.

.LINK
GitHub      - https://github.com/RustyTake-Off
GitHub Repo - https://github.com/RustyTake-Off/dotfiles

.NOTES
Author  - RustyTake-Off
Version - 0.1.1
#>

[CmdletBinding(SupportsShouldProcess)]
param()

begin {
    # Preferences
    $ErrorActionPreference = 'SilentlyContinue'
}

process {
    try {
        function Get-UsableFunctions {
            <#
            .SYNOPSIS
            Retrieves PowerShell functions within the current session

            .DESCRIPTION
            The Get-UsableFunctions function allows you to list, filter, and view the source code of functions
            available in your PowerShell session.
            You can use wildcards to filter functions by name and optionally view the source code of a specific
            function.

            .EXAMPLE
            Get-UsableFunctions -Filter "*service*"
            List all functions with 'service' in the name

            .EXAMPLE
            Get-UsableFunctions -ViewFunction "Get-MyFunction"
            View source code of a specific function
            #>

            [CmdletBinding()]
            param (
                [Parameter(HelpMessage="Filter for function names. Use wildcards like '*' to match patterns.")]
                [string]$Filter = "*",

                [Parameter(HelpMessage="Name of a specific function to view its source code.")]
                [string]$ViewFunction = ""
            )

            # If ViewFunction is specified without a filter
            if ($ViewFunction -and $Filter -eq "*") {
                $selectedFunction = Get-Command -CommandType Function -Name $ViewFunction -ErrorAction SilentlyContinue

                if ($selectedFunction) {
                    Write-Output "`nSource code for function '$ViewFunction':"
                    $selectedFunction.ScriptBlock.ToString()
                } else {
                    Write-Output "Function '$ViewFunction' not found."
                }
                return
            }

            # List all functions matching the filter
            $functions = Get-Command -CommandType Function -Name $Filter

            if ($functions.Count -eq 0) {
                Write-Output "No functions found matching the filter: $Filter"
                return
            }

            Write-Output "Functions matching '$Filter':"
            $functions | ForEach-Object {
                Write-Output "  - $($_.Name)"
            }

            # If a specific function name is provided, display its source code
            if ($ViewFunction) {
                $selectedFunction = $functions | Where-Object { $_.Name -eq $ViewFunction }

                if ($selectedFunction) {
                    Write-Output "`nSource code for function '$ViewFunction':"
                    $selectedFunction.ScriptBlock.ToString()
                } else {
                    Write-Output "`nFunction '$ViewFunction' not found."
                }
            }
        }
    } catch {
        throw "Error in line $($_.InvocationInfo.ScriptLineNumber): $($_.Exception.Message)"
    }
}
