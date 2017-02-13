#region Get-ChildItem

help dir -ShowWindow

dir C:\scripts
dir C:\scripts -Recurse

#filtering techniques
$a = {dir c:\scripts\*.ps1 -Recurse}
&$a
$b = {dir c:\scripts -include *.ps1 -Recurse}
&$b
$c = {dir c:\scripts -filter *.ps1 -Recurse}
&$c

measure-command $a
measure-command $b
measure-command $c

#but it depends on provider
get-psprovider
Push-Location
cd function: 