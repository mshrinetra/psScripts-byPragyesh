#
# CIT_Login_V1.1.ps1

#============================================================================================
# XAML Code - Imported from Visual Studio Express 2013 WPF Application
#==============================================================================================
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml]$XAML = @'
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="CWPS Integration Tool(CIT) Automation Tool - AD Login" FontWeight="Bold" Height="800" Width="900" WindowStartupLocation="CenterScreen" ResizeMode="CanMinimize">
    <Window.Background>
        <LinearGradientBrush EndPoint="1,0.5" StartPoint="0,0.5">
            <GradientStop Color="Black" Offset="0" />
            <GradientStop Color="#FF0CE1AB" Offset="1" />
        </LinearGradientBrush>
    </Window.Background>
    <Grid Margin="0,0,-0.2,0.2">

        <Border>

            <Canvas>




                <TextBox Name="txtUserName" HorizontalAlignment="Left" Height="23" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Width="200" Canvas.Left="250" Canvas.Top="200"/>

                <Label Content="UserName" Canvas.Left="150" Canvas.Top="200"/>
                <PasswordBox Name="txtpwBox"  Height="23" Width="200" MaxLength="20" Margin="250,250,0,0" />
                <Label Content="Password" Canvas.Left="150" Canvas.Top="250"/>
                <Canvas.Background>
                    <LinearGradientBrush EndPoint="1,0.5" StartPoint="0,0.5">
                        <GradientStop Color="Black" Offset="0" />
                        <GradientStop Color="#9B00FFEB" Offset="0.171" />
                    </LinearGradientBrush>
                </Canvas.Background>
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
        [string]$Path='C:\Logs\CIT_AD_Login.log', 

        [Parameter(Mandatory=$false)] 
        [Alias('LogPath2')] 
        [string]$Path2='\\10.16.99.13\D$\CWPS_Automation\Logs\ActiveDirectory\CIT_AD_Login.log', 
         
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

$txtUserName.Text = ""


$txtpwBox.Password = ""




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


[System.Windows.MessageBox]::Show("UserName or Password is empty" ,"Error" )



}

Else

{

try

{

 Get-ADuser $txtUserName.Text -Server "de-s-abb0033.abb.com:3268" -ErrorAction Stop

        If ((new-object directoryservices.directoryentry "",$txtUserName.Text,$txtpwBox.Password).psbase.name -ne $null) 


        {

        $group = "U-XW-CWPS-Specific-CIT Automation Tool"
        $members = Get-ADGroupMember -Identity $group -Recursive | Select -ExpandProperty SAMAccountName 
        #$user = $txtUserName.Text.Split("\")

        $TempUserName = $txtUserName.Text

        write-host $TempUserName
      
        Get-ADuser $TempUserName -Server "de-s-abb0033.abb.com:3268" -ErrorAction Stop



                        If ($members -contains $TempUserName)



                        {

                        Start-Process '\\XE-S-JUMP005.xe.abb.com\E$\CIT_Automation$\EXE\Specific_EXE\CIT_AD_HomePage.exe' -Verb runAs
                        Break
        

                        }

      
      }

      

                        Else

                        {

                        [System.Windows.MessageBox]::Show("Password Wrong or Access Denied" ,"Error" )

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









})

$btnExit.Add_Click({$form.Close()})


#===========================================================================
# Run PowerShell
#===========================================================================




#===========================================================================
# Shows the form
#===========================================================================
$Form.ShowDialog() | out-null

$CloseButtonLog = "Exited by:       " + $env:username

Write-Log $CloseButtonLog