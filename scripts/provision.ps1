
<#$secpasswd = ConvertTo-SecureString 'vagrant' -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ('vagrant', $secpasswd)

Set-ExecutionPolicy Bypass -Force
$WinlogonPath = 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon'
Remove-ItemProperty -Path $WinlogonPath -Name AutoAdminLogon
Remove-ItemProperty -Path $WinlogonPath -Name DefaultUserName
#>

. a:\Test-Command.ps1

#enable RDP
'Enabling RDP' | Out-File c:\logs\logfile.txt -append
Write-Host 'Enabling RDP'
netsh advfirewall firewall add rule name="Remote Desktop" dir=in localport=3389 protocol=TCP action=allow
reg add 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server' /v fDenyTSConnections /t REG_DWORD /d 0 /f

#Import-Module PackageManagement -Force
#Get-PackageSource -Force -ForceBootstrap -Provider chocolatey 

'Installing Guest Additions' | Out-File c:\logs\logfile.txt -append
Write-Host 'Installing Guest Additions'
& cmd /c certutil -addstore -f 'TrustedPublisher' A:\oracle-cert.cer

if (Test-Path e:\VBoxWindowsAdditions.exe) {
& E:\VBoxWindowsAdditions.exe /S
} else {
    
    & E:\PTAgent.exe /install_silent
}

Set-ItemProperty -Path 'HKLM:\SYSTEM\Setup\Status\SysprepStatus'  -Name  'GeneralizationState' -Value 7

Write-Host 'Sdelete things'

Copy-Item a:\sdelete.exe c:\logs
& cmd /c %SystemRoot%\System32\reg.exe ADD HKCU\Software\Sysinternals\SDelete /v EulaAccepted /t REG_DWORD /d 1 /f
& cmd /c C:\logs\sdelete.exe -q -z C:

Write-Host "Setting short date format"
Set-ItemProperty -Path "HKCU:\Control Panel\International" -Name sShortDate -Value yyyy-MM-dd

Write-Host "Removing page file"
$pageFileMemoryKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"
Set-ItemProperty -Path $pageFileMemoryKey -Name PagingFiles -Value ""

#if(Test-PendingReboot){ Invoke-Reboot }
#windows-restart

Write-Host "defragging..."
if (Test-Command -cmdname 'Optimize-Volume') {
    Optimize-Volume -DriveLetter C
    } else {
    Defrag.exe c: /H
}

Write-Host "0ing out empty space..."
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

Write-Host "Recreate pagefile after sysprep"
$System = GWMI Win32_ComputerSystem -EnableAllPrivileges
if ($system -ne $null) {
  $System.AutomaticManagedPagefile = $true
  $System.Put()
}

Write-Host 'Done'
