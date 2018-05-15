#folder access Bangalore 3
#folder access Bangalore 1
#Version : 1.0
#Purpose : Add different Groups to different Users.
#Creator : Saurabh Bhargava\Vinoth Kumar Nagarajan
$LogFileN = "$Modulepath\LOG-Files\AD-Bulk-Logs.txt"
$InputLocation = "$Modulepath\INPUT folder"

Import-Csv "$InputLocation\multiusergrpadd.csv" |
Foreach {
$US = $_.user
try
{
     $GU = get-ADuser $_.user | select Name
     $U = $_.user
     Write-Host "User $GU found in AD" -ForegroundColor Yellow
     $GA = $_.group
	try 
	  {
		$G = $_.group
     		$GG = Get-ADGroup $_.group | select Name      
     		Write-Host "Group $GG found in AD" -ForegroundColor Yellow
     		Add-ADGroupMember $G $U
     		Write-Host "Group $G Added To User $U" -ForegroundColor Green
     		Write-output "Group $G Added To User $U" | Out-File $LogFileN -Append
	   }
	catch
	   {
		Write-Host "Error while adding the user $US to the group $GA as group was not found in AD." -ForegroundColor Red
		Write-output "Error while adding the user $US to the group $GA as group was not found in AD." | Out-File $LogFileN -Append
	   }
}
catch
{
Write-Host "Error while adding the user $US to the group as user was not found in AD." -ForegroundColor Red
Write-output "Error while adding the user $US to the group as user was not found in AD." | Out-File $LogFileN -Append
}
}
