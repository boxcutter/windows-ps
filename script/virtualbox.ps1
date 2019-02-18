If ("$Env:PACKER_BUILDER_TYPE" -ne "virtualbox-iso") {
  Write-Host "VirtualBox not found, aborting guest additions install..."
  return
}

Write-Host "Installing VirtualBox guest additions"

md -Force "C:\Windows\Temp\virtualbox"

Get-ChildItem E:/cert/ -Filter vbox*.cer | ForEach-Object {
  E:/cert/VBoxCertUtil.exe add-trusted-publisher $_.FullName --root $_.FullName
}

Start-Process -FilePath "e:/VBoxWindowsAdditions.exe" -ArgumentList "/S" -WorkingDirectory "C:/Windows/Temp/virtualbox" -Wait
