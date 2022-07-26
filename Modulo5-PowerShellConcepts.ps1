#SLIDE 20 - Looking at PS CODE


Get-Help

update-help


get-process | select-object name, handles | convertto-json | out-file c:\temp\proc.json

code c:\temp\proc.json


get-process


Get-ChildItem c:\temp | select-object name, Length, LastWriteTime | sort-object LastWriteTime -Descending | export-csv c:\temp\files.csv -Append

code C:\temp\files.csv







# SLIDE 29 - Demonstration CMDLets
Get-Command

get-command -noun process

Get-command -verb export

get-command -ParameterName computername

get-command -ParameterName servicename

get-process -name pwsh 

get-process -Name Notepad | stop-process -Confirm

notepad.exe
Get-NetAdapter

Get-ComputerInfo | select-object CsManufacturer, CsSystemFamily, CsProcessors, CsTotalPhysicalMemory,OSName

Get-command -module CimCmdlets
get-help -name Get-CimSession 

get-process winword -ErrorAction Stop













### SLIDE 36 - Demonstration Objects
#Everything on powershell is an object

#string object
"Hello World"
("Hello World").GetType()
("Hello World").Length

#numeric object
(345).gettype()
(3.1415).gettype()

Get-date 
(get-date).GetType()

#array of objects
get-process
(get-process).GetType()
notepad.exe
(get-process -name Notepad).GetType()

([math]::PI).gettype()

$date = get-date
$date
$date | get-member
$date.Year
$date.DayOfWeek
$date.AddDays(8)
$date.AddYears(100)

"hello world" | get-member
("hello world").Replace('world', 'wonderful world')













######## SLIDE 41 - Demonstration Functions

## DEMO Function Snippets



function get-circunferencia {
    [CmdletBinding()]
    param (
        [int]$raio
    )
    
    begin {
        $pi = [math]::PI
    }
    
    process {
        $circunferencia = 2*$pi*$raio
    }
    
    end {
        return $circunferencia
    }
}

get-circunferencia -raio 2

1..50 | foreach-object {write-host "A circunferencia de raio $_ = $(get-circunferencia -raio $_)"}

$a= get-date

$a.DayOfWeek

"Hoje é $($a.dayofweek)"

function New-Senha {
    #requires -version 5.1
    [CmdletBinding()]
    param (
        [int]$comprimento,
        [int]$NonAlphaChars
        )
    
    begin {

    }
    
    process {
        Add-Type -AssemblyName 'System.Web'
        $password = [System.Web.Security.Membership]::GeneratePassword($comprimento, $nonAlphaChars)
    }
    
    end {
        return $password
    }
}
new-senha -comprimento 10 -NonAlphaChars 5
new-senha -comprimento 65 -NonAlphaChars 20


Get-ExecutionPolicy -list
get-command -Noun ExecutionPolicy

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser









#SLIDE 65 - Demonstration Pipeline


get-process -Name msedge*

get-process -Name msedge* | get-member

get-process -Name msedge* | Where-Object {$_.cpu -gt 10}

get-process -Name msedge* | Where-Object {$_.handles -gt 1000}

get-process -Name msedge* | Where-Object {$_.WS -gt 1000} 

get-process -Name msedge* | Where-Object {$_.WS -gt 1000}  | Sort-Object CPU -Descending | Select-Object ProcessName, CPU, WS, Handles

get-process -Name msedge* | Where-Object {$_.WS -gt 1000}  | Sort-Object CPU -Descending | Select-Object ProcessName, CPU, WS, Handles | out-file "c:\preocess.txt"

get-process -Name msedge* | Where-Object {$_.WS -gt 1000}  | Sort-Object CPU -Descending | Select-Object ProcessName, CPU, WS, Handles | out-file "c:\preocess.txt" -force

get-process -Name msedge* | Where-Object {$_.WS -gt 1000}  | Sort-Object CPU -Descending | Select-Object ProcessName, CPU, WS, Handles | out-file "c:\temp\$(get-date -format yyyyMMdd-HHmmss).txt"

Get-ChildItem -Path C:\temp

Get-ChildItem -Path C:\temp | foreach-object {write-host "removing item $_.name"; remove-item $_.Name -WhatIf}  
