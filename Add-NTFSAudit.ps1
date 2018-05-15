

$Paths = "\\XE-S-JUMP005.xe.abb.com\c$\Users\xw-admin-pk8\Documents\PowerShell\Destination","\\XE-S-JUMP005.xe.abb.com\c$\Users\xw-admin-pk8\Documents\PowerShell\Destination","\\XE-S-JUMP005.xe.abb.com\c$\Users\xw-admin-pk8\Documents\PowerShell\Destination","\\XE-S-JUMP005.xe.abb.com\c$\Users\xw-admin-pk8\Documents\PowerShell\Destination","\\XE-S-JUMP005.xe.abb.com\c$\Users\xw-admin-pk8\Documents\PowerShell\Destination","\\XE-S-JUMP005.xe.abb.com\c$\Users\xw-admin-pk8\Documents\PowerShell\Destination","\\XE-S-JUMP005.xe.abb.com\c$\Users\xw-admin-pk8\Documents\PowerShell\Destination","\\XE-S-JUMP005.xe.abb.com\c$\Users\xw-admin-pk8\Documents\PowerShell\Destination","\\XE-S-JUMP005.xe.abb.com\c$\Users\xw-admin-pk8\Documents\PowerShell\Destination","\\XE-S-JUMP005.xe.abb.com\c$\Users\xw-admin-pk8\Documents\PowerShell\Destination","\\XE-S-JUMP005.xe.abb.com\c$\Users\xw-admin-pk8\Documents\PowerShell\Destination","\\XE-S-JUMP005.xe.abb.com\c$\Users\xw-admin-pk8\Documents\PowerShell\Destination","\\XE-S-JUMP005.xe.abb.com\c$\Users\xw-admin-pk8\Documents\PowerShell\Destination","\\XE-S-JUMP005.xe.abb.com\c$\Users\xw-admin-pk8\Documents\PowerShell\Destination","\\XE-S-JUMP005.xe.abb.com\c$\Users\xw-admin-pk8\Documents\PowerShell\Destination"

$i = 1

ForEach( $Path in $Paths)

{

$i = $i + 1

Add-NTFSAudit -Path $Path  -Account "everyone" -AccessRights CreateDirectories,CreateFiles,Write,WriteAttributes,WriteExtendedAttributes,Delete,DeleteSubdirectoriesAndFiles,ChangePermissions,TakeOwnership -AppliesTo ThisFolderSubfoldersAndFiles -AuditFlags Success,Failure 


Write-Progress -Activity Updating -Status 'Progress->' -PercentComplete $i ;

}