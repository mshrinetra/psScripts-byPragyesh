#
# Estonia RFS2027_EUS
#



Remove-Item "C:\Estonia\Output\ES_ACL_List.txt" -Recurse -Force -ErrorAction Ignore
Remove-Item "C:\Estonia\Output\ES_ACL_List_AfterSplit.xlsx" -Recurse -Force -ErrorAction Ignore
New-Item -path "c:\" -name "Estonia" -itemType "directory" -ErrorAction Ignore  
New-Item -path "c:\Estonia" -name "Output" -itemType "directory" -ErrorAction Ignore

#################################################################

$command = @'
cmd.exe /C accesschk -nobanner -s "\\eejur-v-0000000.ee.abb.com\data$\gbs\fi\R2R\3.GBI\7.Inter Group\2017" > "C:\Estonia\Output\ES_ACL_List.txt"
'@
Invoke-Expression -Command:$command -ErrorAction Stop





#################################################################

Set-location "C:\Estonia\Output"
$excel = new-object -comobject excel.application
$workbook = $excel.workbooks.open("C:\Estonia\Macro\ES_ACL_List_Split.xlsm")
$worksheet = $workbook.worksheets.item(1)
$excel.Run("splitpermissoins2")
$excel.quit()

#################################################################

Function ExportWSToCSV ($excelFileName, $csvLoc)
{
    $excelFile = "C:\Estonia\Output\" + $excelFileName + ".xlsx"
    $E = New-Object -ComObject Excel.Application
    $E.Visible = $false
    $E.DisplayAlerts = $false
    $wb = $E.Workbooks.Open($excelFile)
    foreach ($ws in $wb.Worksheets)
    {
        $n = $excelFileName
        $ws.SaveAs($csvLoc + $n + ".csv", 6)
    }
    $E.Quit()
}
ExportWSToCSV -excelFileName "ES_ACL_List_AfterSplit" -csvLoc "C:\Estonia\Output"


#############################################################################

$txtFolderPath = "C:\Estonia\OutputES_ACL_List_AfterSplit.csv"


$dataList = Import-Csv $txtFolderPath -ErrorAction Stop

foreach ($rowData in $dataList) {

$Tempgroup =  $rowData.Security_Groups.Trim()



                        $Group = Get-ADGroup -id $Tempgroup -Server "de-s-abb0033.abb.com:3268" -ErrorAction ignore
                        $GroupName = "LDAP://"+$Group

                        $Group = [ADSI]$GroupName

                        $groupMemberList =  $Group.member | Format-List | out-string
                    
  $details = @{ 
                                
                                             
                                                Group_Name     = $Tempgroup
                
                                                Group_Member = $groupMemberList
                             
                
                                        }                           
     
                        $results = New-Object PSObject -Property $details  | Select Group_Name, Group_Member

                        $results | export-csv -Append -Path "C:\Estonia\ES_GroupMembers_List.csv" -NoTypeInformation
}

########################################################################################################################################

$Location = "C:\Estonia"

$FolderName = $(get-date -f MM-dd-yyyy_HH_mm_ss)


New-Item -path $Location -name $FolderName -itemType "directory" -ErrorAction Stop

$FinalLocation =  $Location+"\"+$FolderName

Move-Item "C:\Estonia\ES_GroupMembers_List.csv" $FinalLocation
Move-Item "C:\Estonia\OutputES_ACL_List_AfterSplit.csv" $FinalLocation


