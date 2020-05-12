<#
.Synopsis
   The purpose of this script is to create a file listing of a users folder   
    from a machine using Carbon Black Live Response.  If they have OneDrive files 
    it will show where they are located (on the machine, cloud, both, etc)
.Description
   This script can be run either using psexec.exe or CbLR 
.Parameter UserFolder
    UserFolder so the script can access user profile information
.Example
   OneDrive_DirListing.ps1 DFrank
 .NOTES
   Author: David Frank  
   Version History
     1.0 - Initial release
#>

Param(
    [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
    [string]$UserFolder = $Null
)

Function DirectoryListing {

    $code = @'
    using System;

    [FlagsAttribute]
    public enum FileAttributesEx : uint {
	    Readonly = 0x00000001,
	    Hidden = 0x00000002,
	    System = 0x00000004,
	    Directory = 0x00000010,
	    Archive = 0x00000020,
	    Device = 0x00000040,
	    Normal = 0x00000080,
	    Temporary = 0x00000100,
	    SparseFile = 0x00000200,
	    ReparsePoint = 0x00000400,
	    Compressed = 0x00000800,
	    Offline = 0x00001000,
	    NotContentIndexed = 0x00002000,
	    Encrypted = 0x00004000,
	    IntegrityStream = 0x00008000,
	    Virtual = 0x00010000,
	    NoScrubData = 0x00020000,
	    EA = 0x00040000,
	    Pinned = 0x00080000,
	    Unpinned = 0x00100000,
	    U200000 = 0x00200000,
	    RecallOnDataAccess = 0x00400000,
	    U800000 = 0x00800000,
	    U1000000 = 0x01000000,
	    U2000000 = 0x02000000,
	    U4000000 = 0x04000000,
	    U8000000 = 0x08000000,
	    U10000000 = 0x10000000,
	    U20000000 = 0x20000000,
	    U40000000 = 0x40000000,
	    U80000000 = 0x80000000
    }
'@

    Add-Type $code

    $DirListing = Get-ChildItem "C:\Users\$UserFolder" -Recurse | where {$_.Attributes -notmatch 'Directory'}  | select CreationTime, LastWriteTime, LastAccessTime, Length, Name, FullName, Extension, @{n='Attributes';e={[fileAttributesex]$_.Attributes.Value__}} 

 foreach ($DirEntry in $DirListing) { 
     if ($DirEntry.Attributes -match ", Pinned")
     {
     $Location = "$($DirEntry.Attributes) ~ Pinned Locally"
     $Location = "Pinned Locally"
     }
      Elseif ($DirEntry.Attributes -match ", RecallOnDataAccess")
     {
     $Location = "$($DirEntry.Attributes) ~ Cloud Only"
     $Location = "Cloud Only"
     }
      Else 
     {
     $Location = "$($DirEntry.Attributes) ~ Available Locally"
     $Location = "Available Locally"
     }

     $MD5 = Get-FileHash $DirEntry.FullName -Algorithm MD5

     $ListingFields = @{Expression={$DirEntry.CreationTime};Label="Creation Time"}, `
         @{Expression={$DirEntry.LastWriteTime};Label="LastWriteTime"},
         @{Expression={$DirEntry.LastAccessTime};Label="LastAccessTime"},
         @{Expression={$DirEntry.Length};Label="Length"},
         @{Expression={$DirEntry.Name};Label="Name"},
         @{Expression={$DirEntry.FullName};Label="FullName"},
         @{Expression={$DirEntry.Extension};Label="Extension"},
         @{Expression={$DirEntry.Attributes};Label="Attributes"},
         @{Expression={$MD5.hash};Label="MD5"},
         @{Expression={$Location};Label="File_Location"}

     $DirEntry | Select-Object $ListingFields | Export-CSV $OutputFile -NoTypeInformation -Append
   
 }

}

Clear-Host

$OutputFile = "C:\Windows\CarbonBlack\ExportedFiles\DirectoryListing.csv"

# Clears the output file
$Null = Clear-Content $OutputFile -ErrorAction SilentlyContinue  

DirectoryListing