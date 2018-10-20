$url = "https://packages.vmware.com/tools/releases/latest/windows/x64/VMware-tools-10.3.2-9925305-x86_64.exe"
$vmware_setup = "$($env:TEMP)\vmware_setup.exe"
Write-Host "Downloading VMware Tools..."
$wc = New-Object System.Net.WebClient
$wc.DownloadFile($url, $vmware_setup)

Write-Host "Installing VMWare Tools..."
# $p = Start-Process -Wait -PassThru -FilePath d:\setup.exe -ArgumentList "/S /l C:\Windows\Temp\vmware_tools.log /v""/qn REBOOT=R"""
$p = Start-Process -Wait -PassThru -FilePath $vmware_setup -ArgumentList "/S /l C:\Windows\Temp\vmware_tools.log /v""/qn REBOOT=R"""

if ($p.ExitCode -eq 0) {
  Write-Host "Done."
} elseif ($p.ExitCode -eq 3010) {
  Write-Host "Done, but a reboot is necessary."
} else {
  Write-Host "VMWare Tools install failed: ExitCode=$($p.ExitCode), Log=C:\Windows\Temp\vmware_tools.log"
  Start-Sleep 2; exit $p.ExitCode
}

