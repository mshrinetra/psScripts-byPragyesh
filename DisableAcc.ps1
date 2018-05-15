
#Version : 1.0
#Purpose : LIST OF DISABLED ACCOUNTS
#Creator :  Saurabh Bhargava\Vinoth Kumar Nagarajan
$Date = Get-Date -Format dd/MM/yy
$Time = Get-Date -Format HH:mm:ss
$LogFileName = "$Modulepath\LOG-Files\Disableaccounts.csv"
write-Output "LOGS" | Out-File $LogFileName -Append
Write-Output " " | Out-File $LogFileName -Append
Write-Output "Date is : $Date $Time" | Out-File $LogFileName -Append

Search-ADAccount -AccountDisabled -UsersOnly | select SamAccountName,AccountExpirationdate | Out-GridView -Title "LIST OF DISABLED ACCOUNTS" -PassThru | out-file "$LogFileName" -Append


