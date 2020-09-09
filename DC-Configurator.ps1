cd c:\labs
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -URI https://download.sysinternals.com/files/Sysmon.zip -OutFile "Sysmon.zip" 
Invoke-WebRequest -URI https://artifacts.elastic.co/downloads/beats/winlogbeat/winlogbeat-7.7.1-windows-x86_64.zip -OutFile "WinLogBeat.zip"
Invoke-WebRequest -URI https://github.com/olafhartong/sysmon-modular/archive/master.zip -OutFile "sysmon-modular.zip" 
Invoke-WebRequest -URI https://github.com/palantir/windows-event-forwarding/archive/master.zip -OutFile "palantir.zip"
Invoke-WebRequest -URI https://github.com/DefensiveOrigins/LABPACK/archive/master.zip -OutFile LabPack.zip
Expand-Archive .\Sysmon.zip 
Expand-Archive .\sysmon-modular.zip 
Expand-Archive .\palantir.zip 
Expand-Archive .\WinLogBeat.zip 
Expand-Archive .\LabPack.zip 
Expand-Archive .\labs.zip
Set-ExecutionPolicy Bypass -Force -Confirm:$false
cd C:\labs\sysmon-modular\sysmon-modular-master
Import-Module .\Merge-SysmonXml.ps1 
Merge-AllSysmonXml -Path ( Get-ChildItem '[0-9]*\*.xml') -AsString | Out-File sysmonconfig.xml
Get-Content ".\sysmonconfig.xml " | select -First 10
cp C:\LABS\sysmon-modular\sysmon-modular-master\sysmonconfig.xml c:\labs\sysmon\sysmonconfig.xml
cd \\dc01\labs\sysmon\
./sysmon64.exe -accepteula -i sysmonconfig.xml
Get-WinEvent -LogName Microsoft-Windows-Sysmon/Operational
Import-GPO -Path "\\dc01\LABS\LabPack\LABPACK-master\Lab-GPOs\Enhanced-WS-Auditing\" -BackupGpoName "Enhanced WS Auditing" -CreateIfNeeded -TargetName "WS-Enhanced-Auditing" -Server DC01
Import-GPO -Path "\\dc01\LABS\LabPack\LABPACK-master\Lab-GPOs\Enhanced-DC-Auditing\" -BackupGpoName "Enhanced DC Auditing" -CreateIfNeeded -TargetName "DC-Enhanced-Auditing" -Server DC01
Import-GPO -Path "\\dc01\LABS\LabPack\LABPACK-master\Lab-GPOs\Enable-WinRM-and-RDP\" -BackupGpoName "Enable-WinRM-and-RDP" -CreateIfNeeded -TargetName "Enable-WinRM-and-RDP" -Server DC01
New-GPLink -Name "WS-Enhanced-Auditing" -Target "dc=labs,dc=local" -LinkEnabled Yes
New-GPLink -Name "DC-Enhanced-Auditing" -Target "ou=Domain Controllers,dc=labs,dc=local" -LinkEnabled Yes
New-GPLink -Name "Enable-WinRM-and-RDP" -Target "dc=labs,dc=local" -LinkEnabled Yes
Get-GPOReport -Name "Enable-WinRM-and-RDP" -ReportType HTML -Path "c:\Labs\GPOReport-Enable-WinRM-and-RDP.html"
Get-GPOReport -Name "WS-Enhanced-Auditing" -ReportType HTML -Path "c:\Labs\GPOReport-WS-Enhanced-Auditing.html" 
Get-GPOReport -Name "DC-Enhanced-Auditing" -ReportType HTML -Path "c:\Labs\GPOReport-DC-Enhanced-Auditing.html"
Import-GPO -Path "\\dc01\LABS\LabPack\LABPACK-master\Lab-GPOs\Windows Event Forwarding" -BackupGpoName "Windows Event Forwarding" -CreateIfNeeded -TargetName "Windows Event Forwarding" -Server DC01
Get-GPRegistryValue -Name "Windows Event Forwarding" -Key HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\EventLog\EventForwarding\SubscriptionManager
Set-GPRegistryValue -Name "Windows Event Forwarding" -Key HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\EventLog\EventForwarding\SubscriptionManager -ValueName "1" -Type String -Value "Server=http://dc01.labs.local:5985/wsman/SubscriptionManager/WEC,Refresh=60"
Get-GPRegistryValue -Name "Windows Event Forwarding" -Key HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\EventLog\EventForwarding\SubscriptionManager
New-GPLink -Name "Windows Event Forwarding" -Target "dc=labs,dc=local" -LinkEnabled Yes
Get-GPOReport -Name "Windows Event Forwarding" -ReportType HTML -Path "c:\Labs\GPOReport-Windows-Event-Forwarding.html"
wecutil qc /q
net stop wecsvc
wevtutil um C:\windows\system32\CustomEventChannels.man
cp C:\LABS\LabPack\LABPACK-master\Lab-WEF-Palantir\windows-event-channels\CustomEventChannels.* C:\windows\System32\
wevtutil im C:\windows\system32\CustomEventChannels.man
net start wecsvc
Get-WinEvent -ListLog WEC*
cd C:\LABS\LabPack\LABPACK-master\Lab-WEF-Palantir\wef-subscriptions
foreach ($file in (Get-ChildItem *.xml)) {wecutil cs $file}
Wevtutil gl WEC3-PRINT
foreach ($subscription in (wevtutil el | select-string -pattern "WEC")) {wevtutil sl $subscription /ms:4194304}
Wevtutil gl WEC3-PRINT
gpupdate /force
mv C:\labs\WinLogBeat\winlogbeat-7.7.1-windows-x86_64\winlogbeat.yml C:\labs\WinLogBeat\winlogbeat-7.7.1-windows-x86_64\winlogbeat.yml.old
cp C:\labs\LabPack\LABPACK-master\Lab-WinLogBeat\winlogbeat.yml C:\labs\WinLogBeat\winlogbeat-7.7.1-windows-x86_64\winlogbeat.yml
cd c:\labs\WinLogBeat\winlogbeat-7.7.1-windows-x86_64\
powershell -Exec bypass -File .\install-service-winlogbeat.ps1
Set-Service -Name "winlogbeat" -StartupType automatic
Start-Service -Name "winlogbeat"
Get-Service winlogbeat
cd c:\labs\WinLogBeat\winlogbeat-7.7.1-windows-x86_64\
.\winlogbeat.exe test config -c .\winlogbeat.yml -e
Restart-Computer
