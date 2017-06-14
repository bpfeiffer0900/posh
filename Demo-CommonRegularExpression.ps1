#region LIKE
"jeff" -like "j*"

"JEFF" -like "*ff"

"jeff" -like "myles"

get-content c:\work\computers.txt | where {$_ -like "*DC" -and !(Test-Connection $_ -quiet -Count 1)}

#endregion

#region Match
"jeff" -match "j"

#$matches created automatically
$Matches

"JEFF" -match "ff"
$Matches

get-process | where {$_.company -AND $_.company -notmatch "Microsoft"} | select Name,Company

#beware of floating
"powershell" -match "pow"
$Matches

"turtlepower" -match "pow"
$matches

"powershell" -match "^pow"
"turtlepower" -match "^pow"

dir "\\chi-fp01\executive" -filter "datareport*.docx" | where {$_.name -match "t\d{2}\.docx$"}

#end region

#region Common regular expression patterns
#region UNC
$unc = "\\\\\w+\\\w+"

"\\server01\public","server\public","\\server-3\files","\\server\share\folder" | where {$_ -notmatch  $unc}

#endregion

#region Logon

$names = "globalmantics\jeff","domain\jeff\foo","globo2\admin"
$acct = "\w+\\\w+"

#beware of float
$names | where {$_ -match $acct}

$acct = "^\w+\\\w+$"
$names | where {$_ -match $acct}

#endregion

#region RegEx Object
[regex]$rx = "^\\\\CHI-\w+\d{2}\\\w+$"
$rx.match($name)

$p = "^\\\\CHI-\w+\d{2}\\\w+$"

#regex is case sensitive
[regex]$rx = $p

$unc = "\\chi-fp01\public"

$unc -match $p

$rx.match($unc)
$rx.match($unc.toUpper())

#or adjust regex
[regex]$rx = "^\\\\[Cc][Hh][Ii]-\w+\d{2}\\\w+$"
$rx.match("chi-fp01\public")
$rx.match("cHI-fp01\public")
$rx.match("cHi-fp01\public")

#use the regex result
$f = read-host "enter a folder path"

$rx.match($f)
Test-Path $rx.Match($f).Value

