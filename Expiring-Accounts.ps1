
#Version : 1.0
#Purpose : LIST OF EXPIRED ACCOUNTS
#Creator : Saurabh Bhargava\Vinoth Kumar Nagarajan
$Date = Get-Date -Format dd/MM/yy
$Time = Get-Date -Format HH:mm:ss
$LogFileName = "$Modulepath\LOG-Files\Expired-Accounts.csv"
write-Output "LOGS" | Out-File $LogFileName -Append
Write-Output " " | Out-File $LogFileName -Append
Write-Output "Date is : $Date $Time" | Out-File $LogFileName -Append

Import-Module Activedirectory
$ErrorActionPreference = "SilentlyContinue"
Search-ADAccount -AccountExpiring | select SamAccountName,AccountExpirationdate | Out-GridView -Title "LIST OF EXPIRED ACCOUNTS" -PassThru | out-file "$LogFileName" -Append
