<#
.SYNOPSIS
    This PowerShell script ensures that the 'DisableHTTPPrinting' registry value is set to 1 to disable HTTP-based printer connections, as required by STIG ID WN10-CC-000110.

.NOTES
    Author          : Jorge Garcia Sosa
    GitHub          : github.com/jorgegsosa11/jorgegsosa11
    Date Created    : 2025-07-18
    Last Modified   : 2025-07-18
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000110

.DESCRIPTION
    DISA STIG WN10-CC-000110 mandates that HTTP printing must be disabled to reduce the attack surface on Windows 10 systems.
    This script checks and enforces the registry setting:
    HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers\DisableHTTPPrinting
    It sets the value to 1 (REG_DWORD) if it is missing or misconfigured.
#>

# Define registry path and expected setting
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers"
$valueName = "DisableHTTPPrinting"
$expectedValue = 1

# Ensure registry path exists
if (-not (Test-Path $registryPath)) {
    Write-Host "Registry path does not exist. Creating it..."
    New-Item -Path $registryPath -Force | Out-Null
}

# Retrieve current registry value
$currentValue = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction SilentlyContinue

# Evaluate and remediate
if ($null -eq $currentValue) {
    Write-Host "'$valueName' not found. Creating it with value $expectedValue..."
    New-ItemProperty -Path $registryPath -Name $valueName -Value $expectedValue -PropertyType DWORD -Force | Out-Null
}
elseif ($currentValue.$valueName -ne $expectedValue) {
    Write-Host "'$valueName' is set to $($currentValue.$valueName). Changing to $expectedValue..."
    Set-ItemProperty -Path $registryPath -Name $valueName -Value $expectedValue
}
else {
    Write-Host "'$valueName' is already correctly set to $expectedValue. No action needed."
}
