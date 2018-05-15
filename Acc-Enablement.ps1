#Version : 1.0
#Purpose : To Enable the users from Active Directory
#Creator : Saurabh Bhargava\Vinoth Kumar Nagarajan
$LogFileI = "$Modulepath\LOG-Files\AD-Individual-Logs.txt"

Function BlankMessage
{
    Param
    (
        [Parameter(Mandatory=$True)] [String] $strMessage
    )
    $strOutput = "Account Enablement is done by: " + $strMessage
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

$Enable = read-host "Enter the User's SAM account or login name to be Enabled"
try {
    get-ADuser $Enable | select Name
    InfoMessage ( "User $Enable will be Enabled and all the access will get restored")
    Enable-ADAccount -Identity $Enable 
    SuccessMessage ("Provided user $Enable is Enabled")
     }
catch {
      ErrorMessage ("User $Enable does not exists in AD.")
    }