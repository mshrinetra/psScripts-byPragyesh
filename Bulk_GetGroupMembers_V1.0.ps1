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
    Title="Bulk Process - Get AD Group Members" FontWeight="Bold" Height="800" Width="900" WindowStartupLocation="CenterScreen" ResizeMode="CanMinimize">
    <Grid Margin="0,0,-0.2,0.2">
   
    <Border>

    <Canvas Background="Tomato">
   

         

     
    <TextBox Name="txtFolderPath" HorizontalAlignment="Left" Height="23" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Width="650" Canvas.Left="100" Canvas.Top="28"/>

    <Label Content="Upload .CSV" Canvas.Left="17" Canvas.Top="25"/>

    <TextBox Name="txtboxFolderPath" HorizontalAlignment="Left" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Height="350" Width="750" Canvas.Left="100" Canvas.Top="113" Background="{DynamicResource {x:Static SystemColors.ControlLightLightBrushKey}}"/>
   
            <Label Content="OutPut" Canvas.Left="17" Canvas.Top="150"/>
   <TextBlock Name="textBlock" HorizontalAlignment="Left" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Height="20" Width="750" Canvas.Left="100" Canvas.Top="513" Background="{DynamicResource {x:Static SystemColors.ControlLightLightBrushKey}}"/>
 <Label Content="Status" Canvas.Left="17" Canvas.Top="513"/>            
        </Canvas>
    </Border>


     <Button Name="btnBrowse" Content="Browse" HorizontalAlignment="Left" Margin="775,28,0,0" VerticalAlignment="Top" Width="100" Height="25" BorderThickness="0"/>
    
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
        [string]$Path='C:\Logs\FolderPathValidator_Bulk.log', 

        [Parameter(Mandatory=$false)] 
        [Alias('LogPath2')] 
        [string]$Path2='\\10.16.99.13\D$\CWPS_Automation\Logs\FolderPathValidator_Bulk.log', 
         
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

$txtFolderPath.text = ""


$txtboxFolderPath.text = ""

$textBlock.text = ""



$textBlock.Background = '#FFFFFF'


}


#===========================================================================
# Add events to Form Objects
#===========================================================================

$btnBrowse.Add_Click(
{

try

{



  Add-Type -AssemblyName System.Windows.Forms
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.Title = "Please Select File"
    $OpenFileDialog.InitialDirectory = $initialDirectory
    $OpenFileDialog.filter = "All files (*.*)| *.CSV*"
    # Out-Null supresses the "OK" after selecting the file.
    $OpenFileDialog.ShowDialog() | Out-Null
    $Global:SelectedFile = $OpenFileDialog.FileName

    Write-Host $OpenFileDialog.FileName

    $txtFolderPath.Text = $OpenFileDialog.FileName
}

Catch [Exception]

{



$textBlock.text = "Error : " + $_.Exception.GetType().FullName

$ErrorMessage = "Submit by :"  + $env:username +"----" + $_.Exception.GetType().FullName + "----" + $_.Exception.Message



Write-Log $ErrorMessage




}


})



$btnSubmit.Add_Click(

{


try{



$dataList= Get-Content $txtFolderPath.text -ErrorAction Stop


foreach ($rowData in $dataList) {



$Tempgroup =  $rowData.Security_Group.Trim()

Write-Host $Tempgroup

$Group = Get-ADGroup -id $Tempgroup -Server "de-s-abb0033.abb.com:3268" -ErrorAction ignore

$GroupName = "LDAP://"+$Group

$Group = [ADSI]$GroupName

$txtboxFolderPath =  $Group.member  | Format-List | out-string

Write-Host $txtboxFolderPath






$txtboxFolderPath.text =  $Group.member  | Format-List | out-string




$TempOutPut += $txtboxFolderPath

$details = @{    
                        
                Path  = $rowData.Path
                AccessType = $rowData.Access
                Security_Group = $Tempgroup
                Group_Members = $txtboxFolderPath
                      
                
        }                               
     
$results = New-Object PSObject -Property $details  


$TempOutPut += $details  

  
$results | export-csv -Append -Path "\\XE-S-JUMP005.xe.abb.com\D$\CIT_BulkProcessOutPut\GetADGroupMember\Output2_Test_Data_ACL_Estonia.csv" -NoTypeInformation
    

}


                            $txtboxFolderPath.text = $TempOutPut

                            $textBlock.Background = "#00FF00"

                            $btnSubmit.IsEnabled = $false 

                            $textBlock.text=  "Successful - \\XE-S-JUMP005.xe.abb.com\D$\CIT_BulkProcessOutPut\FolderPathValidator"  

                            Write-Log $textBlock.text

                            $btnSubmit.IsEnabled = $false


}


Catch [Exception]

{




$txtboxFolderPath.text = "Error : " + $_.Exception.Message 

$textBlock.text = "Error : " + $_.Exception.GetType().FullName

$ErrorMessage = "Submit by :"  + $env:username +"----" + $_.Exception.GetType().FullName + "----" + $_.Exception.Message



Write-Log $ErrorMessage


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