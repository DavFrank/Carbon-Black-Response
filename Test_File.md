# surveyor+TH

### About
A Python utility that queries Carbon Black ThreatHunter / VMware Carbon Black Enterprise EDR and summarizes results. This has many uses, but is used primarily to understand where certain applications or activities exist within an enterprise, who is using them and how.

This script is based upon the Red Canary surveyor.  
    [https://github.com/redcanaryco/cb-response-surveyor](https://github.com/redcanaryco/cb-response-surveyor)

------------
### Using
Create and populate your cbapi credential file per the instructions found here: https://github.com/carbonblack/cbapi-python.

This script is designed to be run on a Windows machine, it will create two files in the output folder.  The 1st is what is displayed in the console when you run the script and the 2nd is the output in csv format with a date/time stamp as part of the filename.

Ex:  
- Hostname-2020.05.04-T123835.txt - The console screen
- Hostname-2020.05.04-T123835.csv - The output of the command

Run using one of the test definitions:

./surveyor+TH.py --deffile definitions/file-transfer.json
Then open and review the default output file (survey.csv).

You can also run using an entire directory of definition files in one shot:

./surveyor+TH.py --defdir definitions
If you're looking for instances of something specific and a Cb query suits you best, you can do that too:

./surveyor+TH.py --query 'process_name:explorer.exe AND process_username:joebob'

