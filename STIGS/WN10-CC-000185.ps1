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
