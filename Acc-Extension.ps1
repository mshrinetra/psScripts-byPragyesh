#Version : 1.0
#Purpose : For Account extension in Active Directory.
#Creator : Saurabh Bhargava\Vinoth Kumar Nagarajan
$LogFileI = "$Modulepath\LOG-Files\AD-Individual-Logs.txt"

Function BlankMessage
{
    Param
    (
        [Parameter(Mandatory=$True)] [String] $strMessage
    )
    $strOutput = "Account Extension is done by: " + $strMessage
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

$Extend = read-host "Enter the User's SAM account or login name that needs to be Extended"
$Date = read-host "Enter the date for Extension in DD/MM/YYYY format"
try {
    get-ADuser $Extend | select Name
    InfoMessage ( "Account for user  $Extend will be Extended")
    Set-ADUser -Identity $Extend -AccountExpirationDate $Date
    SuccessMessage "Account for user  $Extend is Extended till $Date"     
     }
catch {
      ErrorMessage ( "Provided user $Extend  does not exists in AD.")
    }

