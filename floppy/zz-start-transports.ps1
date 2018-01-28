Write-Output "=> Starting Transport Services"
Get-Service winrm | Start-Service
