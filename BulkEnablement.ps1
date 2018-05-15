#Version : 1.0
#Purpose : To Enable the users from Active Directory
#Creator : Saurabh Bhargava\Vinoth Kumar Nagarajan
$LogFileN = "$Modulepath\LOG-Files\AD-Bulk-Logs.txt"
$InputLocation = "$Modulepath\INPUT folder"

Function BlankMessage
{
    Param
    (
        [Parameter(Mandatory=$True)] [String] $strMessage
    )
    $strOutput = "Account Enablement is done by: " + $strMessage
    Write-Host $strOutput
    Write-Output $strOutput | Out-File $LogFileN -Append
}

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

import-csv "$InputLocation\Enableusers.csv" | Foreach { 
$US = $_.user
try {
    get-ADuser $_.user | select Name
    InfoMessage ( "User $_. will be Enabled and all the access will get restored")
    Enable-ADAccount -Identity $_.user 
    SuccessMessage ("Provided user $_. is Enabled.")
     }
catch {
      ErrorMessage ( "User $US does not exists in AD.")
      }
}