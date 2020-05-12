<#
.Synopsis
   The purpose of this script is copy files for forensic analysis from a machine using Carbon Black Live Response
.Description
   This script can be run either using psexec.exe or CbLR 
.Parameter Collection
    Type of files you want to download
        AutoRuns - Autoruns64.exe  (Put in same folder as this script)
        BrowserFiles - WebCacheV01.dat, History, Preferences
        EventLogs - Application, Security, System
        PreferencesFile - Google Preferences file
        Registry - NTUSER.DAT, SYSTEM, SOFTWARE
        SecurityEventLog - Security
.Parameter UserFolder
    UserFolder so the script can copy user profile information
.Example
   GetFiles_CbLR.ps1 BrowserFiles DFrank
.Example
   GetFiles_CbLR.ps1 ALL DFrank
 .NOTES
   Author: David Frank   
   Version History
     1.0 - Initial release
#>

[CmdletBinding(SupportsShouldProcess=$True)]
Param(
    [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
    [string]$Collection = $Null,
    [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
    [string]$UserFolder = $Null
)


Function AutoRuns{
    Write-Host "AutoRuns"

    $AutoRuns = "$CurrentDir\Autoruns64.exe"
    $Argument = "/accepteula -a $CurrentDir\Files\autoruns.arn"

    $FileExists = Test-Path $AutoRuns -pathtype leaf

    If ($FileExists -eq $True) {
        Start-Process $AutoRuns -ArgumentList $Argument -Wait
        Remove-Item $AutoRuns
    }
}


Function BrowserFiles {
    Write-Host "BrowserFiles"

    $Argument = "/FileNamePath:C:\Users\$UserFolder\AppData\Local\Microsoft\Windows\WebCache\WebCacheV01.dat /Outputpath:$CurrentDir\Files"
    Start-Process $RamCopy64 -ArgumentList $Argument -Wait

# Test if Google Chrome is installed
    $strFolder = "C:\Users\$UserFolder\AppData\Local\Google\Chrome\User Data\Default\History"
    $FolderExists = Test-Path $strFolder -pathtype Leaf

    If ($FolderExists -eq $True) {
        $Argument = "/filenamepath:`"C:\Users\$UserFolder\AppData\Local\Google\Chrome\User Data\Default\History`" /Outputpath:$CurrentDir\Files"
        Start-Process $RamCopy64 -ArgumentList $Argument -Wait

        $Argument = "/FileNamePath:`"C:\Users\$UserFolder\AppData\Local\Google\Chrome\User Data\Default\Preferences`" /Outputpath:$CurrentDir\Files"
        Start-Process $RamCopy64 -ArgumentList $Argument -Wait
    }
}


Function EventLogs {
    Write-Host "EventLogs"

    $args="/FileNamePath:C:\Windows\System32\winevt\Logs\Security.evtx /Outputpath:$CurrentDir\Files"
    Start-Process $RamCopy64 -ArgumentList $args -Wait


    $args="/FileNamePath:C:\Windows\System32\winevt\Logs\Application.evtx /Outputpath:$CurrentDir\Files"
    Start-Process $RamCopy64 -ArgumentList $args -Wait

    $args="/FileNamePath:C:\Windows\System32\winevt\Logs\System.evtx /Outputpath:$CurrentDir\Files"
    Start-Process $RamCopy64 -ArgumentList $args -Wait
}

Function NTUSER {
    Write-Host "Registry"

    $args="/FileNamePath:C:\Users\$UserFolder\NTUSER.DAT /Outputpath:$CurrentDir\Files"
    Start-Process $RamCopy64 -ArgumentList $args -Wait
}

Function PreferencesFile {
    Write-Host "PreferencesFile"

# Test if Google Chrome is installed
    $strFolder = "C:\Users\$UserFolder\AppData\Local\Google\Chrome\User Data\Default\Preferences"
    $FolderExists = Test-Path $strFolder -pathtype Leaf

    If ($FolderExists -eq $True) {
        $Argument = "/FileNamePath:`"C:\Users\$UserFolder\AppData\Local\Google\Chrome\User Data\Default\Preferences`" /Outputpath:$CurrentDir\Files"
        Start-Process $RamCopy64 -ArgumentList $Argument -Wait
    }
}

Function Registry {
    Write-Host "Registry"

    $args="/FileNamePath:C:\Users\$UserFolder\NTUSER.DAT /Outputpath:$CurrentDir\Files"
    Start-Process $RamCopy64 -ArgumentList $args -Wait


    $args="/FileNamePath:C:\WINDOWS\system32\config\SYSTEM /Outputpath:$CurrentDir\Files"
    Start-Process $RamCopy64 -ArgumentList $args -Wait

    $args="/FileNamePath:C:\WINDOWS\system32\config\SOFTWARE /Outputpath:$CurrentDir\Files"
    Start-Process $RamCopy64 -ArgumentList $args -Wait
}

Function SecurityEventLog {
    Write-Host "SecurityEventLog"

    $args="/FileNamePath:C:\Windows\System32\winevt\Logs\Security.evtx /Outputpath:$CurrentDir\Files"
    Start-Process $RamCopy64 -ArgumentList $args -Wait
}

Function CompressandDeleteFiles {
    Compress-Archive $CurrentDir\files\. $CurrentDir\ExportedFiles.zip -force

    Remove-Item –path "$CurrentDir\Files" –recurse -ErrorAction SilentlyContinue
    Remove-Item $RamCopy64 -ErrorAction SilentlyContinue
    Remove-Item "IR_GetFiles.ps1" -ErrorAction SilentlyContinue  
}

Clear-Host

$CurrentDir = "C:\Windows\CarbonBlack\ExportedFiles"

# Create the Files directory if it doesn't exist
    New-Item -ItemType Directory -Force -Path $CurrentDir\Files | Out-Null

# Create text file with parameters that were used to call this scripts
    $OutputFile = "$CurrentDir\Files\Readme.txt"
    "Collection Name: $Collection" | Add-Content $OutputFile
    "UserFolder: $UserFolder" | Add-Content $OutputFile

switch ($Collection) {
    'AutoRuns' {
        AutoRuns
        CompressandDeleteFiles
    }
    default {
        $global:RamCopy64 = "$CurrentDir\RawCopy64.exe"
        $FileExists = Test-Path $RamCopy64 -pathtype leaf

        switch ($Collection) {
            'All' {
                AutoRuns
                BrowserFiles
                EventLogs
                Registry
                SecurityEventLog
                CompressandDeleteFiles

            }
            'Basic' {
                BrowserFiles
                EventLogs
                Registry
                SecurityEventLog
                CompressandDeleteFiles
            }
            'BrowserFiles' {
                BrowserFiles
                CompressandDeleteFiles
            }
            'EventLogs' {
                EventLogs
                CompressandDeleteFiles
            }
            'NTUSER' {
                NTUSER
                CompressandDeleteFiles
            }
            'PreferencesFile' {
                PreferencesFile
                CompressandDeleteFiles
            }
            'Registry' {
                Registry
                CompressandDeleteFiles
            }
            'SecurityEventLog' {
                SecurityEventLog
                CompressandDeleteFiles
            }
        }
    }
}