
#Version : 1.0
#Purpose : LIST OF ACCOUNTS WITH PASSWORD NEVER EXPIRY
#Creator : Saurabh Bhargava\Vinoth Kumar Nagarajan
$Date = Get-Date -Format dd/MM/yy
$Time = Get-Date -Format HH:mm:ss


$LogFileName = "$Modulepath\LOG-Files\PwdNE.csv"

Write-Output " " | Out-File $LogFileName -Append
write-Output "LOGS" | Out-File $LogFileName -Append
Write-Output "Date is : $Date $Time" | Out-File "$LogFileName" -Append

Search-ADAccount -PasswordNeverExpires -UsersOnly | select SamAccountName,LastLogonDate,Name | Out-GridView -Title "LIST OF ACCOUNTS WITH PASSWORD NEVER EXPIRES" -PassThru | out-file "$LogFileName" -Append