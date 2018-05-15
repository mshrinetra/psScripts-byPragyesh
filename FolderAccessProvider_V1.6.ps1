#
# Folder Access Provider_V1.2.ps1
#
#==============================================================================================
# XAML Code - Imported from Visual Studio Express 2013 WPF Application
#==============================================================================================
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml]$XAML = @'
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="Folder Access Provider" FontWeight="Bold" Height="950" Width="900" WindowStartupLocation="CenterScreen" ResizeMode="CanMinimize">
    <Grid Margin="0,0,-0.2,0.2">
   
    <Border>
   

      <Canvas Background="#228B22">

     <TextBox Name="txtFolderPath" HorizontalAlignment="Left" Height="23" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Width="700" Canvas.Left="150" Canvas.Top="18"/>

              <Label FontWeight="Bold" Content="Folder Path" Canvas.Left="17" Canvas.Top="15"/>
           
             

             
            <TextBox Name="txtboxFolderPathOutput" HorizontalAlignment="Left" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Height="250" Width="700" Canvas.Left="150" Canvas.Top="50" Background="{DynamicResource {x:Static SystemColors.ControlLightLightBrushKey}}"/>
            
            
              <Label FontWeight="Bold" Content="ACL Details" Canvas.Left="17" Canvas.Top="50"/>
   
         <TextBox Name="txtGroupName" HorizontalAlignment="Left" Height="23" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Width="300" Canvas.Left="150" Canvas.Top="365"/>
            
           <Label FontWeight="Bold" Content="Group Name" Canvas.Left="17" Canvas.Top="365"/>

         <TextBox Name="txtUserNames" HorizontalAlignment="Left" Height="30" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Width="600" Canvas.Left="150" Canvas.Top="396"/>

         <Label FontWeight="Bold" Content="User Email" Canvas.Left="17" Canvas.Top="400"/>

        <TextBox Name="txtReqNo" HorizontalAlignment="Left" Height="23" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Width="150" Canvas.Left="150" Canvas.Top="435"/>

         <Label FontWeight="Bold" Content="Task/Request Number" Canvas.Left="17" Canvas.Top="430"/>

                 
                 
           <StackPanel  Margin="15" Canvas.Left="750" Canvas.Top="350">
                <Label FontWeight="Bold">Type of access</Label>

               
                <RadioButton Name="RadioName1" IsChecked="True" GroupName="Access" >Read+Modify</RadioButton>
                <RadioButton Name="RadioName2" GroupName="Access">Read Only</RadioButton>
                <RadioButton Name="RadioName3" GroupName="Access">List Only</RadioButton>
        </StackPanel>



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
        [string]$Path='C:\Logs\FolderAccessProvider.log', 

        [Parameter(Mandatory=$false)] 
        [Alias('LogPath2')] 
        [string]$Path2='\\10.16.99.13\D$\CWPS_Automation\Logs\FolderAccessProvider.log', 
         
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

$txtUserNames.ToolTip = " Please enter user email addresses with semicolon ( ; ) delimiter."


$txtFolderPath.ToolTip = "Please enter folder path \\ServerName.Countrycode.abb.com\FolderName\SubfolderName"


$txtGroupName.ToolTip = "Please enter the appropriate GroupName through above ACL search"

#===========================================================================
# AccessType Function
#===========================================================================



#===========================================================================
# Reset Function
#===========================================================================

function Reset{

$txtFolderPath.text = ""

$txtboxFolderPathOutput.text = ""


$txtGroupName.text = ""

$txtUserNames.Text = ""

$textBlock.text = ""

$txtboxFolderAccessOutput.Text = ""

$AccessType = ""

$txtReqNo.Text = ""

$textBlock.Background = '#FFFFFF'


$RadioName1.IsChecked = $true




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

$SearchACLButtonLog = "ACL Searched by " + $env:username

Write-Log $SearchACLButtonLog



$txtFolderPath = $txtFolderPath.text.Trim()


$ACLDetails =  Get-Acl $txtFolderPath -ErrorAction Stop | Format-List | out-string 

$AccessDetails = Get-NTFSAccess  $txtFolderPath | Format-Table | out-string

$ChildItemDetails = Get-ChildItem $txtFolderPath -Name -ErrorAction Stop | Format-List | out-string


$txtboxFolderPathOutput.text = $ACLDetails + $AccessDetails +                                
                          "List of subfolders and files:
                           "+
                           $ChildItemDetails

 $btnSearchACL.IsEnabled = $false

 $ACLLog = "ACL detils for folder Path - " + $txtFolderPath + " is found."

  Write-Log  $ACLLog

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





if ( ($txtGroupName.text.Length) -eq 0 -Or ($txtUserNames.text.Length) -eq 0 -or ($txtReqNo.text.Length) -eq 0)

{


[System.Windows.MessageBox]::Show("Group Name or User Email or Request Number is empty" ,"Error" )



}
else 

{



$SubmitButtonLog = "Submit by " + $env:username

Write-Log $SubmitButtonLog


$FolderPath = $txtFolderPath.text

$FolderPath = $FolderPath.Trim()


$GroupName = $txtGroupName.Text

$GroupName = $GroupName.Trim()






$txtUserNames = $txtUserNames.Text -split ";"


Write-Host $txtUserNames[1]



try
{




ForEach( $txtUserName in $txtUserNames)

{

Write-Host $txtUserName

$userName = $txtUserName

$userName =  $userName.Trim()




Get-Acl $FolderPath -ErrorAction Stop

$User = Get-ADUser -Server "de-s-abb0033.abb.com:3268" -Filter { EmailAddress -eq $userName } -ErrorAction Stop
$Group = Get-ADGroup -id $GroupName -Server "de-s-abb0033.abb.com:3268" -ErrorAction Stop



$GroupNameTemp = "LDAP://"+$Group

$UserNameTemp = "LDAP://"+$User

$Group = [ADSI]$GroupNameTemp

$Group.Add($UserNameTemp)



if($RadioName1.IsChecked)
{
$AccessType = $RadioName1.Content
}

else

{

if($RadioName2.IsChecked)
{
$AccessType = $RadioName2.Content
}

else 

{
$AccessType = $RadioName3.Content
}

}



      

}


$txtboxFolderAccessOutput.text =  
                       "                        Requested access has been provisioned. Following are the details.
                        Full Path:" + $txtFolderPath.Text +
                       " 
                      
                        Requested For:" +   $txtUserNames +                
                        "
                        Level of Access:  " + $AccessType +

                        " 
                      
                        Group Added :" +  $GroupName +
                        "
                        SOP/WI Referred : YES 
                        KB Article Referred : KB0010929 
                        Need KB Article : No
                        Snap Shot of solution : Please find in attachment.
                                                


                        •	Please check folder access after 90 minutes as Replication takes time.
                        •	Even post 90 min access is not available then kindly Restart your system.

                        •	Below are the steps to be followed for mapping shared folder.

                            1) Go to logo of Computer/This PC on desktop or click win+E or start->RUN->C: 
                            2) Right Click on Computer/This PC and select Map network drive option
                            3) Select the drive letter from list (Drive: option) that you want to give to shared folder .( Choose any free letter in Drive:)
                            4) Now in (Folder:) option copy above mentioned folder path as it is (" + $txtFolderPath.Text +  ") and paste it.
                            5) Select option 'Reconnect at logon'. Click on finish.
                            6) Refer KB article for more details on mapping share folder KB0013308

                        "



            $textBlock.Background = '#00FF00'


            $textBlock.text = $txtReqNo.text + "-Folder-" + $txtFolderPath.Text + "-"+ $AccessType +" - access is granted to -" + $txtUserNames +"- through -" + $GroupName


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