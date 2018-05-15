#
# ACLFinder_V1.3.ps1
#
#==============================================================================================
# XAML Code - Imported from Visual Studio Express 2013 WPF Application
#==============================================================================================
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml]$XAML = @'
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="Data Migrator" FontWeight="Bold" Height="800" Width="900" WindowStartupLocation="CenterScreen" ResizeMode="CanMinimize">
    <Grid Margin="0,0,-0.2,0.2">
   
    <Border>

    <Canvas Background="#3366FF">
   

         

     
    <TextBox Name="txtSourceFolderPath" HorizontalAlignment="Left" Height="23" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Width="650" Canvas.Left="160" Canvas.Top="28"/>

    <Label Content="Source Folder Path" Canvas.Left="17" Canvas.Top="25"/>


         
    <TextBox Name="txtDestinationFolderPath" HorizontalAlignment="Left" Height="23" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Width="650" Canvas.Left="160" Canvas.Top="58"/>

    <Label Content="Destination Folder Path" Canvas.Left="17" Canvas.Top="58"/>


        <TextBox Name="txtRequestNo" HorizontalAlignment="Left" Height="23" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Width="150" Canvas.Left="160" Canvas.Top="90"/>

         <Label FontWeight="Bold" Content="Task/Request Number" Canvas.Left="17" Canvas.Top="90"/>

    <TextBox Name="txtboxMigration" HorizontalAlignment="Left" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Height="300" Width="650" Canvas.Left="160" Canvas.Top="140" Background="{DynamicResource {x:Static SystemColors.ControlLightLightBrushKey}}"/>
   
            <Label Content="OutPut" Canvas.Left="17" Canvas.Top="150"/>




                     <TextBlock Name="textBlock" HorizontalAlignment="Left" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Height="20" Width="650" Canvas.Left="160" Canvas.Top="500" Background="{DynamicResource {x:Static SystemColors.ControlLightLightBrushKey}}"/>
             <Label FontWeight="Bold" Content="Status" Canvas.Left="17" Canvas.Top="500"/>



            
        </Canvas>
    </Border>



    
     <Button Name="btnSubmit" Content="Submit" HorizontalAlignment="Left" Margin="0,550,0,0" VerticalAlignment="Top" Width="900" Height="34" BorderThickness="0"/>

    <Button Name="btnReset" Content="Reset" HorizontalAlignment="Left" Margin="0,600,0,0" VerticalAlignment="Top" Width="900" Height="34" BorderThickness="0"/>

    <Button Name="btnExit" Content="Exit" HorizontalAlignment="Left" Margin="0,650,0,0" VerticalAlignment="Top" Width="900" Height="34" BorderThickness="0"/>
      
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
        [string]$Path='C:\Logs\DataMigrator.log', 

        [Parameter(Mandatory=$false)] 
        [Alias('LogPath2')] 
        [string]$Path2='\\10.16.99.13\D$\CWPS_Automation\Logs\DataMigrator.log', 
         
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

$txtSourceFolderPath.text = ""


$txtDestinationFolderPath.text = ""

$textBlock.text = ""

$txtRequestNo.Text = ""

$txtboxMigration.text = ""

$textBlock.Background = '#FFFFFF'


}


#===========================================================================
# Add events to Form Objects
#===========================================================================



$btnSubmit.Add_Click(

{




if ( ($txtSourceFolderPath.text.Length) -eq 0 -Or ($txtDestinationFolderPath.text.Length) -eq 0 -Or ($txtRequestNo.text.Length) -eq 0 -or  $txtSourceFolderPath.text.Contains($txtDestinationFolderPath.text))

{


[System.Windows.MessageBox]::Show("Source Folder Path or Destination Folder Path or Task number is empty or destination path should not be part of source path." ,"Error" )



}
else 

{


$tempSourceFolderPath = $txtSourceFolderPath.text

$tempSourceFolderPath =  $tempSourceFolderPath.Trim()

$tempDestinationFolderPath = $txtDestinationFolderPath.Text

$tempDestinationFolderPath = $tempDestinationFolderPath.Trim()

try

{

$confirmation = [System.Windows.MessageBox]::Show('Data Migrator copy\mirror the data and ACL from source folder to destination folder. Are you sure about transferring the data?','Confirm','YesNo')

if($confirmation -eq "No")
{


}

else
{



Get-Acl $tempSourceFolderPath -ErrorAction Stop 

$DestinationACL = Get-Acl $tempDestinationFolderPath -ErrorAction Stop | Format-List | out-string 

robocopy $tempSourceFolderPath $tempDestinationFolderPath /e /s /Sec /tee /mir /log:copy.txt 

$txtboxMigration.text = " Data Migration is completed. 


Source is 
" + $tempSourceFolderPath + 

" 
Destination is 
" + $tempDestinationFolderPath +
 
" 

Destination ACL :" + $DestinationACL


$textBlock.text = $newFolderPath

$textBlock.Background = '#00FF00'
 
$textBlock.text = $txtRequestNo.text + "----Data Migration is completed." 


   $btnSubmit.IsEnabled = $false

 

Write-Log $txtboxMigration.text


Write-Log $textBlock.text

}

}


Catch [Exception]

{




$txtboxMigration.text = "Error : " + $_.Exception.Message 

$textBlock.text = "Error : " + $_.Exception.GetType().FullName

$ErrorMessage = "Submit by :"  + $env:username +"----" + $_.Exception.GetType().FullName + "----" + $_.Exception.Message

$textBlock.Background = '#FFE10101'

Write-Log $ErrorMessage


}

}

})




$btnReset.Add_Click({



$ResetButtonLog = "Reset by " + $env:username


Reset





$btnSubmit.IsEnabled = $true





})

$btnExit.Add_Click({$form.Close()})


#===========================================================================
# Run PowerShell
#===========================================================================




#===========================================================================
# Shows the form
#===========================================================================
$Form.ShowDialog() | out-null