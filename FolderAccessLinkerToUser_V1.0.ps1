#
# FolderAccessLinkerToUser_V1.0.ps1
#
#==============================================================================================
# XAML Code - Imported from Visual Studio Express 2013 WPF Application
#==============================================================================================
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml]$XAML = @'
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="Link Folder Access Rights To User" Height="800" Width="900" WindowStartupLocation="CenterScreen" ResizeMode="CanMinimize">
    <Grid Margin="0,0,-0.2,0.2">
   
    <Border>
   

      <Canvas Background="#DEB887">

     <TextBox Name="txtFolderPath" HorizontalAlignment="Left" Height="23" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Width="600" Canvas.Left="250" Canvas.Top="18"/>

              <Label FontWeight="Bold" Content="Folder Path" Canvas.Left="17" Canvas.Top="15"/>
           
             <StackPanel  Margin="15" Canvas.Left="250" Canvas.Top="40">
                <Label FontWeight="Bold">Type of access</Label>

               
                <RadioButton Name="RadioName1" IsChecked="True" GroupName="Access" >Modify</RadioButton>
                <RadioButton Name="RadioName2" GroupName="Access">Read</RadioButton>
                <RadioButton Name="RadioName3" GroupName="Access">Full Control</RadioButton>
                
        </StackPanel>           

        


         <TextBox Name="txtUserName" HorizontalAlignment="Left" Height="23" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Width="300" Canvas.Left="250" Canvas.Top="150"/>

         <Label FontWeight="Bold" Content="User ID/Name/Email" Canvas.Left="17" Canvas.Top="150"/>

         <TextBox Name="txtRequestNo" HorizontalAlignment="Left" Height="23" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Width="300" Canvas.Left="250" Canvas.Top="200"/>

         <Label FontWeight="Bold" Content="Task/Request Number" Canvas.Left="17" Canvas.Top="200"/>

                           




          <TextBlock Name="textBlock" HorizontalAlignment="Left" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Height="20" Width="600" Canvas.Left="250" Canvas.Top="525" Background="{DynamicResource {x:Static SystemColors.ControlLightLightBrushKey}}"/>
             <Label FontWeight="Bold" Content="Status" Canvas.Left="17" Canvas.Top="525"/>

             <TextBox Name="txtboxFolderAccessOutput" HorizontalAlignment="Left" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Height="250" Width="600" Canvas.Left="250" Canvas.Top="250" Background="{DynamicResource {x:Static SystemColors.ControlLightLightBrushKey}}"/>
            <Label FontWeight="Bold" Content="Output" Canvas.Left="17" Canvas.Top="250"/>
            
        </Canvas>



    </Border>



   

      <Button Name="btnSubmit" Content="Submit" IsEnabled="true" HorizontalAlignment="Left" Margin="0,575,0,0" VerticalAlignment="Top" Width="900" Height="34" BorderThickness="0"/>
    
       <Button Name="btnReset" Content="Reset" HorizontalAlignment="Left" Margin="0,625,0,0" VerticalAlignment="Top" Width="900" Height="34" BorderThickness="0"/>
        <Button Name="btnExit" Content="Exit" HorizontalAlignment="Left" Margin="0,675,0,0" VerticalAlignment="Top" Width="900" Height="34" BorderThickness="0"/>
      
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
        [string]$Path='C:\Logs\FolderLinkerToUser.log', 

        [Parameter(Mandatory=$false)] 
        [Alias('LogPath2')] 
        [string]$Path2='\\10.16.99.13\D$\CWPS_Automation\Logs\FolderLinkerToUser.log', 
         
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


$txtRequestNo.Text = ""



$txtUserName.Text = ""

$textBlock.text = ""

$txtboxFolderAccessOutput.Text = ""

$AccessType = ""


$textBlock.Background = '#FFFFFF'


$RadioName1.IsChecked = $true




}


#===========================================================================
# Add events to Form Objects
#===========================================================================






#===========================================================================
# Add events to Form Objects - Submit Button
#===========================================================================



$btnSubmit.Add_Click(


{





if ( ($txtRequestNo.text.Length) -eq 0 -Or ($txtUserName.text.Length) -eq 0 )

{


[System.Windows.MessageBox]::Show("User ID/Name/Email is empty" ,"Error" )



}
else 

{



$SubmitButtonLog = "Submit by " + $env:username

Write-Log $SubmitButtonLog


$FolderPath = $txtFolderPath.text

$FolderPath = $FolderPath.Trim()




$userName = $txtUserName.text

$userName =  $userName.Trim()

Write-Host $userName

Write-Host $FolderPath


try
{

Get-Acl $FolderPath -ErrorAction Stop

$User = Get-ADUser -Server "de-s-abb0033.abb.com:3268" -Filter { Name -eq $userName -Or EmailAddress -eq $userName -Or SAMAccountName -eq $userName} -ErrorAction Stop 

$User = $User.SAMAccountName 


if($RadioName1.IsChecked)
{         
            $Acl = Get-Acl $FolderPath
                                    
            $Ar = New-Object  system.security.accesscontrol.filesystemaccessrule( $User,"Modify",'ContainerInherit,ObjectInherit', 'None', 'Allow')
            $Acl.SetAccessRule($Ar)
            Set-Acl $FolderPath $Acl -ErrorAction Stop

            $AccessType = $RadioName1.Content
}


else 

{

if($RadioName2.IsChecked)

{

            $Acl = Get-Acl $FolderPath
                                    
            $Ar = New-Object  system.security.accesscontrol.filesystemaccessrule( $User,"Read",'ContainerInherit,ObjectInherit', 'None', 'Allow')
            $Acl.SetAccessRule($Ar)
            Set-Acl $FolderPath $Acl -ErrorAction Stop

            $AccessType = $RadioName2.Content

}
else
{

            $Acl = Get-Acl $FolderPath
                                    
            $Ar = New-Object  system.security.accesscontrol.filesystemaccessrule( $User,"FullControl",'ContainerInherit,ObjectInherit', 'None', 'Allow')
            $Acl.SetAccessRule($Ar)
            Set-Acl $FolderPath $Acl -ErrorAction Stop

            $AccessType = $RadioName3.Content

}

}




$txtboxFolderAccessOutput.text =  
                       "                        Requested access has been provisioned. Following are the details.
                        Full Path:" + $txtFolderPath.Text +
                       " 
                      
                        Requested For:" +   $User +                
                        "
                        Level of Access:  " + $AccessType +


                        "
                        SOP/WI Referred : YES 
                        KB Article Referred : KB0010929 
                        Need KB Article : No
                        Snap Shot of solution : Please find in attachment.

                        Please check folder access after 60 minutes because replication takes time.   "



            $textBlock.Background = '#00FF00'


            $textBlock.text = $txtRequestNo.text + "-Folder-" + $txtFolderPath.Text + " access is granted to -" + $User


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