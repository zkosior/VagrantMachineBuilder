$Boxstarter.RebootOk=$true

Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions
Set-StartScreenOptions -EnableBootToDesktop
Disable-UAC

if (Test-PendingReboot) { Invoke-Reboot }

Enable-MicrosoftUpdate
Install-WindowsUpdate -AcceptEula
if (Test-PendingReboot) { Invoke-Reboot }

#cinstm qttabbar
cinst googlechrome
cinst 7zip
cinst adobereader
cinst notepadplusplus
cinst visualstudiocode

Enable-UAC

if (Test-PendingReboot) { Invoke-Reboot }

Install-ChocolateyPinnedTaskBarItem "$($Boxstarter.programFiles86)\Google\Chrome\Application\chrome.exe"
Install-ChocolateyPinnedTaskBarItem "$env:windir\syswow64\WindowsPowerShell\v1.0\powershell.exe"

cmd.exe /c C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -file a:\bootstrap.ps1