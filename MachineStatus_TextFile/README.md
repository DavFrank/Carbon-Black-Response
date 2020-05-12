# Machine Status Multiple Machine - Text File

**Description**: This script reads in the DeviceList.txt file, which should have one computer name per line.  It will display if a computer is found in Carbon Black Response / VMware Carbon Black EDR or not and if it's online, IP Address, etc.  The results will be stored in the variable "$SystemInfo"


This script can be used to determine IP Address for machines on VPN, for Forensics, eDiscovery & IR teams to determine if machines are online. 

**Requirements**:

Note: Script edit need before 1st use:
Replace "XXXXXXXX" on Line 57 with a valid computer name.  I did this since I couldn't figure out how to get the headers if the 1st computer was not a valid machine.
- Line 57 - $ActiveComputer = $URLResource+"?hostname=XXXXXXXX"


**Usage**:

Run "Machine Status - Text File v1.0.ps1" which will launch notepad.exe and opening DeviceList.txt file.  Put one computer name per line and then save and close Notepad.  The script will then query Carbon Black and return the results to the screen.

**Output Fields**:

Computer Name, Sensor ID, Status, Install Date, Last Update, Next Check-in, IP Address, OS Version

