#Version : 1.0
#Purpose : To Delete AD Groups.
#Creator : Saurabh Bhargava\Vinoth Kumar Nagarajan
$LogFileN = "$Modulepath\LOG-Files\AD-Bulk-Logs.txt"
$InputLocation = "$Modulepath\INPUT folder\Bulkgrpdel.csv"



Function InfoMessage
{
    Param
    (
        [Parameter(Mandatory=$True)] [String] $strMessage
    )

    $strOutput = "Info: " + $strMessage
    Write-Host $strOutput
    Write-Output $strOutput | Out-File $LogFileN -Append
}

Function ErrorMessage
{
    Param
    (
        [Parameter(Mandatory=$True)] [String] $strMessage
    )

    $strOutput = "Error: " + $strMessage
    Write-Host $strOutput -ForegroundColor Red
    Write-Output $strOutput | Out-File $LogFileN -Append
}

Function SuccessMessage
{
    Param
    (
        [Parameter(Mandatory=$True)] [String] $strMessage
    )

    $strOutput = "Success: " + $strMessage
    Write-Host $strOutput -ForegroundColor Green
    Write-Output $strOutput | Out-File $LogFileN -Append
}

Function WarningMessage
{
    Param
    (
        [Parameter(Mandatory=$True)] [String] $strMessage
    )

    $strOutput = "Warning: " + $strMessage
    Write-Host $strOutput -ForegroundColor Yellow
    Write-Output $strOutput | Out-File $LogFileN -Append
}


Import-csv "$InputLocation" | Foreach {

$Nam = $_.name

	try
	{
	$Grp = Get-ADGroup -Identity "$Nam" | Select Name
	SuccessMessage (" Group $Grp found in AD.")
	Remove-ADGroup -Identity "$Nam" -Confirm:$false
	SuccessMessage (" Group $Grp Deleted from AD.")
	}
	Catch
	{
	ErrorMessage ("Group $Nam was not deleted as it was not found in AD.")	
	}
}

