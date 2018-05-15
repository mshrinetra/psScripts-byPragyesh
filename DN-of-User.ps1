#Version : 1.0
#Lastmodifieddate : 6\11\15
#Purpose : Distinguished Name of User
#Creator : Saurabh Bhargava\Vinoth Kumar Nagarajan


#Give Correct SamAccountName
#If SamAccountName is wrong "Error is not throwed and Loop Breaks"

Import-Module Activedirectory

$ErrorActionPreference = "SilentlyContinue"

$User = Read-Host -Prompt 'Input the SamAccountName'
if (Get-ADuser $User)
{
     InfoMessage ( "User $_ found in AD")
     $DCN = Get-ADUser $User | select DistinguishedName
     Write-output "Distinguished Name of $User user is $DCN" | Out-GridView -Title "DISTINGUISHED NAME"
}
