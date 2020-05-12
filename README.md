# Carbon Black Response / VMware Carbon Black EDR Scripts

Collection of scripts for working with Carbon Black API.

**Note**: For the PowerShell scripts to work, you will need to create a PowerShell profile in your "C:\Users\UserName\Documents\WindowsPowerShell" folder.

Microsoft.PowerShell_profile.ps1
Microsoft.PowerShellISE_profile.ps1  - Only needed if you want to run the script from the ISE Editor

Add these two lines and replace "CbR-API-Token-Code" and "ServerName:Port" with your information. 
- New-Variable CBToken -value "CbR-API-Token-Code" -option ReadOnly
- New-Variable CBServer -value "ServerName:Port" -option ReadOnly

## **surveyor+ & surveyor++**
This script is based upon the Red Canary Surveyor script that queries data from Carbon Black Response / VMware Carbon Black EDR.

[https://github.com/redcanaryco/cb-response-surveyor](https://github.com/redcanaryco/cb-response-surveyor)

## **CbLR_DirListing**
This script uses CbLR to create a directory listing of a users profile.  

## **CBLR_GetFiles**
This script uses CbLR to copy files for forensic analysis from a machine using Carbon Black Response / VMware Carbon Black EDR.

---

## **Enumerate Watch List**
This PowerShell script will query the CbR watchlist and create a .csv file.  In the csv will be the watchlist name, date it was added, if it's enabled, total hits, description and search query.

## **Machine Status**
This PowerShell script will query a machine in Carbon Black Response / VMware Carbon Black EDR to see if it's online or offline

## **Machine Status Multiple Machine - Text File**
This script reads in the DeviceList.txt file and will display if a computer is found in Carbon Black Response / VMware Carbon Black EDR or not, if it's online, IP Address, etc. 

