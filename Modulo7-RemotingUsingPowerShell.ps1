#SLIDE 11 - Remoting with PowerShell

Enable-PSRemoting

$credential = Get-Credential

#differences between ad-hoc connection and session
invoke-command -ComputerName windc -Credential $credential -ScriptBlock {Get-Process} 
invoke-command -ComputerName windc -Credential $credential -ScriptBlock { $a= 123; $b=abc; $a;$b } 

invoke-command -ComputerName windc -Credential $credential -ScriptBlock { $a;$b } 


#SLIDE 28 - DEMO 3 - Variables while remoting using Powershell

$session =New-PSSession -ComputerName windc -Credential $credential

Enter-PSSession $session
#create variable in remote session
$remoteint = 200
$remotestr = "World"
Disconnect-PSSession

#reconnect session
Enter-PSSession $session

#show remote variables values were keeped this time

$localintvar = 100
$localstrvar = "Hello"

Invoke-Command -Session $session -ScriptBlock {$string = $using:localstrvar + $remotestr; $integer = $remoteint+$using:localintvar; return $string, $integer}