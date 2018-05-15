#Version : 1.0
#Purpose : To Unlock an Active Directory Account.
#Creator : Saurabh Bhargava\Vinoth Kumar Nagarajan
$LogFileI = "$Modulepath\LOG-Files\AD-Individual-Logs.txt"

Function BlankMessage
{
    Param
    (
        [Parameter(Mandatory=$True)] [String] $strMessage
    )
    $strOutput = "Account Unlock is done by: " + $strMessage
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

$Unlock = Read-host "Enter the User's SAM account or login name to be Unlocked"
try {
    get-ADuser $Unlock | select Name
    InfoMessage ( "User $Unlock will be Unlocked")
    Unlock-ADAccount -Identity $Unlock 
    SuccessMessage ("Provided user $Unlock is Unlocked") 
     }
catch {
      ErrorMessage ( "Provided user $Unlock  does not exists in AD.")
    }