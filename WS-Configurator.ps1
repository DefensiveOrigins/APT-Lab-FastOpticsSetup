cd \\dc01\labs\sysmon\
./sysmon64.exe -accepteula -i sysmonconfig.xml
Get-WinEvent -LogName Microsoft-Windows-Sysmon/Operational
gpupdate /force
Restart-Computer
