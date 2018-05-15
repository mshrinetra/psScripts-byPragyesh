#
# DeleteSubdirectoriesAndFiles_Access_Remover_V1.2.ps1
#
#==============================================================================================
# XAML Code - Imported from Visual Studio Express 2013 WPF Application
#==============================================================================================
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml]$XAML = @'
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="DeleteSubdirectoriesAndFiles_Access_Remover" Height="950" Width="900" WindowStartupLocation="CenterScreen" ResizeMode="CanMinimize">
    <Grid Margin="0,0,-0.2,0.2">
   
    <Border>
   

      <Canvas Background="#306754">

     <TextBox Name="txtFolderPath" HorizontalAlignment="Left" Height="23" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Width="700" Canvas.Left="150" Canvas.Top="18"/>

              <Label FontWeight="Bold" Content="Folder Path" Canvas.Left="17" Canvas.Top="15"/>
           
             

             
            <TextBox Name="txtboxFolderPathOutput" HorizontalAlignment="Left" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Height="250" Width="700" Canvas.Left="150" Canvas.Top="50" Background="{DynamicResource {x:Static SystemColors.ControlLightLightBrushKey}}"/>
            
            
              <Label FontWeight="Bold" Content="ACL Details" Canvas.Left="17" Canvas.Top="50"/>
   
         <TextBox Name="txtUserOrGroupName" HorizontalAlignment="Left" Height="23" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Width="300" Canvas.Left="200" Canvas.Top="365"/>
            
           <Label FontWeight="Bold" Content="UserName or GroupName" Canvas.Left="17" Canvas.Top="365"/>

       
        
                 
  


             <TextBlock Name="textBlock" HorizontalAlignment="Left" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Height="20" Width="700" Canvas.Left="150" Canvas.Top="725" Background="{DynamicResource {x:Static SystemColors.ControlLightLightBrushKey}}"/>
             <Label FontWeight="Bold" Content="Status" Canvas.Left="17" Canvas.Top="725"/>

             <TextBox Name="txtboxFolderAccessOutput" HorizontalAlignment="Left" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Height="250" Width="700" Canvas.Left="150" Canvas.Top="475" Background="{DynamicResource {x:Static SystemColors.ControlLightLightBrushKey}}"/>
            <Label FontWeight="Bold" Content="Output" Canvas.Left="17" Canvas.Top="475"/>
            
        </Canvas>



    </Border>



      <Button Name="btnSearchACL" Content="Search ACL" IsEnabled="true" HorizontalAlignment="Left" Margin="0,325,0,0" VerticalAlignment="Top" Width="900" Height="34" BorderThickness="0"/>

      <Button Name="btnSubmit" Content="Submit" IsEnabled="true" HorizontalAlignment="Left" Margin="0,750,0,0" VerticalAlignment="Top" Width="900" Height="34" BorderThickness="0"/>
    
       <Button Name="btnReset" Content="Reset" HorizontalAlignment="Left" Margin="0,800,0,0" VerticalAlignment="Top" Width="900" Height="34" BorderThickness="0"/>
        <Button Name="btnExit" Content="Exit" HorizontalAlignment="Left" Margin="0,850,0,0" VerticalAlignment="Top" Width="900" Height="34" BorderThickness="0"/>
      
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
        [string]$Path='C:\Logs\DeleteSubdirectoriesAndFiles_Access_Remover.log', 

        [Parameter(Mandatory=$false)] 
        [Alias('LogPath2')] 
        [string]$Path2='\\10.16.99.13\D$\CWPS_Automation\Logs\DeleteSubdirectoriesAndFiles_Access_Remover.log', 
         
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
# AccessType Function
#===========================================================================



#===========================================================================
# Reset Function
#===========================================================================

function Reset{

$txtFolderPath.text = ""

$txtboxFolderPathOutput.text = ""


$txtUserOrGroupName.text = ""


$textBlock.text = ""

$txtboxFolderAccessOutput.Text = ""




$textBlock.Background = '#FFFFFF'






}


#===========================================================================
# Add events to Form Objects
#===========================================================================






#===========================================================================
# Add events to Form Objects - Submit Button
#===========================================================================



$btnSearchACL.Add_Click(
{


if ( ($txtFolderPath.text.Length) -eq 0)

{


[System.Windows.MessageBox]::Show("Folder Path is empty" ,"Error" )



}

else 

{

try

{

$txtFolderPath = $txtFolderPath.text.Trim()



$AccessDetails = Get-NTFSAccess  $txtFolderPath | Format-Table | out-string

$ChildItemDetails = Get-ChildItem $txtFolderPath -Name -ErrorAction Stop | Format-List | out-string


$txtboxFolderPathOutput.text =  $AccessDetails +                                
                          "List of subfolders and files:
                           "+
                           $ChildItemDetails

 $btnSearchACL.IsEnabled = $false

 }

 Catch [Exception]

{




$txtboxFolderPathOutput.text = "Error : " + $_.Exception.Message 



$ErrorMessage = "Submit by :"  + $env:username +"----" + $_.Exception.GetType().FullName + "----" + $_.Exception.Message



Write-Log $ErrorMessage


}

}

})




$btnSubmit.Add_Click(


{





if ( ($txtUserOrGroupName.text.Length -eq 0   ) )

{


[System.Windows.MessageBox]::Show("Group Name or User ID is empty" ,"Error" )



}
else 

{



$SubmitButtonLog = "Submit by " + $env:username

Write-Log $SubmitButtonLog


$path = $txtFolderPath.text

$path = $path.Trim()


$user = $txtUserOrGroupName.Text

$user = $user.Trim()







try
{


$Acl = Get-Acl $path -ErrorAction Stop
$Ar = New-Object system.security.accesscontrol.filesystemaccessrule( $user ,"DeleteSubdirectoriesAndFiles, Delete", "ContainerInherit, ObjectInherit", "None", "Allow")
$Acl.RemoveAccessRule($Ar)
Set-Acl $path $Acl -ErrorAction Stop


$AccessDetails = Get-NTFSAccess  $path | Format-Table | out-string


$txtboxFolderAccessOutput.text =  $AccessDetails
                       



            $textBlock.Background = '#00FF00'


            $textBlock.text = "DeleteSubdirectoriesAndFiles access has been revoked for" + $txtUserOrGroupName.Text + "  On Folder Path:" + $txtFolderPath.Text 


            $ScriptExecutionLog = "Executed from:   " + (Get-Item -Path ".\" -Verbose).FullName


            $btnSubmit.IsEnabled = $false

            Write-Log $textBlock.text
       



}



Catch [Exception]

{




$txtboxFolderAccessOutput.text = "Error : " + $_.Exception.Message 

$textBlock.text = "Error : " + $_.Exception.GetType().FullName

$ErrorMessage = "Submit by :"  + $env:username +"----" + $_.Exception.GetType().FullName + "----" + $_.Exception.Message



Write-Log $ErrorMessage


}





finally {
  # cleanup operations go here
 
}

}


})

 $btnReset.Add_Click({



$ResetButtonLog = "Reset by " + $env:username


Reset

$btnSearchACL.IsEnabled = $true


$btnSubmit.IsEnabled = $true

Write-Log $ResetButtonLog



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