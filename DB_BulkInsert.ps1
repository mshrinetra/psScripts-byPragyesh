try{

Import-Module "sqlps" -DisableNameChecking

Set-location SQLSERVER:\SQL\XE-S-JUMP005\SQLEXPRESS



#################### Folder Access Provider Audit #######################
Invoke-Sqlcmd -Database "OneDriveApproach" -Query "BULK INSERT dbo.Test_Only_Permissions
FROM 'C:\Users\xw-admin-pk8\Desktop\XWPRKUM\Bart\Test_only_permisssions.csv'
WITH
(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',  --CSV field delimiter
	ROWTERMINATOR = '\n',   --Use to shift the control to next row
	TABLOCK,
	CODEPAGE = 'ACP'
);"


}


 

 Catch [Exception]

{


[System.Windows.MessageBox]::Show($_.Exception.Message  ,"Error" )




}