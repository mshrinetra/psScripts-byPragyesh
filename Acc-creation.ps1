#Version : 1.0
#Purpose : Create Single user
#Creator : Saurabh Bhargava\Vinoth Kumar Nagarajan

$LogFileI = "$Modulepath\LOG-Files\AD-Individual-Logs.txt"

$FirstName = Read-host "Enter the Users First Name"
$LastName = Read-host "Enter the Users Last Name"
$UserId = Read-host "Enter the Userslogon name"
$Initials = Read-host "Enter the Initials, else give Null"
$modelid = Read-host "Enter a mirror account that exists in AD`
(This is needed for selecting OU)"
$Password = Read-host "Enter the password for user"

	    $domnam = Get-ADDomain
	    $servnam = $domnam.name

if ($Initials -ne "Null")
 {
  $UPN = $FirstName+'_'+$Initials+'_'+$LastName+"@$servnam.com"
  $AliasSMTP = $FirstName+'_'+$Initials+'_'+$LastName
  $DisplayName = $FirstName+' '+$Initials+'. '+$LastName
 }
if ($Initials -eq "Null")
 {
$UPN = $FirstName+'_'+$LastName+"@$servnam.com"
$AliasSMTP = $FirstName+'_'+$LastName
$DisplayName = $FirstName+' '+$LastName
 }
$dis = Get-ADUser -Identity $modelid
$Oumirror = $dis.distinguishedName -creplace "^[^,]*,",""


try
{
 $dom = Get-ADDomain
 $serv = $dom.InfrastructureMaster

New-ADUser -SamAccountName $UserId -name $UserId -GivenName $FirstName -DisplayName $DisplayName -UserPrincipalName $UPN -Surname $LastName -Path $Oumirror
Set-ADAccountPassword -Server $serv -identity $UserId -NewPassword (ConvertTo-SecureString -AsPlainText $Password -force)
Set-AdUser -Server $serv -Identity $UserId -ChangePasswordAtLogon $true
Enable-ADAccount -Identity $UserId
write-host " User $UserID is created Successfully " -foregroundcolor green
Write-output "User $UserID is created Successfully" | Out-File $LogFileI -Append
}
catch
{
   Write-host "Provided user $UserID was not created or it is already present in AD." -foregroundcolor yellow
   Write-output "Provided user $UserID was not created or it is already present in AD." | Out-File $LogFileI -Append
}


