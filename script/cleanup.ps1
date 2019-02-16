Write-Host "Cleaning updates.."
Stop-Service -Name wuauserv -Force
Remove-Item c:\Windows\SoftwareDistribution\Download\* -Recurse -Force
Start-Service -Name wuauserv

Write-Host "Cleaning SxS..."
Dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase

@(
    "$env:localappdata\Nuget",
    "$env:localappdata\temp\*",
    "$env:windir\logs",
    "$env:windir\panther",
    "$env:windir\temp\*",
    "$env:windir\winsxs\manifestcache",
    "C:\Recovery"
) | % {
        if(Test-Path $_) {
            Write-Host "Removing $_"
            try {
              Takeown /d Y /R /f $_
              Icacls $_ /GRANT:r administrators:F /T /c /q  2>&1 | Out-Null
              Remove-Item $_ -Recurse -Force | Out-Null
            } catch { $global:error.RemoveAt(0) }
        }
    }

Write-Host "Cleaning all event logs..."
@(
    "Application",
    "Security",
    "Setup",
    "System"
) | % {
         wevtutil clear-log $_
    }

Write-Host "Removing pagefile..."
Set-Itemproperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management' -Name 'PagingFiles' -value ''

Write-Host "Zeroing out empty space..."
$FilePath="c:\zero.tmp"
$Volume = Get-WmiObject win32_logicaldisk -filter "DeviceID='C:'"
$ArraySize= 64kb
$SpaceToLeave= $Volume.Size * 0.05
$FileSize= $Volume.FreeSpace - $SpacetoLeave
$ZeroArray= new-object byte[]($ArraySize)

$Stream= [io.File]::OpenWrite($FilePath)
try {
   $CurFileSize = 0
    while($CurFileSize -lt $FileSize) {
        $Stream.Write($ZeroArray,0, $ZeroArray.Length)
        $CurFileSize +=$ZeroArray.Length
    }
}
finally {
    if($Stream) {
        $Stream.Close()
    }
}

Del $FilePath
