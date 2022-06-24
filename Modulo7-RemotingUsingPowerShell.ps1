#SLIDE 11 - Remoting with PowerShell


$credential = Get-Credential
invoke-command -ComputerName windc -Credential $credential -ScriptBlock {Get-Process} 