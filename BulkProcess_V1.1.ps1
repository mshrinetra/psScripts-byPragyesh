﻿#
# CWPS Administration - BulkProcess_V1.0.ps1
#
#==============================================================================================
# XAML Code - Imported from Visual Studio Express 2013 WPF Application
#==============================================================================================
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml]$XAML = @'
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="AD/Other/Bulk Process" FontWeight="Bold" Height="800" Width="900" WindowStartupLocation="CenterScreen" ResizeMode="CanMinimize">
    <Grid Margin="0,0,-0.2,0.2">
   
    <Border>
   

      <Canvas Background="Green">
        </Canvas>
    </Border>


     <Button Name="GetADGroupMembers" Content="Get AD Group Members" HorizontalAlignment="Left" Margin="0,25,0,0" VerticalAlignment="Top" Width="900" Height="34" BorderThickness="0"/>
     <Button Name="FolderAccessRemover" Content="Folder Access Remover" HorizontalAlignment="Left" Margin="0,75,0,0" VerticalAlignment="Top" Width="900" Height="34" BorderThickness="0"/>

      <Button Name="AdminAccount" Content="Admin Account Creation" HorizontalAlignment="Left" Margin="0,125,0,0" VerticalAlignment="Top" Width="900" Height="34" BorderThickness="0"/>

       <Button Name="ServiceAccount" Content="Service Account Creation" HorizontalAlignment="Left" Margin="0,175,0,0" VerticalAlignment="Top" Width="900" Height="34" BorderThickness="0"/>

        <Button Name="WiproAdmin" Content="Wipro Admin Account Creation" HorizontalAlignment="Left" Margin="0,225,0,0" VerticalAlignment="Top" Width="900" Height="34" BorderThickness="0"/>
                      

        <Button Name="WiproAdminDispatch" Content=" Wipro Admin Account Dispatch" HorizontalAlignment="Left" Margin="0,275,0,0" VerticalAlignment="Top" Width="900" Height="34" BorderThickness="0"/>



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
        [string]$Path='C:\Logs\Other_or_BulkProcess.log', 

        [Parameter(Mandatory=$false)] 
        [Alias('LogPath2')] 
        [string]$Path2='\\10.16.99.13\D$\CWPS_Automation\Logs\Other_or_BulkProcess.log', 
         
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



$GetADGroupMembers.Add_Click(


{



Start-Process \\XE-S-JUMP005.xe.abb.com\CIT_Automation$\EXE\GetADGroupMembers.exe -Verb runAs



})


$FolderAccessRemover.Add_Click(


{



Start-Process \\XE-S-JUMP005.xe.abb.com\CIT_Automation$\EXE\FolderAccessRemover.exe -Verb runAs



})


$AdminAccount.Add_Click(


{



Start-Process \\XE-S-JUMP005.xe.abb.com\CIT_Automation$\EXE\AD\AdminAccount.exe -Verb runAs



})

$ServiceAccount.Add_Click(


{



Start-Process \\XE-S-JUMP005.xe.abb.com\CIT_Automation$\EXE\AD\ServiceAccount.exe -Verb runAs



})


$WiproAdmin.Add_Click(


{



Start-Process \\XE-S-JUMP005.xe.abb.com\CIT_Automation$\EXE\AD\WiproAdmin.exe -Verb runAs



})


$WiproAdminDispatch.Add_Click(


{



Start-Process \\XE-S-JUMP005.xe.abb.com\CIT_Automation$\EXE\AD\WiproAdminDispatch.exe -Verb runAs



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