
![Defensive Origins](https://defensiveorigins.com/wp-content/uploads/2020/05/defensive-origins-header-6-1536x760.png)

# Applied Purple Teaming Threat Optics Lab - Fast Optics Stack 
## Purple Teaming Attack &amp; Hunt Lab - Fast Optics with PowerShell

The purpose of these scripts is to streamline the optics deployment process. Have you been through the course before and just want a rapid optics deployment? The scripts will download relevant materials including the LABPACK repo which contains group policy objects, and a few other things. 

#### These scripts are intended to be executed on the domain controller and member server in this order. Once the scripts are complete, log data will be shipping from the Windows environment to Kafka on HELK. 

### Step 1 - Access the DC first!
![PowerShell Input][PowershellInput]
#### Launch PowerShell in bypass signature validation mode.

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
./DC-Configurator.ps1
```

The script downloads a number of archives, expands them and configures the entire Windows optics stack (minus the member server) as covered in the Applied Purple Teaming course material.

### Step 3 - The server will reboot at about the six minute mark!


  [PowershellInput]:https://img.shields.io/badge/Powershell-Input-green.svg?style=flat-sware
