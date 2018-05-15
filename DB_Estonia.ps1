Function CITDatabase ([string]$GroupName,[string]$GroupMembers   )

{

[string] $Server= "10.16.99.15,1433"

[string] $Database = "ESTONIADatabase"








 

$Command = New-Object System.Data.SQLClient.SQLCommand

$Command.Connection = $Connection

 

$SqlConnection = New-Object System.Data.SqlClient.SqlConnection

$SqlConnection.ConnectionString = "Server = $Server; Database = $Database; Integrated Security = True;"

try{

 $SqlConnection.Open()


 
[string] $SqlQuery= $("INSERT INTO GroupMemberDetails VALUES ('$GroupName','$GroupMembers');")

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







 



$txtFolderPath = "D:\CIT_BulkProcessOutPut\GetADGroupMember\Test_Data_ACL_Estonia.csv"


$dataList = Import-Csv $txtFolderPath -ErrorAction Stop





foreach ($rowData in $dataList) {

$Tempgroup =  $rowData.Security_Group.Trim()

Write-Host $Tempgroup

Write-host $rowData.Security_Group.Length

if ( $rowData.Security_Group.Length -eq 0)

{

Write-Host Noaction


}

else

{

$Group = Get-ADGroup -id $Tempgroup -Server "de-s-abb0033.abb.com:3268" -ErrorAction ignore
$GroupName = "LDAP://"+$Group

$Group = [ADSI]$GroupName

$groupMemberList =  $Group.member  




CITDatabase -GroupName $Tempgroup  -GroupMembers  $groupMemberList



}




}