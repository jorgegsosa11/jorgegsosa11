<#
.SYNOPSIS
    This PowerShell script ensures that the 'EnableICMPRedirect' registry setting is configured properly to prevent ICMP redirect-based route manipulation.

.DESCRIPTION
    Following ICMP redirect of routes can lead to traffic not being routed properly. 
    When disabled, this forces ICMP to be routed via shortest path first. 
    This script checks and enforces the setting: 
    HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\EnableICMPRedirect = 0

.NOTES
    Author          : Jorge Garcia Sosa
    GitHub          : github.com/jorgegsosa11
    Date Created    : 2025-07-15
    Last Modified   : 2025-07-15
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000030
#>



# Define registry parameters
$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"
$valueName = "EnableICMPRedirect"
$desiredValue = 0

# Check if the value exists
if (Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction SilentlyContinue) {
    $currentValue = (Get-ItemProperty -Path $registryPath -Name $valueName).$valueName

    if ($currentValue -ne $desiredValue) {
        Write-Output "Value exists but is set to $currentValue. Changing it to $desiredValue..."
        Set-ItemProperty -Path $registryPath -Name $valueName -Value $desiredValue
    } else {
        Write-Output "Value exists and is correctly set to $desiredValue. No changes needed."
    }
} else {
    Write-Output "Value does not exist. Creating and setting it to $desiredValue..."
    New-ItemProperty -Path $registryPath -Name $valueName -PropertyType DWord -Value $desiredValue -Force
}

Write-Output "Check complete."
