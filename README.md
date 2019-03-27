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
