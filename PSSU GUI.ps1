<#PSScriptInfo

.VERSION 1.0

.GUID e3313b11-32dd-4064-a5aa-5a610c4fe2ad

.AUTHOR Michael Garrison

.COMPANYNAME TalkGeekTo.Me

.LICENSEURI https://github.com/michael-g-tgtm/PowerShell-Script-Utility/blob/master/LICENSE

.PROJECTURI GitHub: https://github.com/michael-g-tgtm/PowerShell-Script-Utility

.RELEASENOTES

#>

<#

.DESCRIPTION 
PowerShell Script Utility GUI provides a Graphical User Interface utility that shows your information about scripts including Name, Author, Publish Date, and Description, and allows you to run them as a different user.

There are configuration and usage instructions located at the following locations:
- GitHub: https://github.com/michael-g-tgtm/PowerShell-Script-Utility
- Website: www.TalkGeekTo.Me - It can be found under Coding -> PSSU

The current features include:
- Execute script with "Run As" permissions
- Ability to set script location to any directory.  Some environments may only allow execution of PowerShell scripts from certain directories.
- Allow custom branding for company color themes, logo, and naming.
- Allow customization of information pulled from scripts

#>

Add-Type -assembly System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

###################################################################
# Configure the settings in the section for your application
###################################################################

$LaunchFromEXE = $false                     # If you plan to use something like PS2EXE, set this to $true before you convert
$ExecScripsWithRunAs = $false               # If you want scripts to be run as a different user, set to $true
$ScriptDirectory = $null                    # If you have a custom path (like C:\scripts), set value here.  Leave $null if you want to use default script directory
$PanelColor = "#666666"                     # Set the color of the side panel
$PanelImageName = "assets\logo.png"         # Set the custom image file of logo you wish to use.  Please use assets folder in Root of script.
$WindowIconImage = "assets\icon.ico"        # Set the custom icon of the GUI. Please use assets folder in Root of script.
$ScriptName = "PowerShell Script Utility"   # Set the title of GUI script
[string[]]$valueName = "Name", "Version", "Author", "Description", "Path", "ProjectUri", "CompanyName" # These are the values that are pulled in

# End Configuration

###################################################################
# Check above configuration and set variables
###################################################################

# Check if set to launch from an exe wrapper or not
if ($LaunchFromEXE -ne $false) {
    $FullPathToEXE = [System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName
    $PSScriptRoot = [System.IO.Path]::GetDirectoryName($FullPathToEXE)
} elseif ($LaunchFromEXE -ne $true) {
    # Set PSScriptRoot for PowerShell V2 compatibility
    $PSScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
} else { Write-Host "Error with Script Directory Path" }

# Check and set directory of scripts folder
if ($ScriptDirectory -ne $null) { $scriptsDir = $ScriptDirectory }
else { $scriptsDir = Join-Path $PSScriptRoot "scripts" }

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

$flowlayoutpanel1                = New-Object System.Windows.Forms.FlowLayoutPanel
$flowlayoutpanel                 = New-Object System.Windows.Forms.FlowLayoutPanel
$flowlayoutpanel.AutoScroll      = $True
$flowlayoutpanel.WrapContents    = $false
$flowlayoutpanel.AutoSize        = $true
$flowlayoutpanel.Size            = '150, 400'
$flowlayoutpanel.FlowDirection   = "TopDown"
$flowlayoutpanel1.Controls.Add($flowlayoutpanel)
$flowlayoutpanel1.AutoScroll     = $True
$flowlayoutpanel1.Name           = 'flowlayoutpanel1'
$flowlayoutpanel1.TabIndex       = 0

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
$img_Logo.imageLocation          = Join-Path $PSScriptRoot $PanelImageName
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

function Get-ScriptInfo 
{
  param([string]$data,[string]$dir)
  process { Test-ScriptFileInfo -Path $dir | select -ExpandProperty $data }
  
}

function Get-TexboxText
{
    param([string]$script)
    process
    {
        $text = ""
        foreach ($name in $valueName)
        {
            $info = Get-ScriptInfo -data "$name" -dir $script
            $text += "$name`: $info`r`n`r`n"
        }
        return $text
    }
}
$NumScripts = Get-ChildItem -Path "$scriptsDir" -Name # get names of scripts

foreach ($file in $NumScripts) {
    
    # Set full path of script directory
    $runScript = Join-Path $scriptsDir $file

    # Code for button on GUI
    $btn = New-Object System.Windows.Forms.Button
    $btn.BackColor = "#eaeaea"
    $btn.text = Get-ScriptInfo -dir $runScript -data "Name"
    $btn.size = "120,40"
    $btn.Font = 'Microsoft Sans Serif,10'
    $btn.Tag = $runScript

    # Click event for each button: Display info in Textbox and change Run button's Tag property
    $btn.Add_Click({ 
        $txt_Details.text = Get-TexboxText -script $runScript
        $btn_Run.Tag = $this.Tag
    }.GetNewClosure())
    $flowlayoutpanel.Controls.Add($btn) # Add button to panel
}

# Set the Run Script button click event to execute script in new PowerShell console
$btn_Run.Add_Click({ if ($this.Tag -ne $null) { start-process powershell.exe -verb $verb -argument "-noexit -nologo -noprofile -executionpolicy bypass -file `"$($this.Tag)`"" } })

###################################################################
# This section checks if dynamic button panel has a scroll bar and
# changes the sizes and positioning
###################################################################
$offset1 = 0; $offset2 = 0
$flowlayoutpanel1.Height = 400

$actlBtnHgt = $NumScripts.Count * ($btn.Height + 10)  # Get number of scripts, then mulitply by height of button + spacing
if (($flowlayoutpanel1.Height) -le $actlBtnHgt) { $offset1 = 20; $offset2 = 10 }  # If it exceeds the height, set offset variables

$flowlayoutpanel1.Location = '95, 0'
$flowlayoutpanel1.Width = (140 + $($script:offset2))
$txt_Details.location = New-Object System.Drawing.Point((230 + $script:offset1),7)
$txt_Details.width = (360 - $script:offset1)
$btn_Run.location = New-Object System.Drawing.Point((230 + $script:offset1),360)

# Add elements to the form
$Form.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon((Join-Path $PSScriptRoot $WindowIconImage))

$Form.controls.AddRange(@($pnl_Logo,$btn_Run,$txt_Details))
$pnl_Logo.controls.AddRange(@($img_Logo))

$Form.Controls.Add($flowlayoutpanel1)
$Form.ShowDialog()
