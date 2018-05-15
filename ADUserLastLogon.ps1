#Version : 1.0
#Lastmodifieddate : 6\11\15
#Purpose : AD user's Last Logon date
#Creator : Saurabh Bhargava\Vinoth Kumar Nagarajan


#Give Correct SamAccountName
#If SamAccountName is wrong "Error is not throwed and Loop Breaks"

Import-Module Activedirectory
$ErrorActionPreference = "SilentlyContinue"

$username=Read-Host -Prompt 'Input SamAccountName'
function Get-ADUserLastLogon([string]$userName)
{
  $dcs = Get-ADDomainController -Filter {Name -like "*"}
  $time = 0
  foreach($dc in $dcs)
  { 
    $hostname = $dc.HostName
    $user = Get-ADUser $userName | Get-ADObject -Properties lastLogon
    if($user.LastLogon -gt $time) 
    {
      $time = $user.LastLogon
    }
  }
  $dt = [DateTime]::FromFileTime($time)
  Write-output "Last logged on date for $username user is :$dt " | Out-GridView -Title "LAST LOGGED ON DATE"
}

Get-ADUserLastLogon -UserName $username
