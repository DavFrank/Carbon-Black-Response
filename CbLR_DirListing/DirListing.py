#!/usr/bin/env python
#
# Usage: python GetFiles_CbLR.py COMPUTERNAME UserFolder
#        
#
# 11/18/19 (DF) - v1.0 - Initial Version

import sys
import time
import os

#Import all Cb API python libraries
from cbapi.response import CbEnterpriseResponseAPI, Sensor

def main():

    dir_path =  os.path.abspath(os.path.dirname(__file__))

    print ("Carbon Black Live Response - Retrieving User Folder Directory Listing ")
    
    strScriptName = "DirListing.ps1"
    strComputerName = sys.argv[1]
    strUserName = sys.argv[2]

    cb = CbEnterpriseResponseAPI()

    sensor = cb.select(Sensor).where("hostname:"+ strComputerName).first()

    if not sensor:
        print ("Computer not found!")
    elif sensor.status == "Offline":
        print ("")
        print ("Computer", strComputerName, "is", sensor.status)
        print ("")
        os.system("pause")
    else:
        print ("")
        print ("Computer Name:", strComputerName)
        print ("")
        print ("Sensor ID:", sensor.id)
        print ("")
        
        sensor_id = sensor.id

        sensor = cb.select(Sensor, sensor_id)

        with sensor.lr_session() as session:
# Create a folder under C:\Windows\CarbonBlack named ExportedFiles
            path = "C:\\Windows\\CarbonBlack\\ExportedFiles"
            try:
                print ("Creating direcotry: C:\Windows\CarbonBlack\ExportedFiles" )
                session.create_directory(path)
            except Exception as e:
                print ("  Directory already exists: %s" % e)

# Upload Script to the folder
            print (" ")
            print(("Uploading {0}....").format(strScriptName))
            print (" ")
            binary = r'{0}'.format(strScriptName)
            with open(binary, 'rb') as filedata:
                try:
                    session.put_file(filedata.read(), "C:\\Windows\\CarbonBlack\\ExportedFiles\\" + binary)
                except Exception as e:
                    session.close() 

# Run PowerShell Script
            command = r'PowerShell.exe -nologo -file C:\Windows\CarbonBlack\ExportedFiles\{0} {1}'.format(strScriptName, strUserName)
            print("Executing: '{0}' ".format(command))
            session.create_process(command, wait_timeout=900, wait_for_completion=True) 

# Download .CSV file 
            FileLocation = r'C:\Windows\CarbonBlack\ExportedFiles'
            filename = "DirectoryListing.csv"
            print (" ")
            print("Downloading DirectoryListing.csv....")            
            open("{0}\Output\{2}_{1}".format(dir_path,filename,strComputerName),"wb").write(session.get_file(FileLocation + "\{0}".format(filename)))

# Sleep for 30 sec before removing folder
            print (" ")
            print ("Sleep 15 sec after Downloading .CSV file")
            time.sleep(15)

# Remove Folder on remote computer
            command = r'cmd /c rmdir C:\Windows\CarbonBlack\ExportedFiles /s /q'
            print("Executing: '{0}' ".format(command))
            session.create_process(command, wait_timeout=30, wait_for_completion=True) 
            
        session.close()

if __name__ == "__main__":
    main()
