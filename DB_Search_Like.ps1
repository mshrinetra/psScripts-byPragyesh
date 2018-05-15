


try{

Import-Module "sqlps" -DisableNameChecking

Set-location SQLSERVER:\SQL\XE-S-JUMP005\SQLEXPRESS

#Invoke-Sqlcmd -Database "CITDatabase" -Query "Create Table Student (  Name varchar(50),  DateOfAddmission datetime default CURRENT_TIMESTAMP);" -ErrorAction Stop

#Invoke-Sqlcmd -Database "CITDatabase" -Query "Create Table FolderAccessProvider(TaskNumber varchar(50) NOT NULL PRIMARY KEY,  TimeStamp datetime default CURRENT_TIMESTAMP, ProcessedBy varchar(50), ActionPerformed varchar(50), FolderPath varchar(MAX),AccessType varchar(50),Groupname varchar(MAX),Listing varchar(50), UserName varchar(MAX));"

#Invoke-Sqlcmd -Database "CITDatabase" -Query "INSERT INTO Student VALUES('Pragyesh', Default);"


#Invoke-Sqlcmd -Database "CITDatabase" -Query CREATE LOGIN CITUser WITH PASSWORD = 'Wipro@123'; 

#Invoke-Sqlcmd -Database "ESTONIADatabase" -Query "Select * from Groupmemberdetails;"


Invoke-Sqlcmd -Database "ESTONIADatabase" -Query "Select * from Groupmemberdetails where Groupmembers Like '%Contreras%';"

}

 Catch [Exception]

{


[System.Windows.MessageBox]::Show($_.Exception.Message  ,"Error" )




}