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
    Title="Bulk Process" FontWeight="Bold" Height="800" Width="900" WindowStartupLocation="CenterScreen" ResizeMode="CanMinimize">
    <Grid Margin="0,0,-0.2,0.2">
   
    <Border>

    <Canvas Background="Brown">
   

         

     
    <TextBox Name="txtFolderPath" HorizontalAlignment="Left" Height="23" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Width="650" Canvas.Left="100" Canvas.Top="28"/>

    <Label Content="Upload .CSV" Canvas.Left="17" Canvas.Top="25"/>

    <TextBox Name="txtboxFolderPath" HorizontalAlignment="Left" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Height="350" Width="750" Canvas.Left="100" Canvas.Top="113" Background="{DynamicResource {x:Static SystemColors.ControlLightLightBrushKey}}"/>
   
            <Label Content="OutPut" Canvas.Left="17" Canvas.Top="150"/>
            
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
# Reset Function
#===========================================================================

function Reset{

$txtFolderPath.text = ""


$txtboxFolderPath.text = ""



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








}


})



$btnSubmit.Add_Click(

{

$servers = Get-Content $txtFolderPath.Text


foreach ($server in $servers) {

    Write-Host $server

    

}


$txtboxFolderPath.text = $servers


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