#Version : 1.0
#Purpose : To delete the users from Active Directory
#Creator : Saurabh Bhargava\Vinoth Kumar Nagarajan
$LogFileN = "$Modulepath\LOG-Files\AD-Bulk-Logs.txt"
$InputLocation = "$Modulepath\INPUT folder"

Function BlankMessage
{
    Param
    (
        [Parameter(Mandatory=$True)] [String] $strMessage
    )
    $strOutput = "Account deletion is done by: " + $strMessage
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

import-csv "$InputLocation\BulkDelete.csv" | Foreach { 
$US = $_.user
try 
     {
     get-ADuser $_.user | select Name
     InfoMessage ( "User $US will be deleted and all the access for this user will be lost")
      try
	{
	  if ($_.delfolder -eq "True")
	  {
	  $ErrorActionPreference = 'silentlycontinue'
	  $HDIR = get-ADUser -Identity $_.user -Properties homedirectory
	  $RM = $HDIR.Homedirectory
		$PathR = Test-Path "$RM"
   	        if ($PathR -match "True")
		{
		  $ErrorActionPreference = 'silentlycontinue'	
  		  Rmdir $RM
		  SuccessMessage ("Provided user $US and it's home folder is Deleted.")
		}
		if ($PathR -match "False")
		{
		 WarningMessage ("Provided user $US is Deleted and it does not have home folder.")
		} 
	  }
          if ($_.delfolder -eq "False")
	  {
	        $HDIR = get-ADUser -Identity $_.user -Properties homedirectory
                $RM = $HDIR.Homedirectory
		$PathR = Test-Path "$RM"
   	        if ($PathR -match "True")
		{
		 SuccessMessage ("Provided user $US is Deleted and it's home folder is retained.") 
		}
		if ($PathR -match "False")
		{
		 WarningMessage ("Provided user $US is Deleted and it does not have home folder.")
		} 
	   }	
	  }
	catch
	{
	 WarningMessage ("Provided user $US is Deleted and it does not have home folder.")
 	}
      Remove-aduser -Identity $_.user -confirm:$false
      }
catch 
      {
      ErrorMessage ( "User $US does not exists in AD.")
      }
}
