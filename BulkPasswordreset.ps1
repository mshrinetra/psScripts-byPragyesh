#Version : 1.0
#Purpose : For bulk password reset in Active Directory
#Creator : Saurabh Bhargava\Vinoth Kumar Nagarajan
$LogFileN = "$Modulepath\LOG-Files\AD-Bulk-Logs.txt"
$InputLocation = "$Modulepath\INPUT folder"

Import-Csv "$InputLocation\BulkPwdusers.csv" |
Foreach {
 $US = $_.user
 try { 
      	get-ADuser $_.user | select Name
	$Status = $_.ChangePasswordAtLogon
	$dom = Get-ADDomain
	$serv = $dom.InfrastructureMaster

	Set-ADAccountPassword -Server $serv -identity $_.user -NewPassword (ConvertTo-SecureString -AsPlainText $_.password -force)
	if ($Status -like "true")
	{
	Set-AdUser -Server $serv -Identity $_.user -ChangePasswordAtLogon $true
	}
	if ($Status -like "false")
	{
	Set-AdUser -Server $serv -Identity $_.user -ChangePasswordAtLogon $false
	}
	Write-host "Password set for $US user and ChangePasswordAtLogon is $Status" -ForegroundColor Green
	Write-Output "Password set for $US user and ChangePasswordAtLogon is $Status" | Out-File "$LogFileN" -append
      }
Catch {
       Write-host "User $US does not exists in AD." -ForegroundColor Red
       Write-Output "User $US does not exists in AD." | Out-File "$LogFileN" -append
      }
}

