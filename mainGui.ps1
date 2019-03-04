#@Title: PowerShell Script Utility GUI
#@Author: Michael Garrison
#@Published: 3/4/19
#@Description: Provide a Graphical User Interface utility that shows your information about scripts, including Title, Author, Publish Date, and Description, and allows your to run them

Add-Type -assembly System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

###################################################################
# Configure the settings in the section for your application
###################################################################

$LaunchFromEXE = $false                     # If you plan to use something like PS2EXE, set this to $true before you convert
$ExecScripsWithRunAs = $false               # If you want scripts to be run as a different user, set to $true
$ScriptDirectory = $null                    # If you have a custom path (like C:\scripts), set value here.  Leave $null if you want to use default script directory
$PanelColor = "#e54a48"                     # Set the color of the side panel
$PanelImageName = "logo.png"                # Set the image name of logo you wish to use
$ScriptName = "PowerShell Script Utility"   # Set the title of GUI script

# End Configuration

###################################################################
# Check above configuration and set variables
###################################################################

# Check and set directory of scripts folder
if ($ScriptDirectory -ne $null) { $scriptsDir = $ScriptDirectory }
else { $scriptsDir = Join-Path $PSScriptRoot "scripts" }

# Check if set to launch from an exe wrapper or not
if ($LaunchFromEXE -ne $false) {
    $FullPathToEXE = [System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName
    $PSScriptRoot = [System.IO.Path]::GetDirectoryName($FullPathToEXE)
} elseif ($LaunchFromEXE -ne $true) {
    # Set PSScriptRoot for PowerShell V2 compatibility
    $PSScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
} else { Write-Host "Error with Script Directory Path" }

# Check if scripts will use 'Run As' verb
if ($ExecScripsWithRunAs -ne $false) { $verb = 'runAs' }
else { $verb = 'open' }

# End configuration checking

###################################################################
# Build the GUI
###################################################################

$Form                   = New-Object system.Windows.Forms.Form
$Form.ClientSize        = '600,400'
$Form.text              = $ScriptName
$Form.BackColor         = "#ffffff"
$Form.TopMost           = $false
$Form.FormBorderStyle   = 'Fixed3D'
$Form.MaximizeBox       = $false

$flowlayoutpanel1 = New-Object System.Windows.Forms.FlowLayoutPanel
$flowlayoutpanel = New-Object System.Windows.Forms.FlowLayoutPanel
$flowlayoutpanel.AutoScroll = $True
$flowlayoutpanel.WrapContents = $false
$flowlayoutpanel.AutoSize = $true
$flowlayoutpanel.Size = '150, 400'
$flowlayoutpanel.FlowDirection = "TopDown"
$flowlayoutpanel1.Controls.Add($flowlayoutpanel)

$pnl_Logo                        = New-Object system.Windows.Forms.Panel
$pnl_Logo.height                 = 400
$pnl_Logo.width                  = 90
$pnl_Logo.BackColor              = $PanelColor
$pnl_Logo.location               = New-Object System.Drawing.Point(1,-1)

$img_Logo                        = New-Object system.Windows.Forms.PictureBox
$img_Logo.width                  = 60
$img_Logo.height                 = 102
$img_Logo.Anchor                 = 'left'
$img_Logo.location               = New-Object System.Drawing.Point(14,20)
$img_Logo.imageLocation          = "$PSScriptRoot\assets\$PanelImageName"
$img_Logo.SizeMode               = [System.Windows.Forms.PictureBoxSizeMode]::zoom

$btn_Run                         = New-Object system.Windows.Forms.Button
$btn_Run.BackColor               = "#eaeaea"
$btn_Run.text                    = "Run Script"
$btn_Run.width                   = 100
$btn_Run.height                  = 30
$btn_Run.Font                    = 'Microsoft Sans Serif,10'

$txt_Details                     = New-Object system.Windows.Forms.TextBox
$txt_Details.multiline           = $true
$txt_Details.height              = 343
$txt_Details.Font                = 'Microsoft Sans Serif,10'
$txt_Details.Scrollbars          = "Vertical" 
$txt_Details.text                = "No script selected.  Please click on a script to view details."

# End form building

###################################################################
# Start dynamic button generation for scripts in scripts directory
###################################################################

$NumScripts = Get-ChildItem -Path "$scriptsDir" -Name # get names of scripts
$x = 0 # Set Counter to 0, counter used for calculating if buttons need to scroll

foreach ($file in $NumScripts) {
    
    # Pull script data and store in local variables
    $runScript = Join-Path $scriptsDir $file
    $title= (Get-Content -Path $runScript | Where-Object {$_ -like '#@Title*' }).split('@')[-1]
    $author = (Get-Content -Path $runScript | Where-Object {$_ -like '#@Author*' }).split('@')[-1]
    $published = (Get-Content -Path $runScript | Where-Object {$_ -like '#@Published*' }).split('@')[-1]
    $description = (Get-Content -Path $runScript | Where-Object {$_ -like '#@Description*' }).split('@')[-1]

    # Code for button on GUI
    $btn = New-Object System.Windows.Forms.Button
    $btn.BackColor = "#eaeaea"
    $btn.text = $title.split(":")[-1].trim()
    $btn.size = "120,40"
    $btn.Font = 'Microsoft Sans Serif,10'
    $btn.Tag = $runScript

    # Click event for each button: Display info in Textbox and change Run button's Tag property
    $btn.Add_Click({ 
        $txt_Details.text = "$title`r`n`r`n$author`r`n`r`nDirectory: $runScript`r`n`r`n$published`r`n`r`n$description"
        $btn_Run.Tag = $this.Tag
    }.GetNewClosure())

    $flowlayoutpanel.Controls.Add($btn) # Add button to panel
    
    $x = $x + 1 # increment counter
}

# Set the Run Script button click event to execute script in new PowerShell console
$btn_Run.Add_Click({
    start-process powershell.exe -verb $verb -argument "-noexit -nologo -noprofile -executionpolicy bypass -file `"$($this.Tag)`""
})

$flowlayoutpanel1.AutoScroll = $True
$flowlayoutpanel1.Name = 'flowlayoutpanel1'
$flowlayoutpanel1.TabIndex = 0

###################################################################
# This section checks if dynamic button panel has a scroll bar and
# changes the sizes and positioning
###################################################################

$actlbtnHgt = $x * $btn.height
if ($x -ge 9) {
    $flowlayoutpanel1.Location = '95, 0'
    $flowlayoutpanel1.Size = '150, 400'
    $txt_Details.location = New-Object System.Drawing.Point(250,7)
    $txt_Details.width = 340
    $btn_Run.location = New-Object System.Drawing.Point(250,360)
} else {
    $flowlayoutpanel1.Location = '95, 0'
    $flowlayoutpanel1.Size = '140, 400'
    $txt_Details.location = New-Object System.Drawing.Point(230,7)
    $txt_Details.width = 360
    $btn_Run.location = New-Object System.Drawing.Point(230,360)
}

# Add elements to the form
$Form.controls.AddRange(@($pnl_Logo,$btn_Run,$txt_Details))
$pnl_Logo.controls.AddRange(@($img_Logo))

$Form.Controls.Add($flowlayoutpanel1)
$Form.ShowDialog()