<#
.SYNOPSIS
Configuration for the Microsoft.PowerShell_profile.ps1.
#>

# Import modules
if ($host.Name -eq 'ConsoleHost') {
  Import-Module -Name PSReadLine
}
Import-Module -Name Terminal-Icons
Import-Module -Name z