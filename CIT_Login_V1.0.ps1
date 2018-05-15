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
    Title="CWPS Integration Tool(CIT) Automation Tool" FontWeight="Bold" Height="800" Width="900" WindowStartupLocation="CenterScreen" ResizeMode="CanMinimize">
    <Grid Margin="0,0,-0.2,0.2">
   
    <Border>

    <Canvas Background="Green">


     <TextBox Name="txtUserName" HorizontalAlignment="Left" Height="23" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Width="200" Canvas.Left="250" Canvas.Top="200"/>

    <Label Content="UserName" Canvas.Left="150" Canvas.Top="200"/>
   <PasswordBox Name="txtpwBox"  Height="23" Width="200" MaxLength="20" Margin="250,250,0,0" />
 <Label Content="Password" Canvas.Left="150" Canvas.Top="250"/>

 <Label Name="statusText" HorizontalAlignment="Left" Margin="159,128,0,0" VerticalAlignment="Top" Width="200" Height="38"/>
         

            
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
# Reset Function
#===========================================================================

function Reset{

$txtFolderPath.text = ""


$txtboxFolderPath.text = ""



}


Function Test-ADAuthentication {
    param($username,$password)
    (new-object directoryservices.directoryentry "",$username,$password).psbase.name -ne $null
}



#===========================================================================
# Add events to Form Objects
#===========================================================================

$btnSubmit.Add_Click(
{


if ( ($txtUserName.Text.Length) -eq 0 -Or ($txtpwBox.Password.Length) -eq 0 )

{


[System.Windows.MessageBox]::Show("Parent Folder Path or Folder Name is empty" ,"Error" )



}

Else

{

try

{



$group = "U-XW-CWPS-IND-CIT Automation Tool"
$members = Get-ADGroupMember -Identity $group -Recursive | Select -ExpandProperty SAMAccountName 
$user = $txtUserName.Text.Split("\")

$TempUserName = $user[-1].ToString()

Write-Host $TempUserName

Get-ADuser $TempUserName -Server "de-s-abb0033.abb.com:3268" -ErrorAction Stop


If (((new-object directoryservices.directoryentry "",$txtUserName.Text,$txtpwBox.Password).psbase.name -ne $null) -and  ($members -contains $user[-1]))



{

Write-Host Successful

}

Else

{

[System.Windows.MessageBox]::Show("Password Wrong" ,"Error" )

}





}

Catch [Exception]

{





 
 [System.Windows.MessageBox]::Show(  $_.Exception.Message ,"Error" )



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