<#
.SYNOPSIS
    This PowerShell script ensures that the maximum size of the Windows Application event log is at least 32768 KB (32 MB).

.NOTES
    Author          : Jorge Garcia Sosa
    GitHub          : github.com/jorgegsosa11
    Date Created    : 2025-07-07
    Last Modified   : 2025-07-07
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-AU-000500

#>




# Define the registry path
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Application"

# Create the key if it doesn't exist
if (-not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force
}

# Set the MaxSize value to 0x8000 (32768 KB)
New-ItemProperty -Path $registryPath -Name "MaxSize" -PropertyType DWord -Value 0x8000 -Force

Write-Output "Registry value set successfully."
