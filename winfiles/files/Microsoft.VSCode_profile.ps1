<#
.SYNOPSIS
Configuration for the Microsoft.VSCode_profile.ps1.

.DESCRIPTION
Configuration for the Microsoft.VSCode_profile.ps1 which loads the
Microsoft.PowerShell_profile.ps1 file.
#>

. Join-Path -Path $env:USERPROFILE -ChildPath '\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1'