try{

Import-Module "sqlps" -DisableNameChecking

Set-location SQLSERVER:\SQL\XE-S-JUMP005\SQLEXPRESS

#################### Processed by + time stamp #######################

#Invoke-Sqlcmd -Database "CITDatabase" -Query "SELECT COUNT(ProcessedBy) As No_of_Tasks, ProcessedBy FROM FolderAccessProvider where (TIMESTAMP >= '2017-12-13') AND (TIMESTAMP <= '2017-12-13') group by ProcessedBy;"

#################### Unlisted folder path #######################

#Invoke-Sqlcmd -Database "CITDatabase" -Query "SELECT  TaskNumber,FolderPath, AccessType, Groupname, Listing FROM FolderAccessProvider WHERE (Listing = 'unlisted folder path') AND (TimeStamp >= '2017-12-06');"

#################### Count #######################

#Invoke-Sqlcmd -Database "CITDatabase" -Query "SELECT COUNT(TaskNumber) FROM FolderAccessProvider"

#################### CONFIG #######################

#Invoke-Sqlcmd -Database "CITDatabase" -Query "SELECT ProcessedBy FROM FolderAccessProvider group by ProcessedBy;"


#################### Folder Access Provider Closure Report #######################

#Invoke-Sqlcmd -Database "CITDatabase" -Query "SELECT  TaskNumber, TimeStamp, ProcessedBy, ActionPerformed, FolderPath, AccessType, Groupname, Listing, UserName FROM FolderAccessProvider where (TIMESTAMP >= '2017-12-04');"


#################### Folder Access Provider Audit #######################


Invoke-Sqlcmd -Database "CITDatabase" -Query "SELECT  TaskNumber, TimeStamp, ProcessedBy, ActionPerformed, FolderPath, AccessType, Groupname, Listing, UserName FROM FolderAccessProvider where (TimeStamp >= '2018-03-26') AND (AccessType = 'Read only') AND (Groupname Like '%rw%');"

Invoke-Sqlcmd -Database "CITDatabase" -Query "SELECT  TaskNumber, TimeStamp, ProcessedBy, ActionPerformed, FolderPath, AccessType, Groupname, Listing, UserName FROM FolderAccessProvider where (TimeStamp >= '2018-03-26') AND (AccessType = 'Read only') AND (Groupname Like '%-C-%');"

Invoke-Sqlcmd -Database "CITDatabase" -Query "SELECT  TaskNumber, TimeStamp, ProcessedBy, ActionPerformed, FolderPath, AccessType, Groupname, Listing, UserName FROM FolderAccessProvider where (TimeStamp >= '2018-03-26') AND (AccessType = 'Read only') AND (Groupname Like '%Editor%');"

Invoke-Sqlcmd -Database "CITDatabase" -Query "SELECT  TaskNumber, TimeStamp, ProcessedBy, ActionPerformed, FolderPath, AccessType, Groupname, Listing, UserName FROM FolderAccessProvider where (TimeStamp >= '2018-03-26') AND (AccessType = 'Read only') AND (Groupname Like '%)C%');"

Invoke-Sqlcmd -Database "CITDatabase" -Query "SELECT  TaskNumber, TimeStamp, ProcessedBy, ActionPerformed, FolderPath, AccessType, Groupname, Listing, UserName FROM FolderAccessProvider where (TimeStamp >= '2018-03-26') AND (AccessType = 'Read only') AND (Groupname Like '%-Write');"

Invoke-Sqlcmd -Database "CITDatabase" -Query "SELECT  TaskNumber, TimeStamp, ProcessedBy, ActionPerformed, FolderPath, AccessType, Groupname, Listing, UserName FROM FolderAccessProvider where (TimeStamp >= '2018-03-26') AND (AccessType = 'Read only') AND (Groupname Like '%Master%');"

Invoke-Sqlcmd -Database "CITDatabase" -Query "SELECT  TaskNumber, TimeStamp, ProcessedBy, ActionPerformed, FolderPath, AccessType, Groupname, Listing, UserName FROM FolderAccessProvider where (TimeStamp >= '2018-03-26') AND (AccessType = 'Read only') AND (Groupname Like '%Data Reader%');"

#Invoke-Sqlcmd -Database "CITDatabase" -Query "SELECT  TaskNumber, TimeStamp, ProcessedBy, ActionPerformed, FolderPath, AccessType, Groupname, Listing, UserName FROM FolderAccessProvider where (TimeStamp >= '2018-03-26') AND (AccessType = 'Read only') AND (Groupname Like '%Data%');"


#################### Folder Access Provider Audit #######################

Invoke-Sqlcmd -Database "CITDatabase" -Query "SELECT  TaskNumber, TimeStamp, ProcessedBy, ActionPerformed, FolderPath, AccessType, Groupname, Listing, UserName FROM FolderAccessProvider where (TimeStamp >= '2018-03-26') AND (AccessType = 'Read+Modify') AND (Groupname Like '%R') ;"

Invoke-Sqlcmd -Database "CITDatabase" -Query "SELECT  TaskNumber, TimeStamp, ProcessedBy, ActionPerformed, FolderPath, AccessType, Groupname, Listing, UserName FROM FolderAccessProvider where (TimeStamp >= '2018-03-26') AND (AccessType = 'Read+Modify') AND (Groupname Like '%-R-%') ;"

Invoke-Sqlcmd -Database "CITDatabase" -Query "SELECT  TaskNumber, TimeStamp, ProcessedBy, ActionPerformed, FolderPath, AccessType, Groupname, Listing, UserName FROM FolderAccessProvider where (TimeStamp >= '2018-03-26') AND (AccessType = 'Read+Modify') AND (Groupname Like '%Reader%');"

Invoke-Sqlcmd -Database "CITDatabase" -Query "SELECT  TaskNumber, TimeStamp, ProcessedBy, ActionPerformed, FolderPath, AccessType, Groupname, Listing, UserName FROM FolderAccessProvider where (TimeStamp >= '2018-03-26') AND (AccessType = 'Read+Modify') AND (Groupname Like '%)R%');"

Invoke-Sqlcmd -Database "CITDatabase" -Query "SELECT  TaskNumber, TimeStamp, ProcessedBy, ActionPerformed, FolderPath, AccessType, Groupname, Listing, UserName FROM FolderAccessProvider where (TimeStamp >= '2018-03-26') AND (AccessType = 'Read+Modify') AND (Groupname Like '%-Read%');"


Invoke-Sqlcmd -Database "CITDatabase" -Query "SELECT  TaskNumber, TimeStamp, ProcessedBy, ActionPerformed, FolderPath, AccessType, Groupname, Listing, UserName FROM FolderAccessProvider where (TimeStamp >= '2018-03-26') AND (AccessType = 'Read+Modify') AND (Groupname Like '%Master%');"

Invoke-Sqlcmd -Database "CITDatabase" -Query "SELECT  TaskNumber, TimeStamp, ProcessedBy, ActionPerformed, FolderPath, AccessType, Groupname, Listing, UserName FROM FolderAccessProvider where (TimeStamp >= '2018-03-26') AND (AccessType = 'Read+Modify') AND (Groupname Like '%Data Reader%');"

#Invoke-Sqlcmd -Database "CITDatabase" -Query "SELECT  TaskNumber, TimeStamp, ProcessedBy, ActionPerformed, FolderPath, AccessType, Groupname, Listing, UserName FROM FolderAccessProvider where (TimeStamp >= '2018-03-26') AND (AccessType = 'Read+Modify') AND (Groupname Like '%Data%');"

#Invoke-Sqlcmd -Database "CITDatabase" -Query "SELECT COUNT(ProcessedBy) As No_of_Tasks, ProcessedBy FROM FolderAccessProvider where (TIMESTAMP >= '2018-01-05') group by ProcessedBy;"
}


 

 Catch [Exception]

{


[System.Windows.MessageBox]::Show($_.Exception.Message  ,"Error" )




}