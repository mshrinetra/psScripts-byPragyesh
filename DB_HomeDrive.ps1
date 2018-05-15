Function CITDatabase ([string]$TaskNumber,[string]$ProcessedBy,[string]$ActionPerformed,[string]$Details   )

{

[string] $Server= "XE-S-JUMP005\SQLEXPRESS,1433"

[string] $Database = "CITDatabase"








 

$Command = New-Object System.Data.SQLClient.SQLCommand

$Command.Connection = $Connection

 

$SqlConnection = New-Object System.Data.SqlClient.SqlConnection

$SqlConnection.ConnectionString = "Server = $Server; Database = $Database; Integrated Security = True;"

try{

 $SqlConnection.Open()


 
[string] $SqlQuery= $("INSERT INTO OffBoarding_HomeDrive VALUES ('$TaskNumber',DEFAUlT,'$ProcessedBy','$ActionPerformed','$Details');")

Write-Host one

$SqlCmd = New-Object System.Data.SqlClient.SqlCommand

$SqlCmd.CommandText = $SqlQuery

Write-Host two

$SqlCmd.Connection = $SqlConnection

Write-Host three
$SqlCmd.ExecuteNonQuery()





}

 Catch [Exception]

{


[System.Windows.MessageBox]::Show($_.Exception.Message  ,"Error" )




}

Finally

{
 $SqlConnection.Close()

 }

 }


 $TaskNumber = "TASK366dfasdf"



 $textBlock = "-Home folder does not exist. All -" + $ActionPerformed  + " users are using OneDrive."



 CITDatabase -TaskNumber $TaskNumber -ProcessedBy $env:username -ActionPerformed "Submit" -Details $textBlock