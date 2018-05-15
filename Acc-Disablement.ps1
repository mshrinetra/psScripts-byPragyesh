#Version : 1.0
#Purpose : To Disable the users from Active Directory
#Creator : Saurabh Bhargava\Vinoth Kumar Nagarajan
$LogFileI = "$Modulepath\LOG-Files\AD-Individual-Logs.txt"

Function BlankMessage
{
    Param
    (
        [Parameter(Mandatory=$True)] [String] $strMessage
    )
    $strOutput = "Account Disable is done by: " + $strMessage
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

$Disable = read-host "Enter the User's SAM account or login name to be Disable"
try {
    get-ADuser $Disable | select Name
    InfoMessage ( "User $Disable will be Disable and all the access for this user will be lost")
    Disable-Adaccount -Identity $Disable 
    SuccessMessage ("Provided user $Disable is disabled")
     }
catch {
      ErrorMessage ( "User $Disable does not exists in AD.")
    }