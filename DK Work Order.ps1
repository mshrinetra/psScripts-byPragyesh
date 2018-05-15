


# Enter a number to indicate how many days old the identified file needs to be (must have a "-" in front of it).
$HowOld = -30

#Path to the Root Folder
$Path = "\\XE-S-JUMP005.xe.abb.com\c$\Users\xw-admin-pk8\Documents\DK WorkOrder Test"

get-childitem $Path -recurse -Force -ErrorAction SilentlyContinue| where {$_.lastwritetime -lt (get-date).adddays($HowOld) -and -not $_.psiscontainer} |% {remove-item $_.fullname -force -WhatIf } 




