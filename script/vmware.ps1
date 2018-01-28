Write-Output "==> Installing VMware Tools"
$isoPath = $Home, "windows.iso" -join "\"
Write-Output $isoPath

Mount-DiskImage -ImagePath $isoPath
$driveLetter = (Get-DiskImage $isoPath | Get-Volume).DriveLetter

Write-Host "Installing VMWare Tools..."
$setupPath = -join($driveLetter, ":\setup.exe")
$p = Start-Process -Wait -PassThru -FilePath $setupPath -ArgumentList "/S /l C:\Windows\Temp\vmware_tools.log /v""/qn REBOOT=R"""

if ($p.ExitCode -eq 0) {
  Write-Host "Done."
} elseif ($p.ExitCode -eq 3010) {
  Write-Host "Done, but a reboot is necessary."
} else {
  Write-Host "VMWare Tools install failed: ExitCode=$($p.ExitCode), Log=C:\Windows\Temp\vmware_tools.log"
  Start-Sleep 2; exit $p.ExitCode
}

Write-Output "Unmounting $driveLetter"
# Get-Volume ($driveLetter.Replace(":\","")) | Get-DiskImage | Dismount-DiskImage
