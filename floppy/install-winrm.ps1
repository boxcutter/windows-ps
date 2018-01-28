$host.ui.RawUI.WindowTitle = "Enabling Windows Remote Management. Please wait..."

Write-Output "==> Supressing network location prompt"
New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Network\NewNetworkWindowOff" -Force

Write-Output "==> Setting network to private"
$ifaceinfo = Get-NetConnectionProfile
Set-NetConnectionProfile -InterfaceIndex $ifaceinfo.InterfaceIndex -NetworkCategory Private

# Enable-PsRemoting -Force -SkipNetworkProfileCheck
winrm quickconfig -q
winrm s "winrm/config" '@{MaxTimeoutms="1800000"}'
winrm s "winrm/config/winrs" '@{MaxMemoryPerShellMB="2048"}'
winrm s "winrm/config/service" '@{AllowUnencrypted="true"}'
winrm s "winrm/config/service/auth" '@{Basic="true"}'

Get-Service winrm | Stop-Service

Write-Output "==> Enable WinRM firewall rule"
Enable-NetFirewallRule -DisplayName "Windows Remote Management (HTTP-In)"

# Write-Output -NoNewLine 'Press any key to continue...'
# $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
