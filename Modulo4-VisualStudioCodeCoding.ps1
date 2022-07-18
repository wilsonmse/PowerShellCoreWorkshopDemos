#Modulo4 


# SLIDE 17 - DEMO 1 - Shortcuts in coding

#show intellisense in action
#put the cursor on the end of command bellow and press CRTL+SPACE
Get-

#Let intellisense help finding parameters for the command
get-process -name pwsh

Get-LocalUser

Get-service -name a* | Where-Object {$_.status -eq "running"}



# SLIDE 25 - DEMO 2 - Key Mapping in VSC
CTRL K + CTRL R - Opens Default Browser
CRTL K + CTRL S 

F1 => look for Keyboard Default Shortcuts json









#SLIDE 40 - DEMO 2 - Terminal

CTRL + '
CTRl + SHIFT + ' # CREATE a new Instance of current Terminal

#not works in ISE
Get-Command | more 



