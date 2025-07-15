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
