
#===========================================================================
# Create log folder
#===========================================================================

$Location = "C:\Log"

$FolderName = $(get-date -f MM-dd-yyyy_HH_mm_ss)


New-Item -path $Location -name $FolderName -itemType "directory" -ErrorAction Stop

$FinalLocation =  $Location+"\"+$FolderName

#===========================================================================
# Log function
#===========================================================================


function Write-Log 
{ 
    [CmdletBinding()] 
    Param 
    ( 
        [Parameter(Mandatory=$true, 
                   ValueFromPipelineByPropertyName=$true)] 
        [ValidateNotNullOrEmpty()] 
        [Alias("LogContent")] 
        [string]$Message, 
 
        [Parameter(Mandatory=$false)] 
        [Alias('LogPath')] 
        [string]$Path= $FinalLocation+'\WO-112.log', 

        [Parameter(Mandatory=$false)] 
        [ValidateSet("Error","Warn","Info")] 
        [string]$Level="Info", 
         
        [Parameter(Mandatory=$false)] 
        [switch]$NoClobber 
    ) 
 
    Begin 
    { 
        # Set VerbosePreference to Continue so that verbose messages are displayed. 
        $VerbosePreference = 'Continue' 
    } 
    Process 
    { 
         
        # If the file already exists and NoClobber was specified, do not write to the log. 
        if ((Test-Path $Path) -AND $NoClobber) { 
            Write-Error "Log file $Path already exists, and you specified NoClobber. Either delete the file or specify a different name." 
            Return 
            } 
 
        # If attempting to write to a log file in a folder/path that doesn't exist create the file including the path. 
        elseif (!(Test-Path $Path)) { 
            Write-Verbose "Creating $Path." 
            $NewLogFile = New-Item $Path -Force -ItemType File 
            } 
 
        else { 
            # Nothing to see here yet. 
            } 
 
        # Format Date for our Log File 
        $FormattedDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss" 
 
        # Write message to error, warning, or verbose pipeline and specify $LevelText 
        switch ($Level) { 
            'Error' { 
                Write-Error $Message 
                $LevelText = 'ERROR:' 
                } 
            'Warn' { 
                Write-Warning $Message 
                $LevelText = 'WARNING:' 
                } 
            'Info' { 
                Write-Verbose $Message 
                $LevelText = 'INFO:' 
                } 
            } 
         
        # Write log entry to $Path 
        "$FormattedDate $LevelText $Message" | Out-File -FilePath $Path -Append 



    } 
}



#===========================================================================
# Start Log Function
#===========================================================================



$ScriptExecutor = "Started by:    "+ $env:username

$ipV4 = Test-Connection -ComputerName (hostname) -Count 1  | Select IPV4Address

$ScriptStartLog = "Started from:    " + (Get-Item -Path ".\" -Verbose).FullName 

Write-Log $ipV4


Write-Log $ScriptStartLog


Write-Log $ScriptExecutor




try{


# Enter a number to indicate how many days old the identified file needs to be (must have a "-" in front of it).
$HowOld = -30

#Path to the Root Folder
$Path = "\\XE-S-JUMP005.xe.abb.com\c$\Users\xw-admin-pk8\Documents\PowerShell"

$FinalDeleteFileListLocation = $FinalLocation +"\" + 'Deleted_File_List.csv'

get-childitem $Path -recurse -Force -ErrorAction SilentlyContinue| where {$_.lastwritetime -lt (get-date).adddays($HowOld) -and -not $_.psiscontainer} | select -ExpandProperty fullname | Format-List | Out-file $FinalDeleteFileListLocation

get-childitem $Path -recurse -Force -ErrorAction SilentlyContinue| where {$_.lastwritetime -lt (get-date).adddays($HowOld) -and -not $_.psiscontainer} |% {remove-item $_.fullname -force -WhatIf -ErrorAction Stop } 

Write-Log "Files-older than 30 days are deleted successfully."



}





Catch [Exception]

{




$ErrorMessage = "Submit by :"  + $env:username +"----" + $_.Exception.GetType().FullName + "----" + $_.Exception.Message



Write-Log $ErrorMessage


}