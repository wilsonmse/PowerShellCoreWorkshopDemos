function get-largestfiles {
    [CmdletBinding()]
    param (
        [string]$path,
        [int]$listtop=10,
        [int]$minimumsizeMB=100 # only looks for files larger than n MBbytes
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
        $largerfiles = Get-ChildItem -path $rootfolder -File -Recurse | where-object {$_.Length -ge $minimumsizeMBMB} | select-object Name, DirectoryName,Length | Sort-Object -top $listtop Length -Descending       
    
    }  
    end {
        return $largerfiles 
    }
}

#get all partitions in computer
$partitions = Get-partition  | Select-Object DriveLetter


foreach ($partition in $partitions)
{
    $arrayoflargestfiles = get-largestfiles -path "$partition`:\" -listtop 20 -minimumsizeMB 100
}

#show Largest files from all partitions
$arrayoflargestfiles

