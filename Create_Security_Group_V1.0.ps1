##[Ps1 To Exe]
##
##Kd3HDZOFADWE8uK1
##Nc3NCtDXThU=
##Kd3HFJGZHWLWoLaVvnQnhQ==
##LM/RF4eFHHGZ7/K1
##K8rLFtDXTiW5
##OsHQCZGeTiiZ4dI=
##OcrLFtDXTiW5
##LM/BD5WYTiiZ4tI=
##McvWDJ+OTiiZ4tI=
##OMvOC56PFnzN8u+Vs1Q=
##M9jHFoeYB2Hc8u+Vs1Q=
##PdrWFpmIG2HcofKIo2QX
##OMfRFJyLFzWE8uK1
##KsfMAp/KUzWJ0g==
##OsfOAYaPHGbQvbyVvnQX
##LNzNAIWJGmPcoKHc7Do3uAuO
##LNzNAIWJGnvYv7eVvnQX
##M9zLA5mED3nfu77Q7TV64AuzAgg=
##NcDWAYKED3nfu77Q7TV64AuzAgg=
##OMvRB4KDHmHQvbyVvnQX
##P8HPFJGEFzWE8tI=
##KNzDAJWHD2fS8u+Vgw==
##P8HSHYKDCX3N8u+Vgw==
##LNzLEpGeC3fMu77Ro2k3hQ==
##L97HB5mLAnfMu77Ro2k3hQ==
##P8HPCZWEGmaZ7/K1
##L8/UAdDXTlGDjoL+0AhH6lzrUHsja8mX+aWk1ois6/nQjyDKXZMaTmhUhCz9EE6CavcRQOccoMgucg8lOuI01OOeS6msXadq
##Kc/BRM3KXhU=
##
##
##fd6a9f26a06ea3bc99616d4851b372ba
# 
# Create_Security_Group_V1.0.ps1
#
#==============================================================================================
# XAML Code - Imported from Visual Studio Express 2013 WPF Application
#==============================================================================================
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml]$XAML = @'
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="Get Security Group Name-V1.0-Testing Phase" Height="800" Width="900" WindowStartupLocation="CenterScreen" ResizeMode="CanMinimize">
    <Grid Margin="0,0,-0.2,0.2">

        <Border>
            <Canvas>
                <Canvas.Background>
                    <LinearGradientBrush EndPoint="0.5,1" StartPoint="0.5,0">
                        <GradientStop Color="Black"/>
                        <GradientStop Color="#FF1B8FC5" Offset="0.03"/>
                    </LinearGradientBrush>
                </Canvas.Background>

                <TextBox Name="txtFolderPath" HorizontalAlignment="Left" Height="23" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Width="650" Canvas.Left="150" Canvas.Top="28"/>


                <TextBox Name="txtCountryCode" HorizontalAlignment="Left" Height="23" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Width="45" Canvas.Left="150" Canvas.Top="66"/>

                <TextBox Name="txtboxFolderPath" HorizontalAlignment="Left" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Height="116" Width="532" Canvas.Left="150" Canvas.Top="314" Background="{DynamicResource {x:Static SystemColors.ControlLightLightBrushKey}}"/>
                <Label Content="Full Folder Path" Canvas.Left="17" Canvas.Top="25"/>
                <Label Content="Security Groups" Canvas.Left="17" Canvas.Top="314"/>
                <Label Content="Country Code" Canvas.Left="17" Canvas.Top="63"/>
                <Label Content="List Group Name" Canvas.Left="16" Canvas.Top="225"/>
                <Label Content="Write Group Name" Canvas.Left="17" Canvas.Top="179"/>
                <Label Content="Read Group Name" Canvas.Left="16" Canvas.Top="138"/>
                <TextBox Name="txtReadGroup" HorizontalAlignment="Left" Height="23" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Width="532" Canvas.Left="150" Canvas.Top="228" Background="#FF16EC2A"/>
                <TextBox Name="txtWriteGroup" HorizontalAlignment="Left" Height="23" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Width="532" Canvas.Left="150" Canvas.Top="182" Background="#FF0CF021"/>
                <TextBox Name="txtListGroup" HorizontalAlignment="Left" Height="23" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Width="532" Canvas.Left="150" Canvas.Top="141" Background="#FF0DF322"/>

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

$txtCountryCode.text = ""
$txtReadGroup.text = ""
$txtWriteGroup.text = ""
$txtListGroup.text = ""

}


#===========================================================================
# Add events to Form Objects
#===========================================================================

$btnSubmit.Add_Click(
{





if ( (($txtFolderPath.text.Length) -eq 0) -or (($txtCountryCode.text.Length) -eq 0) ) 
{


[System.Windows.MessageBox]::Show("Folder Path or Country Code is not entered" ,"Error" )



}
else 

{

try

{




$FolderPaths = $txtFolderPath.text

$FolderPaths = $FolderPaths.Split("\")

$CountryCode= $txtCountryCode.text

$ListGroupName = "U-$CountryCode-L"

$ReadGroupName = "U-$CountryCode-R"

$WriteGroupName = "U-$CountryCode-C"



$i=0

foreach($FolderPath in $FolderPaths)

{


if (($i -le 2) -or $FolderPath.Contains("$") )

{

}
else
{


$FolderPath = "-$FolderPath"

$ListGroupName += $FolderPath

$ReadGroupName += $FolderPath

$WriteGroupName += $FolderPath


}
$i++

}

$txtReadGroup.text = $ListGroupName 
$txtWriteGroup.text = $WriteGroupName
$txtListGroup.text = $ReadGroupName 

$txtboxFolderPath.text = "

                          Read Group - $ReadGroupName 
                          Write Group - $WriteGroupName
                          List Group - $ListGroupName 

                       "

}

Catch [Exception]

{




$txtboxFolderPath.text = "Error : " + $_.Exception.Message + $tempUserHomeDrive




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