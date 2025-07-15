<#
.SYNOPSIS
    This PowerShell script ensures that the Windows Remote Management (WinRM) service does not store RunAs credentials.

.DESCRIPTION
    Storing RunAs credentials in WinRM can pose a security risk by exposing elevated account information. 
    This script checks and enforces the setting:
    HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WinRM\Service\DisableRunAs = 1

.NOTES
    Author          : Jorge Garcia Sosa
    GitHub          : github.com/jorgegsosa11
    Date Created    : 2025-07-15
    Last Modified   : 2025-07-15
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000355
#>


# Define registry path and expected value
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WinRM\Service"
$valueName = "DisableRunAs"
$expectedValue = 1

# Check if the registry path exists
if (-not (Test-Path $registryPath)) {
    Write-Host "Registry path does not exist. Creating it..."
    New-Item -Path $registryPath -Force | Out-Null
}

# Check if the registry value exists
$currentValue = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction SilentlyContinue

if ($null -eq $currentValue) {
    Write-Host "Registry value '$valueName' not found. Creating and setting it to $expectedValue..."
    New-ItemProperty -Path $registryPath -Name $valueName -Value $expectedValue -PropertyType DWORD -Force | Out-Null
}
elseif ($currentValue.$valueName -ne $expectedValue) {
    Write-Host "Registry value '$valueName' is not set correctly. Setting it to $expectedValue..."
    Set-ItemProperty -Path $registryPath -Name $valueName -Value $expectedValue
}
else {
    Write-Host "Registry value '$valueName' is already set correctly to $expectedValue."
}
