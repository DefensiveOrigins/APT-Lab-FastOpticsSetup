
![Defensive Origins](https://defensiveorigins.com/wp-content/uploads/2020/05/defensive-origins-header-6-1536x760.png)

# Applied Purple Teaming Threat Optics Lab - Fast Optics Stack 
Purple Teaming Attack &amp; Hunt Lab - Fast Optics with PowerShell

# Step 1 - DC First!
Launch PowerShell in bypass signature validation mode. 
(powershell -ep bypass)
or 
(powershell.exe)
set-executionpolicy bypass $confirm:false

# Step 2 - Download the DC-Configurator.ps1 file
./DC-configurator.ps1

The script downloads a number of archives, expands them and configures the entire Windows optics stack (minus the member server) as covered in the Applied Purple Teaming course material.

# Step 3 - The server will reboot at about the six minute mark!
