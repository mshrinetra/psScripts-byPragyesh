
######Step:2 Get the required .BAT format ############

$PSScriptRoot = "C:\Testing"

$i=1

$serverfiles = Import-Csv "$PSScriptRoot\All_FolderPath_Write_Group_Only_Folders.csv"

foreach($server in $serverfiles)
    {

    Write-Host $server.folderpath

    $s =  $server.folderpath

    $g = $server.groupname
        $content = @()

        $content += "icacls "+'"'+$s +'"'+ " /grant my-s-file001\$g" +":(OI)(CI)M /T /C"  
       
        $s = $s.Split(":")

        $s = $s.Split("\")
         $s = $s.Split(".")

        $s = $s[2] +"_" + $s[3] 

    $i = $i + 1

        $outfn = $PSScriptRoot + "\$s$i" + ".bat"
        $content | Out-File $outfn
    } 

$files = [IO.Directory]::GetFiles("C:\Testing") 
foreach($file in $files) 
{     
    $content = get-content -path $file 
    $content | out-file $file -encoding default   
}

