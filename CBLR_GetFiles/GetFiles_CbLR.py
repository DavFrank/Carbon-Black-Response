#!/usr/bin/env python
#
# Usage: python GetFiles_CbLR.py COMPUTERNAME COLECTION_TYPE RACF
#        
#
# 04/05/19 (DF) - v1.0 - Initial Version
# 04/09/19 (DF) - v1.1 - Changed output location to Output folder
# 04/16/19 (DF) - v1.2 - Added check for computer status - Exit if Offline
# 05/06/20 (DF) - v1.3 - Updated for Python v3.x

import sys
import time
import os

#Import all Cb API python libraries
from cbapi.response import CbEnterpriseResponseAPI, Sensor

def main():
    dir_path =  os.path.abspath(os.path.dirname(__file__))

    print ("Carbon Black Live Response - Retrieving Files ")
    
    strScriptName = "GetFiles_CbLR.ps1"
    strComputerName = sys.argv[1]
    strCollection = sys.argv[2]
    strUserName = sys.argv[3]

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

# Create a folder under C:\Windows\CarbonBlack\ExportedFiles named Files
            path = "C:\\Windows\\CarbonBlack\\ExportedFiles\Files"
            try:
                print ("Creating direcotry: C:\Windows\CarbonBlack\ExportedFiles\Files" )
                session.create_directory(path)
            except Exception as e:
                print ("  Directory already exists: %s" % e)
                
# Upload RawCopy64.exe to the folder
            print (" ")
            print("Uploading RawCopy64.exe....")
            binary = r'RawCopy64.exe'
            with open(binary, 'rb') as filedata:
                try:
                    session.put_file(filedata.read(), "C:\\Windows\\CarbonBlack\\ExportedFiles\\" + binary)
                except Exception as e:
                    session.close() 

# Upload AutoRuns.exe to the folder
            if (strCollection == "AutoRuns") or (strCollection == "All"):
                print (" ")
                print("Uploading Autoruns64.exe....")
                binary = r'Autoruns64.exe'
                with open(binary, 'rb') as filedata:
                    try:
                        session.put_file(filedata.read(), "C:\\Windows\\CarbonBlack\\ExportedFiles\\" + binary)
                    except Exception as e:
                        session.close() 
            
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
            command = r'PowerShell.exe -nologo -file C:\Windows\CarbonBlack\ExportedFiles\{0} {1} {2}'.format(strScriptName, strCollection, strUserName)
            print(("Executing: '{0}' ".format(command)))
            session.create_process(command, wait_timeout=900, wait_for_completion=True) 

# Download .ZIP file 
            FileLocation = r'C:\Windows\CarbonBlack\ExportedFiles'
            filename = "ExportedFiles.Zip"
            print (" ")
            print("Downloading ExportedFiles.Zip....")            
            open("{0}\Output\{2}_{1}".format(dir_path,filename,strComputerName),"wb").write(session.get_file(FileLocation + "\{0}".format(filename)))

# Sleep for 30 sec before removing folder
            print (" ")
            print ("Sleep 30 sec after Downloading .ZiP file")
            time.sleep(30)

# Remove Folder on remote computer
            command = r'cmd /c rmdir C:\Windows\CarbonBlack\ExportedFiles /s /q'
            print(("Executing: '{0}' ".format(command)))
            session.create_process(command, wait_timeout=30, wait_for_completion=True) 
            
        session.close()

if __name__ == "__main__":
    main()
