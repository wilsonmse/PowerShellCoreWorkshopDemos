#module 3

# SLIDE 17 - DEMO 1 - Object Oriented Foundation
<#
What we know about objects:
    Structured Data
    Combines similar information and capabilities into one entity
    A collection of parts and how to use them
#>
$object_variable = Get-Process -name pwsh
$object_variable2 = Get-ChildItem -Path C:\temp\Events.txt
$object_variable3 = Get-LocalUser -Name workshopdemo

#get object types
$object_variable.GetType()
$object_variable2.GetType()
$object_variable3.GetType()

#discover object members
get-member -InputObject $object_variable
get-member -InputObject $object_variable2
get-member -InputObject $object_variable3

#Access Property Members
$object_variable | select-object name, CPU, Description
$object_variable2.Length
$object_variable2.Directory

$object_variable3.PasswordLastSet

#accessing Method Members of an object
$object_variable.Kill()





##### SLIDE 24 - DEMO 2 - Verb-Noun
#show how all commandlets follow the verb-noun pattern

get-help Get-Command

Get-command -verb get

get-command -noun *user*

get-command -parameterName *computer*






##### SLIDE 31 - DEMO 3 - Mapping to PS Commandlets

## demo alias and command lookup precedence

get-alias

ping 8.8.8.8
Test-Connection 8.8.8.8

new-alias -Name ping -Value Test-Connection
Remove-Alias -name ping

function ping {
    [CmdletBinding()]
    param (
        $IPAddress
    )
    write-host "It was supposed to test connectivity to $ipaddress, but it looks like so far away..." -ForegroundColor Yellow -BackgroundColor DarkBlue
}

ping 8.8.8.8




#SLIDE 38 - DEMO 4 - Linux Aliases

#open Windows Subsystem for Linux with a Linux Image installed
wsl.exe 

#Open Powershell
pwsh




# SLIDE 45 - DEMO 5 - Review Differences of Text vs object-oriented editors

execute in wsl
cat file.txt | grep World

get-command -name cat
get-command -name grep 

$filetxt = /usr/bin/cat file.txt | grep World
$filetxt.gettype()
$filetxt2 =get-content file.txt | select-string "World"
$filetxt2.gettype()



/usr/bin/cat file.txt | grep World



Get-Content c:\temp\File.txt –tail 3

Get-Content c:\temp\File.txt –Wait





