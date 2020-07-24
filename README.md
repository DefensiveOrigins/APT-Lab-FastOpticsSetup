
![Defensive Origins](https://defensiveorigins.com/wp-content/uploads/2020/05/defensive-origins-header-6-1536x760.png)

# Applied Purple Teaming Threat Optics Lab - Fast Optics Stack 
Purple Teaming Attack &amp; Hunt Lab - Fast Optics with PowerShell


![PowerShell Input][PowershellInput]
```powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
```

#### Download using Invoke-WebRequest
Use Invoke-WebRequest to download the necessary components.  Each of these commands will download the package from the URI specified and save it to the filename specified with the -OutFile flag.  

![PowerShell Input][PowershellInput]
```powershell
Invoke-WebRequest –URI "https://github.com/dafthack/DomainPasswordSpray/archive/master.zip" -OutFile "~\Downloads\master.zip"
```

### Step 1 - DC First!
Launch PowerShell in bypass signature validation mode.
![PowerShell Input][PowershellInput]
```powershell
powershell -ep bypass
```
#### or 
```powershell
powershell.exe
set-executionpolicy bypass $confirm:false
```

### Step 2 - Download the DC-Configurator.ps1 file
![PowerShell Input][PowershellInput]
```powershell
./DC-configurator.ps1
```

The script downloads a number of archives, expands them and configures the entire Windows optics stack (minus the member server) as covered in the Applied Purple Teaming course material.

### Step 3 - The server will reboot at about the six minute mark!


  [PowershellInput]:https://img.shields.io/badge/Powershell-Input-green.svg?style=flat-sware
