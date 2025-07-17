<#
.SYNOPSIS
    This PowerShell script ensures that the 'NoAutorun' registry value is set to 1 to disable AutoRun on all drives, as required by STIG ID WN10-CC-000185.

.NOTES
    Author          : Jorge Garcia Sosa
    GitHub          : github.com/jorgegsosa11/jorgegsosa11
    Date Created    : 2025-07-16
    Last Modified   : 2025-07-16
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000185

.DESCRIPTION
    According to DISA STIG WN10-CC-000185, AutoRun must be disabled to reduce the risk of malware propagation through USB or other removable media. 
    This script checks the registry path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer' for the 'NoAutorun' value.
    If the value is missing or set incorrectly, it will be created or updated to '1' (REG_DWORD) to comply with the STIG requirement.
#>

# Define registry path and expected values
$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
$valueName = "NoAutorun"
$expectedValue = 1

# Check if the registry path exists
if (-not (Test-Path $registryPath)) {
    Write-Host "Registry path does not exist. Creating it..."
    New-Item -Path $registryPath -Force | Out-Null
}

# Try to get the current value
$currentValue = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction SilentlyContinue

# Evaluate and remediate if necessary
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
