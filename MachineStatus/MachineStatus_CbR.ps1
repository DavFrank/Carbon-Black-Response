#Generated Form Function
function GenerateForm {
########################################################################
# Code Generated By: SAPIEN Technologies PrimalForms (Community Edition) v1.0.10.0
# Generated On: 1/17/2018 3:33 PM
# Generated By: David Frank
# v1.2 - Added OS Version to screen using v0.5 of form
# v1.3 - Added global variable SensorID and call LiveResponse using it
# v1.4 - Added the trim statment to computername
########################################################################
$global:SensorID = ""
$global:strCreatedBy = "Created on 05.04.19  by David Frank - v1.4"

$CbR =
{
	$error.clear()
	
	$statusBar1.Text = "Searching......."

	$authToken = $CBToken

	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

	$computer = $txtComputer.text.toUpper().trim()

# Carbon Black Server and the Query
	$URLResource = "https://${CBServer}/api/v1/sensor"
	$ActiveComputer = $URLResource+"?hostname=$computer"

	$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
	$headers.add("x-auth-token",$authToken)

	$SystemInfo = Invoke-RestMethod -Uri $ActiveComputer  -Method Get -Headers $headers 

	if ( $error.count -eq 0)
	{
	# Display results on screen
			$txtComputer.Text = $computer
			$lblSensorID.Text = $SystemInfo[0].id
            $global:SensorID = $SystemInfo[0].id
			$lblStatus.Text = $SystemInfo[0].Status
			$lblInstallDate.Text = $SystemInfo[0].registration_time.substring(0,10)
			$lblLastUpdate.Text = $SystemInfo[0].last_update.substring(0,16)
			$lblCheckIn.Text = $SystemInfo[0].next_checkin_time.substring(0,16)
			$strIPAddress = $SystemInfo[0].network_adapters.split("',") 
			$lblIPAddress.Text = $strIPAddress[0]
            $lblOS_Version.Text = $SystemInfo[0].os_environment_display_string
			$lblCreatedBy.Text = $strCreatedBy

		if ($SystemInfo[0].Status -eq "Online")
		{
			$lblStatus.ForeColor = [System.Drawing.Color]::FromArgb(255,0,255,0)
		}
        Else
		{
            $lblStatus.ForeColor = [System.Drawing.Color]::FromArgb(255,255,0,0)
		}

		$statusBar1.Text = "Search Complete!"

		$lblIPAddress.Text | Set-Clipboard
	}
	else
	{
		&$ClearScreen
		$statusBar1.Text = "Computer Name not found in CbR!"
	}
}

$ClearScreen = 
{
	$lblSensorID.Text = " "
	$lblStatus.Text = " "
	$lblInstallDate.Text = " "
	$lblLastUpdate.Text = " "
	$lblCheckIn.Text = " "
	$strIPAddress = " "
	$lblIPAddress.Text = " "
    $lblOS_Version.Text = " "
}

$CbLR =
{
	$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
	Start-Process "python.exe" " $ScriptDir\cblr_cli.py --i $SensorID"
	$statusBar1.Text = "Live Response! "
    $statusBar1.Text = $SensorID
}


#region Import the Assemblies
[reflection.assembly]::loadwithpartialname("System.Drawing") | Out-Null
[reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
#endregion

#region Generated Form Objects
$form1 = New-Object System.Windows.Forms.Form
$lblOS_Version = New-Object System.Windows.Forms.Label
$lblOS_Version_Label = New-Object System.Windows.Forms.Label
$lblCreatedBy = New-Object System.Windows.Forms.Label
$btnLR = New-Object System.Windows.Forms.Button
$btnClose = New-Object System.Windows.Forms.Button
$lblCheckIn = New-Object System.Windows.Forms.Label
$lblLastUpdate = New-Object System.Windows.Forms.Label
$lblInstallDate = New-Object System.Windows.Forms.Label
$lblStatus = New-Object System.Windows.Forms.Label
$lblSensorID = New-Object System.Windows.Forms.Label
$lblHeader = New-Object System.Windows.Forms.Label
$lblLastUpdate_Label = New-Object System.Windows.Forms.Label
$lblInstallDate_Label = New-Object System.Windows.Forms.Label
$lblStatus_Label = New-Object System.Windows.Forms.Label
$lblSensor_Label = New-Object System.Windows.Forms.Label
$lblIPAddress = New-Object System.Windows.Forms.Label
$lblIPAddress_Label = New-Object System.Windows.Forms.Label
$statusBar1 = New-Object System.Windows.Forms.StatusBar
$btnSearch = New-Object System.Windows.Forms.Button
$txtComputer = New-Object System.Windows.Forms.TextBox
$lblComputerName_Label = New-Object System.Windows.Forms.Label
$lblCheckIn_Label = New-Object System.Windows.Forms.Label
$InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState
#endregion Generated Form Objects

#----------------------------------------------
#Generated Event Script Blocks
#----------------------------------------------
$btnLR_OnClick= 
{
	&$CbLR
}

$btnSearch_OnClick= 
{
	&$CbR
}

$btnClose_OnClick= 
{
	$form1.close()
}

$handler_form1_Load= 
{
	&$ClearScreen
}

$handler_txtComputer_Click= 
{
	&$ClearScreen
}


$OnLoadForm_StateCorrection=
{#Correct the initial state of the form to prevent the .Net maximized form issue
	$form1.WindowState = $InitialFormWindowState
}

#----------------------------------------------
#region Generated Form Code
$form1.BackgroundImage = [System.Drawing.Image]::FromFile('.\images\cues_bg.jpg')
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 288
$System_Drawing_Size.Width = 366
$form1.ClientSize = $System_Drawing_Size
$form1.DataBindings.DefaultDataSourceUpdateMode = 0
$form1.FormBorderStyle = 1
$form1.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon('.\images\Finder 1.ico')
$form1.Name = "form1"
$form1.Text = "CbR - Machine Status"
$form1.add_Load($handler_form1_Load)

$lblOS_Version.BackColor = [System.Drawing.Color]::FromArgb(0,255,255,255)
$lblOS_Version.DataBindings.DefaultDataSourceUpdateMode = 0
$lblOS_Version.ForeColor = [System.Drawing.Color]::FromArgb(255,255,255,0)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 105
$System_Drawing_Point.Y = 189
$lblOS_Version.Location = $System_Drawing_Point
$lblOS_Version.Name = "lblOS_Version"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 15
$System_Drawing_Size.Width = 200
$lblOS_Version.Size = $System_Drawing_Size
$lblOS_Version.TabIndex = 22
$lblOS_Version.Text = "OS Version"

$form1.Controls.Add($lblOS_Version)

$lblOS_Version_Label.BackColor = [System.Drawing.Color]::FromArgb(0,255,255,255)
$lblOS_Version_Label.DataBindings.DefaultDataSourceUpdateMode = 0
$lblOS_Version_Label.ForeColor = [System.Drawing.Color]::FromArgb(255,255,255,255)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 18
$System_Drawing_Point.Y = 189
$lblOS_Version_Label.Location = $System_Drawing_Point
$lblOS_Version_Label.Name = "lblOS_Version_Label"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 15
$System_Drawing_Size.Width = 100
$lblOS_Version_Label.Size = $System_Drawing_Size
$lblOS_Version_Label.TabIndex = 21
$lblOS_Version_Label.Text = "OS Version:"
$lblOS_Version_Label.add_Click($handler_label1_Click)

$form1.Controls.Add($lblOS_Version_Label)

$lblCreatedBy.BackColor = [System.Drawing.Color]::FromArgb(0,255,255,255)
$lblCreatedBy.DataBindings.DefaultDataSourceUpdateMode = 0
$lblCreatedBy.ForeColor = [System.Drawing.Color]::FromArgb(255,255,255,128)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 0
$System_Drawing_Point.Y = 248
$lblCreatedBy.Location = $System_Drawing_Point
$lblCreatedBy.Name = "lblCreatedBy"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 21
$System_Drawing_Size.Width = 360
$lblCreatedBy.Size = $System_Drawing_Size
$lblCreatedBy.TabIndex = 20
$lblCreatedBy.Text = $strCreatedBy
$lblCreatedBy.TextAlign = 2

$form1.Controls.Add($lblCreatedBy)


$btnLR.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 28
$System_Drawing_Point.Y = 214
$btnLR.Location = $System_Drawing_Point
$btnLR.Name = "btnLR"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 87
$btnLR.Size = $System_Drawing_Size
$btnLR.TabIndex = 19
$btnLR.Text = "Live Response"
$btnLR.UseVisualStyleBackColor = $True
$btnLR.add_Click($btnLR_OnClick)

$form1.Controls.Add($btnLR)


$btnClose.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 245
$System_Drawing_Point.Y = 214
$btnClose.Location = $System_Drawing_Point
$btnClose.Name = "btnClose"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 75
$btnClose.Size = $System_Drawing_Size
$btnClose.TabIndex = 18
$btnClose.Text = "Close"
$btnClose.UseVisualStyleBackColor = $True
$btnClose.add_Click($btnClose_OnClick)

$form1.Controls.Add($btnClose)

$lblCheckIn.BackColor = [System.Drawing.Color]::FromArgb(0,255,255,255)
$lblCheckIn.DataBindings.DefaultDataSourceUpdateMode = 0
$lblCheckIn.ForeColor = [System.Drawing.Color]::FromArgb(255,255,255,0)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 105
$System_Drawing_Point.Y = 146
$lblCheckIn.Location = $System_Drawing_Point
$lblCheckIn.Name = "lblCheckIn"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 15
$System_Drawing_Size.Width = 159
$lblCheckIn.Size = $System_Drawing_Size
$lblCheckIn.TabIndex = 17
$lblCheckIn.Text = "Next Check In"

$form1.Controls.Add($lblCheckIn)

$lblLastUpdate.BackColor = [System.Drawing.Color]::FromArgb(0,255,255,255)
$lblLastUpdate.DataBindings.DefaultDataSourceUpdateMode = 0
$lblLastUpdate.ForeColor = [System.Drawing.Color]::FromArgb(255,255,255,0)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 105
$System_Drawing_Point.Y = 126
$lblLastUpdate.Location = $System_Drawing_Point
$lblLastUpdate.Name = "lblLastUpdate"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 16
$System_Drawing_Size.Width = 159
$lblLastUpdate.Size = $System_Drawing_Size
$lblLastUpdate.TabIndex = 16
$lblLastUpdate.Text = "LastUpdate"

$form1.Controls.Add($lblLastUpdate)

$lblInstallDate.BackColor = [System.Drawing.Color]::FromArgb(0,255,255,255)
$lblInstallDate.DataBindings.DefaultDataSourceUpdateMode = 0
$lblInstallDate.ForeColor = [System.Drawing.Color]::FromArgb(255,255,255,0)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 105
$System_Drawing_Point.Y = 104
$lblInstallDate.Location = $System_Drawing_Point
$lblInstallDate.Name = "lblInstallDate"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 18
$System_Drawing_Size.Width = 159
$lblInstallDate.Size = $System_Drawing_Size
$lblInstallDate.TabIndex = 15
$lblInstallDate.Text = "Install Date"

$form1.Controls.Add($lblInstallDate)

$lblStatus.BackColor = [System.Drawing.Color]::FromArgb(0,255,255,255)
$lblStatus.DataBindings.DefaultDataSourceUpdateMode = 0
$lblStatus.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",8.25,1,3,1)
$lblStatus.ForeColor = [System.Drawing.Color]::FromArgb(255,255,0,0)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 105
$System_Drawing_Point.Y = 85
$lblStatus.Location = $System_Drawing_Point
$lblStatus.Name = "lblStatus"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 15
$System_Drawing_Size.Width = 100
$lblStatus.Size = $System_Drawing_Size
$lblStatus.TabIndex = 14
$lblStatus.Text = "Status"

$form1.Controls.Add($lblStatus)

$lblSensorID.BackColor = [System.Drawing.Color]::FromArgb(0,255,255,255)
$lblSensorID.DataBindings.DefaultDataSourceUpdateMode = 0
$lblSensorID.ForeColor = [System.Drawing.Color]::FromArgb(255,255,255,0)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 105
$System_Drawing_Point.Y = 65
$lblSensorID.Location = $System_Drawing_Point
$lblSensorID.Name = "lblSensorID"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 15
$System_Drawing_Size.Width = 100
$lblSensorID.Size = $System_Drawing_Size
$lblSensorID.TabIndex = 13
$lblSensorID.Text = "Sensor ID"

$form1.Controls.Add($lblSensorID)

$lblHeader.BackColor = [System.Drawing.Color]::FromArgb(0,255,255,255)
$lblHeader.DataBindings.DefaultDataSourceUpdateMode = 0
$lblHeader.Font = New-Object System.Drawing.Font("Times New Roman",14.25,0,3,1)
$lblHeader.ForeColor = [System.Drawing.Color]::FromArgb(255,255,255,255)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 116
$System_Drawing_Point.Y = 9
$lblHeader.Location = $System_Drawing_Point
$lblHeader.Name = "lblHeader"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 128
$lblHeader.Size = $System_Drawing_Size
$lblHeader.TabIndex = 12
$lblHeader.Text = "Machine Status"

$form1.Controls.Add($lblHeader)

$lblLastUpdate_Label.BackColor = [System.Drawing.Color]::FromArgb(0,255,255,255)
$lblLastUpdate_Label.DataBindings.DefaultDataSourceUpdateMode = 0
$lblLastUpdate_Label.ForeColor = [System.Drawing.Color]::FromArgb(255,255,255,255)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 18
$System_Drawing_Point.Y = 126
$lblLastUpdate_Label.Location = $System_Drawing_Point
$lblLastUpdate_Label.Name = "lblLastUpdate_Label"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 16
$System_Drawing_Size.Width = 81
$lblLastUpdate_Label.Size = $System_Drawing_Size
$lblLastUpdate_Label.TabIndex = 10
$lblLastUpdate_Label.Text = "Last Update:"

$form1.Controls.Add($lblLastUpdate_Label)

$lblInstallDate_Label.BackColor = [System.Drawing.Color]::FromArgb(0,255,255,255)
$lblInstallDate_Label.DataBindings.DefaultDataSourceUpdateMode = 0
$lblInstallDate_Label.ForeColor = [System.Drawing.Color]::FromArgb(255,255,255,255)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 18
$System_Drawing_Point.Y = 104
$lblInstallDate_Label.Location = $System_Drawing_Point
$lblInstallDate_Label.Name = "lblInstallDate_Label"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 18
$System_Drawing_Size.Width = 81
$lblInstallDate_Label.Size = $System_Drawing_Size
$lblInstallDate_Label.TabIndex = 9
$lblInstallDate_Label.Text = "Install Date:"

$form1.Controls.Add($lblInstallDate_Label)

$lblStatus_Label.BackColor = [System.Drawing.Color]::FromArgb(0,255,255,255)
$lblStatus_Label.DataBindings.DefaultDataSourceUpdateMode = 0
$lblStatus_Label.ForeColor = [System.Drawing.Color]::FromArgb(255,255,255,255)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 18
$System_Drawing_Point.Y = 84
$lblStatus_Label.Location = $System_Drawing_Point
$lblStatus_Label.Name = "lblStatus_Label"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 16
$System_Drawing_Size.Width = 81
$lblStatus_Label.Size = $System_Drawing_Size
$lblStatus_Label.TabIndex = 8
$lblStatus_Label.Text = "Status:"

$form1.Controls.Add($lblStatus_Label)

$lblSensor_Label.BackColor = [System.Drawing.Color]::FromArgb(0,255,255,255)
$lblSensor_Label.DataBindings.DefaultDataSourceUpdateMode = 0
$lblSensor_Label.ForeColor = [System.Drawing.Color]::FromArgb(255,255,255,255)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 17
$System_Drawing_Point.Y = 66
$lblSensor_Label.Location = $System_Drawing_Point
$lblSensor_Label.Name = "lblSensor_Label"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 14
$System_Drawing_Size.Width = 82
$lblSensor_Label.Size = $System_Drawing_Size
$lblSensor_Label.TabIndex = 7
$lblSensor_Label.Text = "Sensor ID:"

$form1.Controls.Add($lblSensor_Label)

$lblIPAddress.BackColor = [System.Drawing.Color]::FromArgb(0,255,255,255)
$lblIPAddress.DataBindings.DefaultDataSourceUpdateMode = 0
$lblIPAddress.ForeColor = [System.Drawing.Color]::FromArgb(255,255,255,0)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 105
$System_Drawing_Point.Y = 167
$lblIPAddress.Location = $System_Drawing_Point
$lblIPAddress.Name = "lblIPAddress"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 13
$System_Drawing_Size.Width = 90
$lblIPAddress.Size = $System_Drawing_Size
$lblIPAddress.TabIndex = 5
$lblIPAddress.Text = "10.10.10.10"

$form1.Controls.Add($lblIPAddress)

$lblIPAddress_Label.BackColor = [System.Drawing.Color]::FromArgb(0,255,255,255)
$lblIPAddress_Label.DataBindings.DefaultDataSourceUpdateMode = 0
$lblIPAddress_Label.ForeColor = [System.Drawing.Color]::FromArgb(255,255,255,255)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 18
$System_Drawing_Point.Y = 167
$lblIPAddress_Label.Location = $System_Drawing_Point
$lblIPAddress_Label.Name = "lblIPAddress_Label"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 13
$System_Drawing_Size.Width = 81
$lblIPAddress_Label.Size = $System_Drawing_Size
$lblIPAddress_Label.TabIndex = 4
$lblIPAddress_Label.Text = "IP Address:"

$form1.Controls.Add($lblIPAddress_Label)

$statusBar1.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 0
$System_Drawing_Point.Y = 266
$statusBar1.Location = $System_Drawing_Point
$statusBar1.Name = "statusBar1"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 22
$System_Drawing_Size.Width = 366
$statusBar1.Size = $System_Drawing_Size
$statusBar1.TabIndex = 3
$statusBar1.Text = "Enter Computer Name and Click the Search Button."

$form1.Controls.Add($statusBar1)


$btnSearch.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 143
$System_Drawing_Point.Y = 214
$btnSearch.Location = $System_Drawing_Point
$btnSearch.Name = "btnSearch"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 75
$btnSearch.Size = $System_Drawing_Size
$btnSearch.TabIndex = 2
$btnSearch.Text = "Search"
$btnSearch.UseVisualStyleBackColor = $True
$btnSearch.add_Click($btnSearch_OnClick)

$form1.Controls.Add($btnSearch)

$txtComputer.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 105
$System_Drawing_Point.Y = 39
$txtComputer.Location = $System_Drawing_Point
$txtComputer.Name = "txtComputer"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 159
$txtComputer.Size = $System_Drawing_Size
$txtComputer.TabIndex = 1
$txtComputer.Text = "$env:computername"
$txtComputer.add_Click($handler_txtComputer_Click)

$form1.Controls.Add($txtComputer)

$lblComputerName_Label.BackColor = [System.Drawing.Color]::FromArgb(0,255,255,255)
$lblComputerName_Label.DataBindings.DefaultDataSourceUpdateMode = 0
$lblComputerName_Label.ForeColor = [System.Drawing.Color]::FromArgb(255,255,255,255)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 18
$System_Drawing_Point.Y = 43
$lblComputerName_Label.Location = $System_Drawing_Point
$lblComputerName_Label.Name = "lblComputerName_Label"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 16
$System_Drawing_Size.Width = 104
$lblComputerName_Label.Size = $System_Drawing_Size
$lblComputerName_Label.TabIndex = 0
$lblComputerName_Label.Text = "Computer Name:"

$form1.Controls.Add($lblComputerName_Label)

$lblCheckIn_Label.BackColor = [System.Drawing.Color]::FromArgb(0,255,255,255)
$lblCheckIn_Label.DataBindings.DefaultDataSourceUpdateMode = 0
$lblCheckIn_Label.ForeColor = [System.Drawing.Color]::FromArgb(255,255,255,255)

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 18
$System_Drawing_Point.Y = 146
$lblCheckIn_Label.Location = $System_Drawing_Point
$lblCheckIn_Label.Name = "lblCheckIn_Label"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 15
$System_Drawing_Size.Width = 81
$lblCheckIn_Label.Size = $System_Drawing_Size
$lblCheckIn_Label.TabIndex = 11
$lblCheckIn_Label.Text = "Next Check-In:"

$form1.Controls.Add($lblCheckIn_Label)

#endregion Generated Form Code

#Save the initial state of the form
$InitialFormWindowState = $form1.WindowState
#Init the OnLoad event to correct the initial state of the form
$form1.add_Load($OnLoadForm_StateCorrection)
#Show the Form
$form1.ShowDialog()| Out-Null

} #End Function

#Call the Function
GenerateForm
