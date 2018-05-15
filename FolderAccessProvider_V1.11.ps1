#
# Folder Access Provider_V1.11.ps1
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

     <TextBox Name="txtFolderPath" HorizontalAlignment="Left" Height="23" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Width="600" Canvas.Left="150" Canvas.Top="18"/>

              <Label FontWeight="Bold" Content="Folder Path" Canvas.Left="17" Canvas.Top="15"/>
           
             

             
            <TextBox Name="txtboxFolderPathOutput" HorizontalAlignment="Left" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Height="235" Width="700" Canvas.Left="150" Canvas.Top="50" Background="{DynamicResource {x:Static SystemColors.ControlLightLightBrushKey}}"/>
            
            
              <Label FontWeight="Bold" Content="ACL Details" Canvas.Left="17" Canvas.Top="50"/>

                 <RadioButton Name="RadioButton4" IsChecked="False" HorizontalAlignment="Left" Margin="150,300,0,0" VerticalAlignment="Top" >Listed Folder Path</RadioButton>
           
           <RadioButton Name="RadioButton5" IsChecked="False" HorizontalAlignment="Left" Margin="300,300,0,0" VerticalAlignment="Top" >Unlisted Folder Path</RadioButton>


   
         <TextBox Name="txtGroupName" HorizontalAlignment="Left" Height="23" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Width="300" Canvas.Left="150" Canvas.Top="365"/>
            
           <Label FontWeight="Bold" Content="Group Name" Canvas.Left="17" Canvas.Top="365"/>

         <TextBox Name="txtUserNames" HorizontalAlignment="Left" Height="30" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Width="600" Canvas.Left="150" Canvas.Top="396"/>

         <Label FontWeight="Bold" Content="User Email" Canvas.Left="17" Canvas.Top="400"/>

        <TextBox Name="txtReqNo" HorizontalAlignment="Left" Height="23" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Width="150" Canvas.Left="150" Canvas.Top="435"/>

         <Label FontWeight="Bold" Content="TASK Number" Canvas.Left="17" Canvas.Top="430"/>
          
        
                 
           <StackPanel  Margin="15" Canvas.Left="750" Canvas.Top="350">
                <Label FontWeight="Bold">Type of access</Label>

               
                <RadioButton Name="RadioName1" IsChecked="False" GroupName="Access" >Read+Modify</RadioButton>
                <RadioButton Name="RadioName2" IsChecked="False" GroupName="Access">Read Only</RadioButton>
                <RadioButton Name="RadioName3" IsChecked="False" GroupName="Access">List Only</RadioButton>
                
        </StackPanel>



             <TextBlock Name="textBlock" HorizontalAlignment="Left" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Height="20" Width="700" Canvas.Left="150" Canvas.Top="725" Background="{DynamicResource {x:Static SystemColors.ControlLightLightBrushKey}}"/>
             <Label FontWeight="Bold" Content="Status" Canvas.Left="17" Canvas.Top="725"/>

             <TextBox Name="txtboxFolderAccessOutput" HorizontalAlignment="Left" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Height="250" Width="700" Canvas.Left="150" Canvas.Top="475" Background="{DynamicResource {x:Static SystemColors.ControlLightLightBrushKey}}"/>
            <Label FontWeight="Bold" Content="Output" Canvas.Left="17" Canvas.Top="475"/>
            
        </Canvas>



    </Border>


    <Button Name="btnOpenFolder" Content="Open" IsEnabled="true" HorizontalAlignment="Left" Margin="775,18,0,0" VerticalAlignment="Top" Width="100" Height="23" BorderThickness="0"/>

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

$Global:DeviationFolderUS = "\\uslkm-s-file001.us.abb.com\Projects\Files1\eng_prod\jobs", "\\uslkm-s-file001.us.abb.com\Projects\Eng_Stan\released", "\\uslkm-s-file001.us.abb.com\Projects\Eng_Project","\\uslkm-s-file001.us.abb.com\Projects\bloomdwg","\\uslkm-s-file001.us.abb.com\Groups\LKM-PTMV-ALL"



$Global:DeviationFolderMX = "\\MXSLP-S-0113053.mx.abb.com\Groups\ZC","\\MXSLP-S-0113053.mx.abb.com\Groups\DM","\\MXSLP-S-0113053.mx.abb.com\Groups\LP","\\MXSLP-S-0113053.mx.abb.com\Groups\PA","\\MXSLP-S-0113053.mx.abb.com\Groups\PP","\\MXSLP-S-0113053.mx.abb.com\Groups\PGGI&PGGA"


$Global:DeviationFolderFI = "FIVAA-S-TE00080.fi.abb.com","FIVAA-S-TE00106.fi.abb.com","FIVAA-S-TE00151.fi.abb.com","FIHEL-S-TE00155.FI.ABB.COM","FIHEL-S-TE00179.FI.ABB.COM"


$Global:DeviationFolderNOSE = "NO-S-DRMEUC01.no.abb.com","NO-S-FYLEUC01.no.abb.com","NO-S-SKEEUC01.no.abb.com","NO-S-SVGEUC01.no.abb.com","no-x-0000200.nmea.abb.com","no-x-0000234.nmea.abb.com","SE-S-NAS0001","SE-S-NAS0002","SE-S-NAS0003","SE-S-NAS0004","SE-S-NAS0005","SE-S-NAS0006","SE-S-NAS0007","SE-S-NYOEUC001.se.abb.com"

$Global:AccessType = $null

$Global:FolderListing = $null

#===========================================================================
# Database Function
#===========================================================================
Function CITDatabase ([string]$TaskNumber,[string]$ProcessedBy,[string]$ActionPerformed,[string]$FolderPath,[string]$AccessType,[string]$Groupname,[string]$Listing,[string]$UserName )

{

[string] $Server= "10.16.99.15,1433"

[string] $Database = "CITDatabase"


$uid = $env:username
 


$Command = New-Object System.Data.SQLClient.SQLCommand

$Command.Connection = $Connection

 

$SqlConnection = New-Object System.Data.SqlClient.SqlConnection

$SqlConnection.ConnectionString = "Server = $Server; Database = $Database; Integrated Security = True; User ID = $uid;"

try{

 $SqlConnection.Open()


 
[string] $SqlQuery= $("INSERT INTO FolderAccessProvider VALUES ('$TaskNumber',DEFAUlT,'$ProcessedBy','$ActionPerformed','$FolderPath','$AccessType','$Groupname','$Listing','$UserName');")



$SqlCmd = New-Object System.Data.SqlClient.SqlCommand

$SqlCmd.CommandText = $SqlQuery



$SqlCmd.Connection = $SqlConnection


$SqlCmd.ExecuteNonQuery()





}

 Catch [Exception]

{


[System.Windows.MessageBox]::Show($_.Exception.Message  ,"Error" )




}

Finally

{
 $SqlConnection.Close()

 }

 }


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

$Global:AccessType = $null

$Global:FolderListing = $null

$txtReqNo.Text = ""

$textBlock.Background = '#FFFFFF'


$RadioName1.IsChecked = $false
$RadioName2.IsChecked = $false
$RadioName3.IsChecked = $false
$RadioButton4.IsChecked = $false
$RadioButton5.IsChecked = $false



}


#===========================================================================
# Add events to Form Objects
#===========================================================================






#===========================================================================
# Add events to Form Objects - Submit Button
#===========================================================================





$btnOpenFolder.Add_Click(
{


if ( ($txtFolderPath.text.Length) -eq 0)

{


[System.Windows.MessageBox]::Show("Folder Path is empty" ,"Error" )



}

else 

{

try

{

$OpenFolderButtonLog = "ACL Searched and Folder Path opened by -" + $env:username

Write-Log $OpenFolderButtonLog





$txtFolderPath = $txtFolderPath.text.Trim()


If(($Global:DeviationFolderFI | ForEach-Object { $txtFolderPath -like "*$_*"}) -eq $true )
  
  {

[System.Windows.MessageBox]::Show(" Deviation 

Step 1: If ticket is for providing access to the share folders on below servers, then send an email to abb.servicedesk@tieto.com

FIVAA-S-TE00080.fi.abb.com
FIVAA-S-TE00106.fi.abb.com
FIVAA-S-TE00151.fi.abb.com
FIHEL-S-TE00155.FI.ABB.COM
FIHEL-S-TE00179.FI.ABB.COM

Step 2: Update the status of the ticket based on the information received.

Email Template:

    Hello Team,

    Kindly please provide security group then we can add user:
    Ticket Number : XXXXXX

    Issue Reported :  Manage access to shared folder 
    Contact Reason : Need Access  for below mentioned folder. 
    Folder Path : As mentioned by user the path is following :  XXXXXXXXXXXXXXX
    User need access :       XXXXXXXXXXXXXXXX
    Access Type: XXXXXXXXXXXXXXXXX




" ,"Warning" )


  }


  If(($Global:DeviationFolderNOSE  | ForEach-Object { $txtFolderPath -like "*$_*"}) -eq $true )
  
  {

[System.Windows.MessageBox]::Show(" Deviation 



Step 1: Folder to which access is to be provided, its name will be mentioned in the ticket.
Step 2: From the security tab of this folder identify the relevant security group being used for providing access.
Step 3: In the folder owner document, in NO and SE sheet, list of security groups and those security groups’ owner name(s) is mentioned and not the folder owner names. Security group identified in above step2 will be searched in the respective sheets.
Owner(s) can also be seen in description field of Security Groups.
Step 4: Once security group owner is identified, send a mail to this owner for seeking permission to add user to the security group in order to provide access to share folder.
Step 5: Once approved by the owner, add the user(s) to the security group in AD.
Step 6: Inform the Wipro File Service Leads to update the Folder owner document with folder name and its owner name.
Step 7: Ticket will be resolved.



" ,"Warning" )


  }



   If(($Global:DeviationFolderUS | ForEach-Object { $txtFolderPath -like "*$_*"}) -eq $true )
  
  {

[System.Windows.MessageBox]::Show(" Deviation 

Step 1: If ticket for granting access for below listed shared folders of US is received then the security group which is used for granting access is identified. 
\\uslkm-s-file001.us.abb.com\Projects\Files1\eng_prod\jobs 
\\uslkm-s-file001.us.abb.com\Projects\Eng_Stan\released
\\uslkm-s-file001.us.abb.com\Projects\Eng_Project 
\\uslkm-s-file001.us.abb.com\Projects\bloomdwg
\\uslkm-s-file001.us.abb.com\Groups\LKM-PTMV-ALL
For these shared folders owners are from Mexico
Step 2: If the identified security group is available in below list then email is sent to the Fabian Romero (fabian.romero@mx.abb.com) to provide approval to grant access these shared folders. 
Secondary owner Cecilia Rojas (cecilia.rojas@mx.abb.com) will be approached if the primary owner Fabian Romero is not available.

Name Group	Primary Owner 	Secondary Owner 
MX-ABB LMW Electrical Drafter	Fabian Romero 	Cecilia Rojas
MX-ABB LMW Electrical Engineer	Fabian Romero 	Cecilia Rojas
MX-ABB LMW Engineering Manager	Fabian Romero 	Cecilia Rojas
MX-ABB LMW Marketing Coordinator	Fabian Romero 	Cecilia Rojas
MX-ABB LMW Mechanical Engineer	Fabian Romero 	Cecilia Rojas
MX-ABB LMW Production Leader	Fabian Romero 	Cecilia Rojas
MX-ABB LMW Project Engineer	Fabian Romero 	Cecilia Rojas
MX-ABB LMW Quality Inspector	Fabian Romero 	Cecilia Rojas
MX-ABB LMW R&D Manager	Fabian Romero 	Cecilia Rojas

Step 3: Once approval is received then follow the process to grant the access by adding user to the respective security group.
Step 4: Once access is granted then user must run the Map M Network Drive (Lake Mary).bat.     
 
Step 5: User will be prompted to provide credentials.
Step 6: If the credentials are correct then the share paths mentioned in batch file are mapped.
" ,"Warning" )


  }

If(($Global:DeviationFolderMX | ForEach-Object { $txtFolderPath -like "*$_*"}) -eq $true )
  
  {

[System.Windows.MessageBox]::Show(" Deviation 

Step 1:  Folder to which access is to be provided, its name will be mentioned in the ticket
Step 2: Folder must be residing inside one of these parent folders (principal folders): LP, ZC, PA, PP, DM, or PGGGI&PGGA.

\\MXSLP-S-0113053.mx.abb.com\Groups\ZC
\\MXSLP-S-0113053.mx.abb.com\Groups\DM
\\MXSLP-S-0113053.mx.abb.com\Groups\LP
\\MXSLP-S-0113053.mx.abb.com\Groups\PA
\\MXSLP-S-0113053.mx.abb.com\Groups\PP
\\MXSLP-S-0113053.mx.abb.com\Groups\PGGI&PGGA 

For eg. \\MXSLP-S-0113053\Groups\ZC\ZCCO\Conciliaciones. 

In this case folder Conciliaciones has parent folder ZC.

Step 3: While granting access to the requested folder we must also add the user(s) to another dedicated security group associated to these parent folders (principal folder). These groups are as below,
Folder LP -> MX-LPLS.
Folder ZC -> MX-ZC ZCCO.
Folder PA -> MX-PA.
Folder PP -> MX-PP PTPM, MX-PP PTPR.
Folder DM -> MX-DM. 
Folder PGGGI&PGGA -> MX-PS PSSS, MX-PS-PSAC.
Step 4: Hence as in above example user should be added in two groups. One for shared folder and one for principal folder.  (e.g. MX-ZC ZCCO Conciliaciones Editors and MX-ZC ZCCO respectively.)

" ,"Warning" )


  }







$ACLDetails =  Get-Acl $txtFolderPath -ErrorAction Stop | Format-List | out-string 

$AccessDetails = Get-NTFSAccess  $txtFolderPath | Format-Table | out-string

$ChildItemDetails = Get-ChildItem $txtFolderPath -Name -ErrorAction Stop | Format-List | out-string


$txtboxFolderPathOutput.text = $ACLDetails + $AccessDetails +                                
                          "List of subfolders and files:
                           "+
                           $ChildItemDetails

Invoke-Item $txtFolderPath

$btnOpenFolder.IsEnabled = $false

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



If(($Global:DeviationFolderFI | ForEach-Object { $txtFolderPath -like "*$_*"}) -eq $true )
  
  {

[System.Windows.MessageBox]::Show(" Deviation 

Step 1: If ticket is for providing access to the share folders on below servers, then send an email to abb.servicedesk@tieto.com

FIVAA-S-TE00080.fi.abb.com
FIVAA-S-TE00106.fi.abb.com
FIVAA-S-TE00151.fi.abb.com
FIHEL-S-TE00155.FI.ABB.COM
FIHEL-S-TE00179.FI.ABB.COM

Step 2: Update the status of the ticket based on the information received.

Email Template:

    Hello Team,

    Kindly please provide security group then we can add user:
    Ticket Number : XXXXXX

    Issue Reported :  Manage access to shared folder 
    Contact Reason : Need Access  for below mentioned folder. 
    Folder Path : As mentioned by user the path is following :  XXXXXXXXXXXXXXX
    User need access :       XXXXXXXXXXXXXXXX
    Access Type: XXXXXXXXXXXXXXXXX




" ,"Warning" )


  }


  If(($Global:DeviationFolderNOSE  | ForEach-Object { $txtFolderPath -like "*$_*"}) -eq $true )
  
  {

[System.Windows.MessageBox]::Show(" Deviation 



Step 1: Folder to which access is to be provided, its name will be mentioned in the ticket.
Step 2: From the security tab of this folder identify the relevant security group being used for providing access.
Step 3: In the folder owner document, in NO and SE sheet, list of security groups and those security groups’ owner name(s) is mentioned and not the folder owner names. Security group identified in above step2 will be searched in the respective sheets.
Owner(s) can also be seen in description field of Security Groups.
Step 4: Once security group owner is identified, send a mail to this owner for seeking permission to add user to the security group in order to provide access to share folder.
Step 5: Once approved by the owner, add the user(s) to the security group in AD.
Step 6: Inform the Wipro File Service Leads to update the Folder owner document with folder name and its owner name.
Step 7: Ticket will be resolved.



" ,"Warning" )


  }



   If(($Global:DeviationFolderUS | ForEach-Object { $txtFolderPath -like "*$_*"}) -eq $true )
  
  {

[System.Windows.MessageBox]::Show(" Deviation 

Step 1: If ticket for granting access for below listed shared folders of US is received then the security group which is used for granting access is identified. 
\\uslkm-s-file001.us.abb.com\Projects\Files1\eng_prod\jobs 
\\uslkm-s-file001.us.abb.com\Projects\Eng_Stan\released
\\uslkm-s-file001.us.abb.com\Projects\Eng_Project 
\\uslkm-s-file001.us.abb.com\Projects\bloomdwg
\\uslkm-s-file001.us.abb.com\Groups\LKM-PTMV-ALL
For these shared folders owners are from Mexico
Step 2: If the identified security group is available in below list then email is sent to the Fabian Romero (fabian.romero@mx.abb.com) to provide approval to grant access these shared folders. 
Secondary owner Cecilia Rojas (cecilia.rojas@mx.abb.com) will be approached if the primary owner Fabian Romero is not available.

Name Group	Primary Owner 	Secondary Owner 
MX-ABB LMW Electrical Drafter	Fabian Romero 	Cecilia Rojas
MX-ABB LMW Electrical Engineer	Fabian Romero 	Cecilia Rojas
MX-ABB LMW Engineering Manager	Fabian Romero 	Cecilia Rojas
MX-ABB LMW Marketing Coordinator	Fabian Romero 	Cecilia Rojas
MX-ABB LMW Mechanical Engineer	Fabian Romero 	Cecilia Rojas
MX-ABB LMW Production Leader	Fabian Romero 	Cecilia Rojas
MX-ABB LMW Project Engineer	Fabian Romero 	Cecilia Rojas
MX-ABB LMW Quality Inspector	Fabian Romero 	Cecilia Rojas
MX-ABB LMW R&D Manager	Fabian Romero 	Cecilia Rojas

Step 3: Once approval is received then follow the process to grant the access by adding user to the respective security group.
Step 4: Once access is granted then user must run the Map M Network Drive (Lake Mary).bat.     
 
Step 5: User will be prompted to provide credentials.
Step 6: If the credentials are correct then the share paths mentioned in batch file are mapped.
" ,"Warning" )


  }

If(($Global:DeviationFolderMX | ForEach-Object { $txtFolderPath -like "*$_*"}) -eq $true )
  
  {

[System.Windows.MessageBox]::Show(" Deviation 

Step 1:  Folder to which access is to be provided, its name will be mentioned in the ticket
Step 2: Folder must be residing inside one of these parent folders (principal folders): LP, ZC, PA, PP, DM, or PGGGI&PGGA.

\\MXSLP-S-0113053.mx.abb.com\Groups\ZC
\\MXSLP-S-0113053.mx.abb.com\Groups\DM
\\MXSLP-S-0113053.mx.abb.com\Groups\LP
\\MXSLP-S-0113053.mx.abb.com\Groups\PA
\\MXSLP-S-0113053.mx.abb.com\Groups\PP
\\MXSLP-S-0113053.mx.abb.com\Groups\PGGI&PGGA 

For eg. \\MXSLP-S-0113053\Groups\ZC\ZCCO\Conciliaciones. 

In this case folder Conciliaciones has parent folder ZC.

Step 3: While granting access to the requested folder we must also add the user(s) to another dedicated security group associated to these parent folders (principal folder). These groups are as below,
Folder LP -> MX-LPLS.
Folder ZC -> MX-ZC ZCCO.
Folder PA -> MX-PA.
Folder PP -> MX-PP PTPM, MX-PP PTPR.
Folder DM -> MX-DM. 
Folder PGGGI&PGGA -> MX-PS PSSS, MX-PS-PSAC.
Step 4: Hence as in above example user should be added in two groups. One for shared folder and one for principal folder.  (e.g. MX-ZC ZCCO Conciliaciones Editors and MX-ZC ZCCO respectively.)

" ,"Warning" )


  }








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



if($RadioName1.IsChecked)
{
$Global:AccessType = $RadioName1.Content
}

else

{

if($RadioName2.IsChecked)
{
$Global:AccessType = $RadioName2.Content
}

else 

{
if($RadioName3.IsChecked) 
    {

    $Global:AccessType = $RadioName3.Content
    }

}

}


if($RadioButton4.IsChecked) 
    {

    $Global:FolderListing = $RadioButton4.Content
    }
elseif ($RadioButton5.IsChecked) 

{

$Global:FolderListing = $RadioButton5.Content

}




if ( ($txtGroupName.text.Length) -eq 0 -Or ($txtUserNames.text.Length) -eq 0 -or ($txtReqNo.text.Length) -eq 0 -or  (-not $txtReqNo.text.contains("TASK")) -or ($Global:AccessType -eq $null)-or ($Global:FolderListing -eq $null))

{


[System.Windows.MessageBox]::Show("Group Name or User Email or TASK Number or AccesssType is empty or Listing detail is empty" ,"Error" )



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






try
{




ForEach( $txtUserName in $txtUserNames)

{



$userName = $txtUserName

$userName =  $userName.Trim()




Get-Acl $FolderPath -ErrorAction Stop

$User = Get-ADUser -Server "de-s-abb0033.abb.com:3268" -Filter { EmailAddress -eq $userName } -ErrorAction Stop
$Group = Get-ADGroup -id $GroupName -Server "de-s-abb0033.abb.com:3268" -ErrorAction Stop



$GroupNameTemp = "LDAP://"+$Group

$UserNameTemp = "LDAP://"+$User

$Group = [ADSI]$GroupNameTemp

$Group.Add($UserNameTemp)






      

}


$txtboxFolderAccessOutput.text =  
                       "                        Requested access has been provisioned. Following are the details.
                        Full Path:" + $txtFolderPath.Text +
                       " 
                      
                        Requested For:" +   $txtUserNames +                
                        "
                        Level of Access:  " + $Global:AccessType +

                        " 
                      
                        Group Added :" +  $GroupName +
                        "
                        SOP/WI Referred : YES 
                        KB Article Referred : KB0010929 
                        Need KB Article : No

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


            $textBlock.text = ";"+ $Global:FolderListing + ";" +$txtReqNo.text + ";" + $txtFolderPath.Text + ";"+ $Global:AccessType + ";"+ $GroupName + ";--access is granted to--;" + $txtUserNames 


            $ScriptExecutionLog = "Executed from:   " + (Get-Item -Path ".\" -Verbose).FullName


            $btnSubmit.IsEnabled = $false

            Write-Log $textBlock.text

            CITDatabase -TaskNumber $txtReqNo.text -ProcessedBy $env:username -ActionPerformed "Submit" -FolderPath $txtFolderPath.Text -AccessType $Global:AccessType -Groupname $Groupname -Listing $Global:FolderListing -UserName $txtUserNames 

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

$btnOpenFolder.IsEnabled = $true

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