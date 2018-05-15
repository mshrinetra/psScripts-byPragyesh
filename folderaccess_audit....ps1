try{

Import-Module "sqlps" -DisableNameChecking

Set-location SQLSERVER:\SQL\XE-S-JUMP005\SQLEXPRESS



#################### Folder Access Provider Audit #######################

Invoke-Sqlcmd -Database "CITDatabase" -Query "SELECT  TaskNumber, TimeStamp, ProcessedBy, ActionPerformed, FolderPath, AccessType, Groupname, Listing, UserName FROM FolderAccessProvider 
where (TimeStamp >= '2017-11-11') AND (AccessType = 'Read only') 
AND (Groupname Like '%rw%');" | 

where { 

foreach($x in $_)

{

Write-Host $x

$tempname = $x.UserName.Split("."); write-host $tempname[0]; $Group = Get-ADGroup -id $x.Groupname -Server "de-s-abb0033.abb.com:3268" -ErrorAction ignore; 

$GroupName = "LDAP://"+$Group; $Group = [ADSI]$GroupName; 
    $tempfinalname = $tempname[0]

if($Group.member -like "*$tempfinalname*")
{
Write-Host $tempfinalname
}

}

}

#################### Folder Access Provider Audit #######################

#Invoke-Sqlcmd -Database "CITDatabase" -Query "SELECT  TaskNumber, TimeStamp, ProcessedBy, ActionPerformed, FolderPath, AccessType, Groupname, Listing, UserName FROM FolderAccessProvider where (TimeStamp >= '2017-12-8') AND (AccessType = 'Read+Modify') AND (Groupname Like '%R') ;"

}

 Catch [Exception]

{


[System.Windows.MessageBox]::Show($_.Exception.Message  ,"Error" )




}