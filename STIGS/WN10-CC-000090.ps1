<#
.SYNOPSIS
    This PowerShell script ensures the 'NoGPOListChanges' registry value is set to 0, as required by STIG.

.NOTES
    Author          : Jorge Garcia Sosa
    GitHub          : github.com/jorgegsosa11
    Date Created    : 2025-07-18
    Last Modified   : 2025-07-18
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000090

.DESCRIPTION
    This script verifies and enforces the 'NoGPOListChanges' registry setting under:
    HKLM:\SOFTWARE\Policies\Microsoft\Windows\Group Policy\{35378EAC-683F-11D2-A89A-00C04FBBCFA2}
    It ensures the value is set to 0 (REG_DWORD), allowing Group Policy to notify the user when changes occur.
#>

# Define registry path and expected value
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Group Policy\{35378EAC-683F-11D2-A89A-00C04FBBCFA2}"
$valueName = "NoGPOListChanges"
$expectedValue = 0

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
