#
# CWPS Administration - Home Page_V1.6.ps1
#
#==============================================================================================
# XAML Code - Imported from Visual Studio Express 2013 WPF Application
#==============================================================================================
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml]$XAML = @'
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="CWPS Integration TOOL (CIT) - V1" Height="800" Width="900" WindowStartupLocation="CenterScreen" ResizeMode="CanMinimize">
    <Grid Margin="0,0,-0.2,0.2">
   
    <Border>
   

      <Canvas Background="Green">
        </Canvas>
    </Border>


     <Button Name="btnACLFinder" Content="ACL Finder" HorizontalAlignment="Left" Margin="0,25,0,0" VerticalAlignment="Top" Width="900" Height="34" BorderThickness="0"/>
     <Button Name="btnHomeDriveFinder" Content="Home Drive Finder" HorizontalAlignment="Left" Margin="0,75,0,0" VerticalAlignment="Top" Width="900" Height="34" BorderThickness="0"/>
     <Button Name="btnHomeDriveCreator" Content="Home Drive Creator" HorizontalAlignment="Left" Margin="0,125,0,0" VerticalAlignment="Top" Width="900" Height="34" BorderThickness="0"/>

       <Button Name="btnOffBoarding" Content="Off Boarding" HorizontalAlignment="Left" Margin="0,175,0,0" VerticalAlignment="Top" Width="900" Height="34" BorderThickness="0"/>
       <Button Name="btnLocalAdminRights" Content="Local Admin Rights" HorizontalAlignment="Left" Margin="0,225,0,0" VerticalAlignment="Top" Width="900" Height="34" BorderThickness="0"/>

       <Button Name="btnFolderAccessProvider" Content="Folder Access Provider" HorizontalAlignment="Left" Margin="0,275,0,0" VerticalAlignment="Top" Width="900" Height="34" BorderThickness="0"/>

       <Button Name="btnCreateSharedFolder" Content="Create Shared Folder" HorizontalAlignment="Left" Margin="0,325,0,0" VerticalAlignment="Top" Width="900" Height="34" BorderThickness="0"/>

       <Button Name="btnGroupMemberAdder" Content="Group Member Adder" HorizontalAlignment="Left" Margin="0,375,0,0" VerticalAlignment="Top" Width="900" Height="34" BorderThickness="0"/>

        <Button Name="btnLinkFolderAccesstoGroup" Content="Link Folder Access to Group" HorizontalAlignment="Left" Margin="0,425,0,0" VerticalAlignment="Top" Width="900" Height="34" BorderThickness="0"/>

        <Button Name="btnBulkProcess" Content="Other/Bulk Process" HorizontalAlignment="Left" Margin="0,475,0,0" VerticalAlignment="Top" Width="900" Height="34" BorderThickness="0"/>

        <Button Name="btnExit" Content="Exit" HorizontalAlignment="Left" Margin="0,700,0,0" VerticalAlignment="Top" Width="900" Height="34" BorderThickness="0"/>
      
    </Grid>
</Window>
'@
#Read XAML

$reader=(New-Object System.Xml.XmlNodeReader $xaml) 
try{$Form=[Windows.Markup.XamlReader]::Load( $reader )}
catch{Write-Host "Unable to load Windows.Markup.XamlReader. Some possible causes for this problem include: .NET Framework is missing PowerShell must be launched with PowerShell -sta, invalid XAML code was encountered."; exit}


#===========================================================================
# Store Form Objects In PowerShell
#===========================================================================

$xaml.SelectNodes("//*[@Name]") | %{Set-Variable -Name ($_.Name) -Value $Form.FindName($_.Name)}

#===========================================================================
# Run as Administrator
#===========================================================================

If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{   
#"No Administrative rights, it will display a popup window asking user for Admin rights"

$arguments = "& '" + $myinvocation.mycommand.definition + "'"
Start-Process "$psHome\powershell.exe" -Verb runAs -ArgumentList $arguments

break
}

#===========================================================================
# Log Function
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
        [string]$Path='C:\Logs\CWPSAdministrationHomePage.log', 

        [Parameter(Mandatory=$false)] 
        [Alias('LogPath2')] 
        [string]$Path2='\\10.16.99.13\D$\CWPS_Automation\Logs\CWPSAdministrationHomePage.log', 
         
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



                # If the file already exists and NoClobber was specified, do not write to the log. 
        if ((Test-Path $Path2) -AND $NoClobber) { 
            Write-Error "Log file $Path already exists, and you specified NoClobber. Either delete the file or specify a different name." 
            Return 
            } 
 
        # If attempting to write to a log file in a folder/path that doesn't exist create the file including the path. 
        elseif (!(Test-Path $Path2)) { 
            Write-Verbose "Creating $Path2." 
            $NewLogFile = New-Item $Path2 -Force -ItemType File 
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
        "$FormattedDate $LevelText $Message" | Out-File -FilePath $Path2 -Append 
    } 
    End 
    { 
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


#===========================================================================
# Reset Function
#===========================================================================

function Reset{



}

#===========================================================================
# Add events to Form Objects
#===========================================================================





#===========================================================================
# Add events to Form Objects - Submit Button
#===========================================================================



$btnACLFinder.Add_Click(


{



Start-Process \\XE-S-JUMP005.xe.abb.com\CIT_Automation$\EXE\ACLFinder.exe -Verb runAs



})


$btnHomeDriveFinder.Add_Click(


{



Start-Process \\XE-S-JUMP005.xe.abb.com\CIT_Automation$\EXE\HomeDriveFinder.exe -Verb runAs



})


$btnHomeDriveCreator.Add_Click(


{



Start-Process \\XE-S-JUMP005.xe.abb.com\CIT_Automation$\EXE\HomeDriveCreator.exe -Verb runAs



})

 $btnOffBoarding.Add_Click({

 


Start-Process \\XE-S-JUMP005.xe.abb.com\CIT_Automation$\EXE\OffBoarding.exe -Verb runAs



})



 $btnLocalAdminRights.Add_Click({

 


Start-Process \\XE-S-JUMP005.xe.abb.com\CIT_Automation$\EXE\LocalAdminRightsProvider.exe -Verb runAs



})


$btnCreateSharedFolder.Add_Click(


{



Start-Process \\XE-S-JUMP005.xe.abb.com\CIT_Automation$\EXE\CreateSharedFolder.exe -Verb runAs



})



  $btnFolderAccessProvider.Add_Click({





Start-Process \\XE-S-JUMP005.xe.abb.com\CIT_Automation$\EXE\FolderAccessProvider.exe -Verb runAs



})




  $btnGroupMemberAdder.Add_Click({





Start-Process \\XE-S-JUMP005.xe.abb.com\CIT_Automation$\EXE\GroupMemberAdder.exe -Verb runAs



})



  $btnLinkFolderAccesstoGroup.Add_Click({





Start-Process \\XE-S-JUMP005.xe.abb.com\CIT_Automation$\EXE\FolderAccessLinkerToGroup.exe -Verb runAs



})





$btnBulkProcess.Add_Click(


{



Start-Process \\XE-S-JUMP005.xe.abb.com\CIT_Automation$\EXE\BulkProcess.exe -Verb runAs



})




$btnExit.Add_Click({

$ExitButtonLog = "Exited by:       " + $env:username

Write-Log $ExitButtonLog



$form.Close()

})


#===========================================================================
# Run PowerShell
#===========================================================================






#===========================================================================
# Shows the form
#===========================================================================
$Form.ShowDialog() | out-null

$CloseButtonLog = "Exited by:       " + $env:username

Write-Log $CloseButtonLog