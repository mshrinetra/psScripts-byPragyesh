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
    Title="ACL Finder" Height="800" Width="900" WindowStartupLocation="CenterScreen" ResizeMode="CanMinimize">
    <Grid Margin="0,0,-0.2,0.2">
   
    <Border>
        <Canvas Background="{DynamicResource {x:Static SystemColors.HighlightBrushKey}}">
           
            <TextBox Name="txtFolderPath" HorizontalAlignment="Left" Height="23" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Width="750" Canvas.Left="100" Canvas.Top="28"/>
            <TextBox Name="txtboxFolderPath" HorizontalAlignment="Left" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Height="350" Width="750" Canvas.Left="100" Canvas.Top="113" Background="{DynamicResource {x:Static SystemColors.ControlLightLightBrushKey}}"/>
            <Label Content="Folder Path" Canvas.Left="17" Canvas.Top="25"/>
            <Label Content="ACL Details" Canvas.Left="17" Canvas.Top="150"/>
            
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


#===========================================================================
# Add events to Form Objects
#===========================================================================

$btnSubmit.Add_Click(
{

try

{

 $ACLDetails =  Get-Acl $txtFolderPath.text -ErrorAction Stop| Format-List | out-string 

 $AccessDetails = Get-NTFSAccess  $txtFolderPath.text | Format-Table | out-string 

 $ChildItemDetails = Get-ChildItem $txtFolderPath.text  -Name | Format-List | out-string


  $txtboxFolderPath.text = $ACLDetails + 
                            $AccessDetails +
                          "Folder Details:"+
                           $ChildItemDetails

$btnSubmit.IsEnabled = $false

}

Catch [Exception]

{




$txtboxFolderPath.text = "Error : " + $_.Exception.Message + $tempUserHomeDrive




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