<#
.SYNOPSIS
    This PowerShell script ensures the 'NoDriveTypeAutoRun' registry value is set to 255 (0xFF) to disable AutoRun on all drive types as per Windows 10 STIG requirements.

.NOTES
    Author          : Jorge Garcia Sosa
    GitHub          : github.com/jorgegsosa11
    Date Created    : 2025-07-16
    Last Modified   : 2025-07-16
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000190 (assumed)

.DESCRIPTION
    STIG requires 'NoDriveTypeAutoRun' to be set to 255 (decimal) or 0xFF (hex) to completely disable AutoRun on all drive types.
    This script verifies and enforces this setting by configuring the appropriate registry value under:
    HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer
#>

# Define registry path and expected setting
$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
$valueName = "NoDriveTypeAutoRun"
$expectedValue = 255

# Check if the registry path exists
if (-not (Test-Path $registryPath)) {
    Write-Host "Registry path does not exist. Creating it..."
    New-Item -Path $registryPath -Force | Out-Null
}

# Retrieve current value
$currentValue = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction SilentlyContinue

# Evaluate and remediate if needed
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
