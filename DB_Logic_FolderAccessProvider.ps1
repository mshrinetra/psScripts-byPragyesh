



Function CITDatabase ([string]$TaskNumber,[string]$ProcessedBy,[string]$ActionPerformed,[string]$FolderPath,[string]$AccessType,[string]$Groupname,[string]$Listing,[string]$UserName )

{

[string] $Server= "10.16.99.15,1433"

[string] $Database = "CITDatabase"


$uid = "Europe\XW-ADMIN-DK6"
 
$pwd = "Jaishriram@11111"

$Command = New-Object System.Data.SQLClient.SQLCommand

$Command.Connection = $Connection



$SqlConnection = New-Object System.Data.SqlClient.SqlConnection

$SqlConnection.ConnectionString = "Server = $Server; Database = $Database; Integrated Security = True; User ID = $uid; Password = $pwd;"

try{

 $SqlConnection.Open()


 
[string] $SqlQuery= $("INSERT INTO FolderAccessProvider VALUES ('$TaskNumber',DEFAUlT,'$ProcessedBy','$ActionPerformed','$FolderPath','$AccessType','$Groupname','$Listing','$UserName');")

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





 [string]$TaskNumber = "Test5"
 
 [string]$ProcessedBy= "Test"
 
 
 [string]$ActionPerformed= "Test"
 
 
 [string]$FolderPath= "Test"
 
 
 [string]$AccessType= "Test"
 
 
 [string]$Groupname= "Test"
 
 [string]$Listing= "Test"
 
 [string]$UserName = "Test"
 

 CITDatabase -TaskNumber $TaskNumber -ProcessedBy $env:username -ActionPerformed "Submit" -FolderPath $FolderPath -AccessType $AccessType -Groupname $Groupname -Listing $Listing -UserName $UserName