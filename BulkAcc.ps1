#Version : 1.0
#Purpose : Bulk Account creation
#Creator : Saurabh Bhargava\Vinoth Kumar Nagarajan

$LogFileN = "$Modulepath\LOG-Files\AD-Bulk-Logs.txt"
$InputLocation = "$Modulepath\INPUT folder"


Import-Csv "$InputLocation\Createusers.csv" |
Foreach {

if ($_.Initials -ne "Null")
 {
	    $domnam = Get-ADDomain
	    $servnam = $domnam.name
  $UPN = $_.FirstName+'_'+$_.Initials+'_'+$_.LastName+"@$servnam.com"
  $AliasSMTP = $_.FirstName+'_'+$_.Initials+'_'+$_.LastName
  $DisplayName = $_.FirstName+' '+$_.Initials+' '+$_.LastName
 }
if ($_.Initials -eq "Null")
 {
$UPN = $_.FirstName+'_'+$_.LastName+"@$servnam.com"
$AliasSMTP = $_.FirstName+'_'+$_.LastName
$DisplayName = $_.FirstName+' '+$_.LastName
 }


$dis = Get-ADUser -Identity $_.modelid
$Oumirror = $dis.distinguishedName -creplace "^[^,]*,",""

$UId = $_.UserId
try
 {
 $dom = Get-ADDomain
 $serv = $dom.InfrastructureMaster
 New-ADUser -SamAccountName $_.UserId -name $DisplayName -GivenName $_.FirstName -DisplayName $DisplayName -UserPrincipalName $UPN -Surname $_.LastName -Path $Oumirror
 Set-ADAccountPassword -Server $serv -identity $_.UserId -NewPassword (ConvertTo-SecureString -AsPlainText $_.Password -force)
 Set-AdUser -Server $serv -Identity $_.UserId -ChangePasswordAtLogon $true
 Enable-ADAccount -Identity $_.UserId

Write-host " 
User logon name is "
$UN = get-aduser -identity $_.UserId | select name
$UN
write-Output "User created with details $_.UserId" | Out-File $LogFileN -Append
write-host "User's UserPrincipalName is $UPN" -ForegroundColor green
}
catch
{
 # Write-host "$_." -ForegroundColor Red
 $UN = get-aduser -identity $UId | select name
 if($UN) 
 {
  Write-host "User $UN was not created as this account already exists in AD" -ForegroundColor Red
  write-Output "User $UN was not created as this account already exists in AD" | Out-File $LogFileN -Append
 }
 if(!$UN) 
 {
 Write-host "User $_.UserId was not created please try again." -ForegroundColor Red
 write-Output "User $_.UserId was not created please try again." | Out-File $LogFileN -Append
 }
}


if ($_.Initials -ne "Null")
{
Set-ADUser -Identity $_.UserId -Initials $_.Initials -EmailAddress $UPN
}
if ($_.Initials -eq "Null")
{
Set-ADUser -Identity $_.UserId -EmailAddress $UPN
}
if ($_.Date -ne "Null")
{
Set-ADUser -Identity $_.UserId -AccountExpirationDate $_.date
}
if ($_.Date -eq "Null")
{
write-host "Account will never Expiry" -ForegroundColor Cyan
}
if ($_.Office -ne "Null")
{
Set-ADUser -Identity $_.UserId -Office $_.Office
}
if ($_.Office -eq "Null")
{
write-host "Office not set" -ForegroundColor Cyan
}
if ($_.Description -ne "Null")
{
Set-ADUser -Identity $_.UserId -Description $_.Description
}
if ($_.Description -eq "Null")
{
write-host "Description not set" -ForegroundColor Cyan
}
if ($_.Logonscript -ne "Null")
{
Set-ADUser -Identity $_.UserId -ScriptPath $_.Logonscript
}
if ($_.Logonscript -eq "Null")
{
write-host "Logonscript not set" -ForegroundColor Cyan
}
if ($_.ProfilePath -ne "Null")
{
Set-ADUser -Identity $_.UserId -ProfilePath $_.ProfilePath
}
if ($_.ProfilePath -eq "Null")
{
write-host "ProfilePath not set" -ForegroundColor Cyan
}
if ($_.homeDrive -ne "Null")
{
Set-ADUser -Identity $_.UserId -homeDrive $_.homeDrive
}
if ($_.homeDrive -eq "Null")
{
write-host "HomeDrive not set" -ForegroundColor Cyan
}
if ($_.HomeDirectory -ne "Null")
{
Set-ADUser -Identity $_.UserId -HomeDirectory $_.HomeDirectory
}
if ($_.HomeDirectory -eq "Null")
{
write-host "HomeDirectory not set" -ForegroundColor Cyan
}

#TO set ProxyAddresses:
$ProxyA = Get-ADUser -Identity $_.UserId -Properties ProxyAddresses
$ProxyA.ProxyAddresses = "SMTP:$AliasSMTP@mssp1.com","smtp:$AliasSMTP@wipro.com"
Set-ADUser -Instance $ProxyA

#TO set mailNickname:
$mailN = Get-ADUser -Identity $_.UserId -Properties mailNickname
$mailN.mailNickname = "$AliasSMTP"
Set-ADUser -Instance $mailN

#To set targetAddress:
$TarAdd = Get-ADUser -Identity $_.UserId -Properties targetAddress
$TarAdd.targetAddress = "$UPN"
Set-ADUser -Instance $TarAdd

#To set msExchHideFromAddressLists (True/false)
$HFAL = $_.msExchHide
$msExchHFAL = Get-ADUser -Identity $_.UserId -Properties msExchHideFromAddressLists
$msExchHFAL.msExchHideFromAddressLists = "$HFAL"
Set-ADUser -Instance $msExchHFAL


}