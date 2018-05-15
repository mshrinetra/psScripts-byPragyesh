[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml]$XAML  = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="CWPS Integration Tool(CIT)- AD -HomePage" Height="722" Width="534" WindowStartupLocation="CenterScreen" ResizeMode="CanMinimize" Background="white">
    <Grid Width="523" Height="663">
        <Button Content="?" Height="23" HorizontalAlignment="right" Margin="0,5,20,0" Name="credit" VerticalAlignment="Top" Width="39" FontWeight="Bold" FontSize="14" />
        <Rectangle Height="42" HorizontalAlignment="Left" Margin="142,24,0,0" Name="Rectangle1" Stroke="Black" VerticalAlignment="Top" Width="255" Fill="Black" />
        <Label Content="CIT- AD -HomePage" Height="42" HorizontalAlignment="Right" Margin="0,26,131,0" Name="Label1" VerticalAlignment="Top" Width="232" FontWeight="Bold" FontSize="20" Foreground="White" FontStyle="Normal" FlowDirection="LeftToRight" FontStretch="Normal" FontFamily="Constantia" />
        <Button Content="Local Admin Rights" Height="36" HorizontalAlignment="Left" Margin="12,100,0,0" Name="btn_localadminrights" VerticalAlignment="Top" Width="491" FontSize="16" FontWeight="Bold" TabIndex="1" />
        <Button Content="Admin Account" FontSize="16" Height="36" HorizontalAlignment="Left" Margin="12,150,0,0" Name="btn_adminaccount" VerticalAlignment="Top" Width="491" FontWeight="Bold" TabIndex="2" />
        <Button Content="Service Account" FontSize="16" FontWeight="Bold" Height="36" HorizontalAlignment="Left" Margin="12,200,0,0" Name="btn_serviceaccount" VerticalAlignment="Top" Width="491" TabIndex="3" />
        <Button Content="Shared Account" FontSize="16" FontWeight="Bold" Height="36" HorizontalAlignment="Left" Margin="12,250,0,0" Name="btn_sharedaccount" VerticalAlignment="Top" Width="491" TabIndex="4" />
        <Button Content="Wipro Admin Account" FontSize="16" FontWeight="Bold" Height="36" HorizontalAlignment="Left" Margin="12,300,0,0" Name="btn_wipro_admin" VerticalAlignment="Top" Width="491" TabIndex="5" />
        <Button Content="Wipro Admin Account (Dispatch)" FontSize="16" FontWeight="Bold" Height="36" HorizontalAlignment="Left" Margin="12,350,0,0" Name="btn_wipro_admin_dispatch" VerticalAlignment="Top" Width="491" TabIndex="6" />
        <Button Content="AD Report" FontSize="16" FontWeight="Bold" Height="36" HorizontalAlignment="Left" Margin="12,399,0,0" Name="btn_ad_report" VerticalAlignment="Top" Width="491" TabIndex="7" />
        <Button Content="Off Boarding-Ad Admin ID" FontSize="16" FontWeight="Bold" Height="36" HorizontalAlignment="Left" Margin="12,452,0,0" Name="btn_Offboarding_AdAdminID" TabIndex="7" VerticalAlignment="Top" Width="491" />
        <Button Content="User Addition to AD Security Group" FontSize="16" FontWeight="Bold" Height="36" HorizontalAlignment="Left" Margin="12,506,0,0" Name="btn_groupmemberadder" TabIndex="7" VerticalAlignment="Top" Width="491" />
        <Button Content="User Removal from AD Security Group" FontSize="16" FontWeight="Bold" Height="36" HorizontalAlignment="Left" Margin="12,561,0,0" Name="btn_groupmemberremover" TabIndex="7" VerticalAlignment="Top" Width="491" />
        <Button Content="Bulk Process" FontSize="16" FontWeight="Bold" Height="36" HorizontalAlignment="Left" Margin="12,614,0,0" Name="btn_bulkprocess" TabIndex="7" VerticalAlignment="Top" Width="491" />
    </Grid>
</Window>

"@
$reader=(New-Object System.Xml.XmlNodeReader $xaml)
$Window=[Windows.Markup.XamlReader]::Load($reader)

#Connect to Controls 
$xaml.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]")  | `
ForEach {
  New-Variable  -Name $_.Name -Value $Window.FindName($_.Name) -Force
}

$credit.Add_Click({ [System.Windows.MessageBox]::Show("Developed by: WIPRO-ABB CWPS Team" ,"Credit" ) })

# --------------------------- Powershell Script ----------------------------

$btn_localadminrights.Add_Click({
    Start-Process '\\XE-S-JUMP005.xe.abb.com\E$\CIT_Automation$\EXE\Specific_EXE\LocalAdminRights.exe' -Verb runAs
})

$btn_adminaccount.Add_Click({
    Start-Process '\\XE-S-JUMP005.xe.abb.com\E$\CIT_Automation$\EXE\Specific_EXE\AdminAccount.exe' -Verb runAs
})

$btn_serviceaccount.Add_Click({
    Start-Process '\\XE-S-JUMP005.xe.abb.com\E$\CIT_Automation$\EXE\Specific_EXE\ServiceAccount.exe' -Verb runAs
})

$btn_wipro_admin.Add_Click({
    Start-Process '\\XE-S-JUMP005.xe.abb.com\E$\CIT_Automation$\EXE\Specific_EXE\WiproAdmin.exe' -Verb runAs
})

$btn_sharedaccount.Add_Click({
    Start-Process '\\XE-S-JUMP005.xe.abb.com\E$\CIT_Automation$\EXE\Specific_EXE\SharedAccount.exe' -Verb runAs
})

$btn_wipro_admin_dispatch.Add_Click({
    Start-Process '\\XE-S-JUMP005.xe.abb.com\E$\CIT_Automation$\EXE\Specific_EXE\WiproAdminDispatch.exe' -Verb runAs
})

$btn_ad_report.Add_Click({
     Start-Process '\\XE-S-JUMP005.xe.abb.com\E$\CIT_Automation$\EXE\Specific_EXE\Report.exe' -Verb runAs
})

$btn_Offboarding_AdAdminID.Add_Click({
     Start-Process '\\XE-S-JUMP005.xe.abb.com\E$\CIT_Automation$\EXE\Specific_EXE\Offboarding_AdAdminID.exe' -Verb runAs
})

$btn_groupmemberadder.Add_Click({
     Start-Process '\\XE-S-JUMP005.xe.abb.com\E$\CIT_Automation$\EXE\Specific_EXE\Add user to AD+security+group.exe' -Verb runAs
})

$btn_groupmemberremover.Add_Click({
     Start-Process '\\XE-S-JUMP005.xe.abb.com\E$\CIT_Automation$\EXE\Specific_EXE\GroupMemberRemover.exe' -Verb runAs
})

$btn_bulkprocess.Add_Click({
     Start-Process '\\XE-S-JUMP005.xe.abb.com\E$\CIT_Automation$\EXE\Specific_EXE\Bulkprocess.exe' -Verb runAs
})



# --------------------------- Powershell Script End ------------------------
$Null = $Window.ShowDialog()