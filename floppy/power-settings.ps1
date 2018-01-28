Write-Output "==> Changing the power savings settings"

$PowerConfiguration = "High Performance"
Write-Output "Setting power plan to $PowerConfiguration"
$guid = (Get-WmiObject -Class win32_powerplan -Namespace root\cimv2\power -Filter "ElementName='$PowerConfiguration'").InstanceID.tostring()
$regex = [regex]"{(.*?)}$"
$newPower = $regex.Match($guid).groups[1].value
powercfg -setactive $newPower

Write-Output "Setting standby timeout to never"
powercfg -Change -standby-timeout-ac 0
Write-Output "Setting monitor timeout to never"
powercfg -Change -monitor-timeout-ac 0
