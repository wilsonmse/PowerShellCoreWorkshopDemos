function get-largestfiles {
    [CmdletBinding()]
    param (
        [string]$path,
        [int]$listtop=10,
        [int]$minimumsizeKB=100 # only looks for files larger than n MBbytes
    )
    begin {
        if(Test-Path $path)
        {
            $rootfolder = get-item -Path $path
        }
        else 
        {
            return "Informed path is not valid"
        }
    }
    process {
        $largerfiles = Get-ChildItem -path $rootfolder -File -Recurse | where-object {$_.Length -ge $minimumsizeKBKB} | select-object Name, DirectoryName,Length | Sort-Object -top $listtop Length -Descending       
    
    }  
    end {
        return $largerfiles 
    }
}

#get all partitions in computer
get-largestfiles -path c:\temp -listtop 5 -minimumsizekB 1



$partitions = Get-partition | where-object {$_.DriveLetter -match "\w" } | Select-Object DriveLetter 


foreach ($partition in $partitions)
{
    $partition.DriveLetter
    $arrayoflargestfiles = get-largestfiles -path "$($partition.DriveLetter)`:\" -listtop 20 -minimumsizeKB 100
}

#show Largest files from all partitions
$arrayoflargestfiles

