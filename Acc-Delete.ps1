#Version : 1.0
#Purpose : To delete the users from Active Directory
#Creator : Saurabh Bhargava\Vinoth Kumar Nagarajan
$LogFileI = "$Modulepath\LOG-Files\AD-Individual-Logs.txt"

Function BlankMessage
{
    Param
    (
        [Parameter(Mandatory=$True)] [String] $strMessage
    )
    $strOutput = "Account deletion is done by: " + $strMessage
    Write-Host $strOutput
    Write-Output $strOutput | Out-File $LogFileI -Append
}

Function InfoMessage
{
    Param
    (
        [Parameter(Mandatory=$True)] [String] $strMessage
    )

    $strOutput = "Info: " + $strMessage
    Write-Host $strOutput
    Write-Output $strOutput | Out-File $LogFileI -Append
}

Function ErrorMessage
{
    Param
    (
        [Parameter(Mandatory=$True)] [String] $strMessage
    )

    $strOutput = "Error: " + $strMessage
    Write-Host $strOutput -ForegroundColor Red
    Write-Output $strOutput | Out-File $LogFileI -Append
}

Function SuccessMessage
{
    Param
    (
        [Parameter(Mandatory=$True)] [String] $strMessage
    )

    $strOutput = "Success: " + $strMessage
    Write-Host $strOutput -ForegroundColor Green
    Write-Output $strOutput | Out-File $LogFileI -Append
}

Function WarningMessage
{
    Param
    (
        [Parameter(Mandatory=$True)] [String] $strMessage
    )

    $strOutput = "Warning: " + $strMessage
    Write-Host $strOutput -ForegroundColor Yellow
    Write-Output $strOutput | Out-File $LogFileI -Append
}

$Delete = Read-host "Enter the User's SAM account or login name to be deleted"
try {
    get-ADuser $Delete | select Name
    InfoMessage ( "User $Delete will be deleted and all the access for this user will be lost")
    Remove-aduser -Identity $Delete
        try {
             get-ADuser $Delete | select Name
             WarningMessage ("Provided user $Delete not delete from AD")
            }
      catch {
               SuccessMessage ("Provided user $Delete is delete from AD.")
            }
     }
catch {
      ErrorMessage ( "User $Delete does not exists in AD.")
    }
