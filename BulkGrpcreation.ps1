#Version : 1.0
#Purpose : To create AD Groups.
#Creator : Saurabh Bhargava\Vinoth Kumar Nagarajan
$LogFileN = "$Modulepath\LOG-Files\AD-Bulk-Logs.txt"
$InputLocation = "$Modulepath\INPUT folder\Bulkgrpcre.csv"



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

$DisN = $_.DisplayName
$Nam = $_.name
$Descript = $_.Description
$Scope = $_.Scope
$Category = $_.Category
$OUpath = $_.GroupOU

	try
	{
	New-ADGroup -DisplayName "$DisN" -Name "$Nam" -Description "$Descript" -GroupScope $Scope -GroupCategory $Category -Path "$OUpath"
	SuccessMessage (" Group created with Group name as : $Nam ")
	}
	Catch
	{
		try
		{
		Get-ADgroup "$Nam" | Select Name
		ErrorMessage ("Group with $Nam Name already Exists in AD.")
		}
		catch
		{
		ErrorMessage ("Group $Nam was not created; please recheck the details and try again.")
		}
	}
}

