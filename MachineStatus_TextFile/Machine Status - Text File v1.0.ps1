# Author: David Frank
#
# Description: This script will provide status information for a computer within Carbon Black
#              it will read the computer name(s) from a text file in the same folder as the script.
#              The results will be stored in the variable "$SystemInfo"
#
# Version: 1.0 - 05/17/19 - Initial Version
#

$pshost = get-host
$pswindow = $pshost.ui.rawui
$newsize = $pswindow.buffersize
$newsize.height = 100

$newsize.width = 150
$pswindow.buffersize = $newsize
$newsize = $pswindow.windowsize
$newsize.height = 30
$newsize.width = 150
$pswindow.windowsize = $newsize

Clear-Host

Write-Host 'Starting to Check CbR.....' -fore white -back green
Write-Host ' '

$ErrorActionPreference = "SilentlyContinue"

$authToken = $CBToken

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null

$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path

$computers= get-content "$ScriptDir\DeviceList.txt"

# Carbon Black Server and the Query
$URLResource = "https://${CBServer}/api/v1/sensor"

$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.add("x-auth-token",$authToken)

# Format the fields that will be displayed
$a = @{Expression={$z.Computer_Name};Label="Computer Name";width=15}, `
     @{Expression={$z.id};Label="Sensor ID";width=12}, `
     @{Expression={$z.Status};Label="Status";width=12}, `
     @{Expression={$z.registration_time.substring(0,10)};Label="Install Date";width=14}, 
     @{Expression={$z.last_update.substring(0,16)};Label="Last Update";width=20}, `
     @{Expression={$z.next_checkin_time.substring(0,16)};Label="Next Check-in";width=20}, 
     @{Expression={$IP = $z.network_adapters.split("`,") ; $($IP[0])};Label="IP Address"; ;width=16},
     @{Expression={$z.os_environment_display_string.substring(0,21)};Label="OS Version";width=29} 

# Display the results for the 1st computer (known computer) to create the headers

    $ActiveComputer = $URLResource+"?hostname=XXXXXXXX"
    $SystemInfo = Invoke-RestMethod -Uri $ActiveComputer  -Method Get -Headers $headers 

    foreach ( $z in $SystemInfo )
    {
        ($z | ft $a | Out-String).Trim()  
    }

# Display the results for each cpmputer in the text file, if computer name not found a line will be displayed

foreach ($computer in $computers)
{
	$error.clear()
    $computer = $computer.Trim()
    $computer = $computer.ToUpper()

    if ($computer -ne "")
    { 
        $ActiveComputer = $URLResource+"?hostname=$computer"

        $SystemInfo = Invoke-RestMethod -Uri $ActiveComputer  -Method Get -Headers $headers 
 
        if ( $error.count -eq 0)
        {

    # Display the results

            $z = $SystemInfo[0]

            ($z | ft $a -HideTableHeaders | Out-String).Trim()  

        }
        else
        {
            write-host "$computer NOT found in CbR"  -fore white -back red
        }
        $SystemInfo = ""
    }
}

[void](Read-Host 'Press Enter to continue…')