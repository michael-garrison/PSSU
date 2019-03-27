# PowerShell-Script-Utility
Provide a Graphical User Interface utility that shows your information about scripts including Title, Author, Publish Date, and Description, and allows you to run them as a different user.

This GUI needed to do the following:

- It must be written in a native scripting language so that it can be easily implemented and maintained across multiple versions of Windows.
- Must be able to display information about each script including: Title, Version, Publish Date, Author, and Purpose.
- Must allow for the following configurable options:
  - Execute script with “Run As” permissions
  - Ability to set script location to any directory. Some environments may only allow execution of PowerShell scripts from certain directories.
  - Allow custom branding for company color themes, logo, and naming.
  - Allow customization of information pulled from scripts

# Configuration
At the top of the script, you’ll notice there are 7 variables that can be configured. Other values in the script can be change, but these are the main ones used to configure various options. See the below explanations of each one.

$LaunchFromEXE = $false # If you plan to use something like PS2EXE, set this to $true before you convert

$ExecScripsWithRunAs = $false # If you want scripts to be run as a different user, set to $true

$ScriptDirectory = $null # If you have a custom path (like C:\scripts), set value here. Leave $null if you want to use default script directory

$PanelColor = "#666666" # Set the color of the side panel

$PanelImageName = "assets\logo.png" # Set the custom image file of logo you wish to use. Please use assets folder in Root of script.

$WindowIconImage = "assets\icon.ico" # Set the custom icon of the GUI. Please use assets folder in Root of script.

$ScriptName = "PowerShell Script Utility v1.0" # Set the title of GUI script

**LAUNCHFROMEXE**

This variable is used to change the pathing when the script is wrapped in an EXE file. When set to True, the script will get the directory of the executed process and store it as $PSScriptRoot. When set to False, it changes $PSScriptRoot to a PowerShell v2 friendly format.

**EXECSCRIPSWITHRUNAS**

Quite simply, when set to True the GUI will execute all scripts with the RunAs verb to allow for elevated consoles. When set to False, it just uses the Open verb.

**SCRIPTDIRECTORY**

On the GitHub page, take note of the directory structure. By default, without changing any variables, the PowerShell Script Utility will use 2 directories located on the same level as the script: scripts and assets. Alternatively, you can set the variable to a path of your desire for scripts.

**PANELCOLOR**

As the name implies, this variable holds the Hexadecimal color value for the left pane. All Hexadecimal values should be accepted.

**PANELIMAGENAME**

This variable sets the path and name of the panel image on the left. When the image is set later in the script, it will call $PSScriptRoot\$PanelImageName. That translates to “Directory the script was run from” \ “name of image folder and file name”. By default, this value is set to “assets\logo.png”

**WINDOWICONIMAGE**

PowerShell allows you to set the small icon on the top left of a GUI, so why not make it customizable? I’ve included a PSSU icon by default that was created in GIMP. You should be able to base your own custom icon off of that one.

**SCRIPTNAME**

This value simply changes the name of the GUI window. It can be changed and has no effect other than changing the window name.

**VALUENAME**
This array specifies what script information the GUI pulls in. The section below covers the basics, but by default it pulls in the following data: “Name”, “Version”, “Author”, “Description”, “Path”, “ProjectUri”, “CompanyName”

# Pulling in Script Information

In order to pull in the script information, as seen in the screenshot, you need to use PowerShell’s SciprtFileInfo format. This means that each script will need the following lines (minimum) at the top of the file:

<#PSScriptInfo
 
.VERSION 1.0
 
.GUID <generate-script-Guid>
 
.AUTHOR Michael Garrison
 
#>
 
<#
 
.DESCRIPTION 
 
#>

The GUI can pull the data from this block and add it to the text box. Future revisions may allow for custom script info tags, for now this is the only way. For more info on ScriptFileInfo and for a full list of attributes, please visit https://docs.microsoft.com/en-us/powershell/module/powershellget/new-scriptfileinfo?view=powershell-6
