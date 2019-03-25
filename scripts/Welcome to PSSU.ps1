<#PSScriptInfo

.VERSION 1.0

.GUID 871f8fa6-d46c-4b91-936a-d1d3692aebd2

.AUTHOR Michael Garrison - michael.a.garrison@outlook.com

.COMPANYNAME TalkGeekTo.Me

.LICENSEURI https://github.com/michael-g-tgtm/PowerShell-Script-Utility/blob/master/LICENSE

.PROJECTURI GitHub: https://github.com/michael-g-tgtm/PowerShell-Script-Utility

.RELEASENOTES

#>

<#

.DESCRIPTION 
This is a simple script that prints a welcome message.

#>
$PSScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
Write-Host "##----------------------------------------##"
Write-Host "##        Welcome to the PowerShell       ##"
Write-Host "##             Script Utility!            ##" 
Write-Host "##----------------------------------------##"
Test-ScriptFileInfo -Path ".\PSSU GUI.ps1" |  Select-Object -Property Name,Version,Path,Author,CompanyName,LicenseUri,ProjectUri,Description | Format-List *