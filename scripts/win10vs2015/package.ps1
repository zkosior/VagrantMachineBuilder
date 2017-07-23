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


cinst fiddler4
cinst visualstudiocode
cinst linqpad
cinst beyondcompare
cinst windbg
cinst NugetPackageExplorer
cinst sysinternals
cinst baretail
cinst TortoiseGit

cinst firefox
cinst opera

cinst VisualStudio2015Enterprise
if (Test-PendingReboot) { Invoke-Reboot }

Install-ChocolateyVsixPackage WebTools https://visualstudiogallery.msdn.microsoft.com/c94a02e9-f2e9-4bad-a952-a63a967e3935
Install-ChocolateyVsixPackage ProductivityPowerTools https://visualstudiogallery.msdn.microsoft.com/34ebc6a2-2777-421d-8914-e29c1dfa7f5d
Install-ChocolateyVsixPackage PowerShellTools https://visualstudiogallery.msdn.microsoft.com/c9eb3ba8-0c59-4944-9a62-6eee37294597
Install-ChocolateyVsixPackage RefactoringEssentials https://visualstudiogallery.msdn.microsoft.com/68c1575b-e0bf-420d-a94b-1b0f4bcdcbcc
Install-ChocolateyVsixPackage StopOnFirstBuildError https://visualstudiogallery.msdn.microsoft.com/91aaa139-5d3c-43a7-b39f-369196a84fa5

Install-ChocolateyPinnedTaskBarItem "$($Boxstarter.programFiles86)\Google\Chrome\Application\chrome.exe"
Install-ChocolateyPinnedTaskBarItem "$($Boxstarter.programFiles)\Mozilla Firefox\firefox.exe"
Install-ChocolateyPinnedTaskBarItem "$env:windir\syswow64\WindowsPowerShell\v1.0\powershell.exe"
Install-ChocolateyPinnedTaskBarItem "$($Boxstarter.programFiles86)\Microsoft Visual Studio 14.0\Common7\IDE\devenv.exe"

if (Test-PendingReboot) { Invoke-Reboot }

cmd.exe /c C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -file a:\bootstrap.ps1