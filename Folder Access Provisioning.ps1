#
# HomeDrive_Singapore.ps1
#
#==============================================================================================
# XAML Code - Imported from Visual Studio Express 2013 WPF Application
#==============================================================================================
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml]$XAML = @'
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="Search drive and add user to group" Height="800" Width="900" WindowStartupLocation="CenterScreen" ResizeMode="CanMinimize">
    <Grid Margin="0,0,-0.2,0.2">
   
    <Border>
        <Canvas Background="{DynamicResource {x:Static SystemColors.HighlightBrushKey}}">

        <TextBox Name="txtFolderPath" HorizontalAlignment="Left" Height="23" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Width="600" Canvas.Left="150" Canvas.Top="28"/> 
           
          
           
            
            <Label Content="Folder Path" Canvas.Left="17" Canvas.Top="25"/>
     

              <CheckBox Name="CheckBox1" Foreground="Black" Canvas.Left="20" Canvas.Top="100" Content="Read Only Group"   FontSize="11"  > </CheckBox>  
              <CheckBox Name="CheckBox2" Foreground="Black" Canvas.Left="20" Canvas.Top="125" Content="Write Only Group"  FontSize="11" > </CheckBox>

              <TextBlock Name="textBlockRead" HorizontalAlignment="Left" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Height="20" Width="700" Canvas.Left="150" Canvas.Top="100" Background="{DynamicResource {x:Static SystemColors.ControlLightLightBrushKey}}"/>
              <TextBlock Name="textBlockWrite" HorizontalAlignment="Left" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Height="20" Width="700" Canvas.Left="150" Canvas.Top="125" Background="{DynamicResource {x:Static SystemColors.ControlLightLightBrushKey}}"/>
            
          

             <TextBlock Name="textBlock" HorizontalAlignment="Left" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Height="20" Width="700" Canvas.Left="150" Canvas.Top="513" Background="{DynamicResource {x:Static SystemColors.ControlLightLightBrushKey}}"/>
             <Label Content="Status" Canvas.Left="17" Canvas.Top="513"/>


            
        </Canvas>
    </Border>

      <Button Name="btnSearch" Content="Search" HorizontalAlignment="Right" Margin="0,28,45,0" VerticalAlignment="Top" Width="80" Height="23" BorderThickness="0"/>


     <Button Name="btnSubmit" Content="Submit" HorizontalAlignment="Left" Margin="0,600,0,0" VerticalAlignment="Top" Width="900" Height="34" BorderThickness="0"/>
       <Button Name="btnReset" Content="Reset" HorizontalAlignment="Left" Margin="0,650,0,0" VerticalAlignment="Top" Width="900" Height="34" BorderThickness="0"/>
        <Button Name="btnExit" Content="Exit" HorizontalAlignment="Left" Margin="0,700,0,0" VerticalAlignment="Top" Width="900" Height="34" BorderThickness="0"/>
      
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
# Add events to Form Objects
#===========================================================================


$btnSubmit.Add_Click(


{



if ( ($txtFolderPath.text.Length) -eq 0 )

{


[System.Windows.MessageBox]::Show("Folder Path is empty" ,"Error" )



}
else 

{







}




})

 $btnReset.Add_Click({





$txtUserName.text = ""

$txtHomeDrivePath.text = ""

$txtboxOutput.text = ""

$textBlock.text = ""

$textBlock.Background = '#FFFFFF'

clear-host

})



$btnExit.Add_Click({$form.Close()})


#===========================================================================
# Run PowerShell
#===========================================================================






#===========================================================================
# Shows the form
#===========================================================================
$Form.ShowDialog() | out-null