# Demo Powershell Pipeline

#Credit goes to Jeff Hicks and his Pluralsight videos - This is just me hammering it into my brain

#region Comparison Operators
5 -gt 3
100 -lt 90
11 -le 11
$i = Get-Random -Minimum 1 -Maximum 10
$i -eq 7

#not case sensitive
"jeff" -eq "JEFF"
#although you make it so
"jeff" -ceq "JEFF"

$s = "Powershell"
#using a wildcard
$s -like "*shell"

#using regular expressions
$s -match "shell"
$s -match "shell$"

#compare array membership
$arr = "a","b","c","d"
$arr -contains "e"
$arr -contains "d"
$arr -notcontains "e"

#sometimes you go the other way
"a" -in $arr
"x" -in $arr
"x" -notin $arr

#these only work with simple values, not objects
$p = Get-Process
$p -contains "notepad"

$p.name -contains "notepad"

#endregion


#region Arithmetic Operators
5*4
5+4
5/4
5%4

#use parens to control execution
10+2/4*5-2
((10+2)/(4*5))-2


#endregion


#region Logical Operators
(4 -ge 2) -AND (10 -lt 100)
(4 -ge 8) -AND (10 -lt 100)
(4 -ge 8) -OR (10 -lt 100)

#true only if one expression is true and one is false
(4 -ge 8) -XOR (10 -lt 100)

#reverse things
-NOT (100 -gt 1)

#youll also see it written this way
!(100 -gt 1)

#a more practical exmaple
if (-Not (Test-Path "C:\Required")) {
        Write-Host "Creating  C:\required" -Foreground Cyan
        #I dont really want to create the folder
        Mkdir "C:\Required" -WhatIf
}

#endregion


#region Assignment Operators
$x = 123 ; $x
$x += 2 ; $x
$x -= 23 ; $x
$x /= 3 ; $x
$x++ ; $x
$x-- ; $x

#endregion


#region Type Operators
"jeff" -is [string]
$dt = Get-Date
$dt -is [string]
$dt -is [datetime]
$dt -isnot [datetime]

Remove-Variable

#be careful
$x = 10
$x*4
$x -is [int]
($x -as [int])*4

#better to define the right type from the beginning
$x = 10 ; $x*4

#but using -as can come in handy
$d = Read-host "Enter an expiration date"
$d 
$d -is [datetime]
$d -as [datetime]

#even better set the type from the very beginning
[datetime]$d = Read-host "Enter an expiration date"
$d

#endregion


#region Type Operators
1..10
90..75
1..10 | foreach {
    Write-host "Adding JoeTest-$_" -ForegroundColor Magenta
    #net user "JoeTest-$_" "Password" /add /domain   
}
$cmd = "get-service"
$cmd
&$cmd

#or use with scriptblocks
$sb = {get-service w* | where {$_.status -eq 'stopped'}}
&$sb

1kb
1mb
2.3MB + 4.2GB
(Get-CIMInstance win32_logicaldisk -Filter "deviceid='c:'" -Property Freespace).Freespace/1gb
#combine for a quick and dirty disk check
$df = {(Get-CimInstance win32_logicaldisk -Filter "deviceid='c:'" -Property Freespace).Freespace/1gb}

#endregion


#region Special Operators


#endregion


#region Split/Join
$t = "Powershell will rule the world"
-split $t

$n = "alice;bob;carol;david"
$n | gm
$n.split(";")
$names = $n -split ";"
$names
foreach ($name in $names) {
    Write-host "Creating folder for $name" -ForegroundColor Green
    mkdir "C:\users\$name" -Whatif
}

$parts = 7,"BK","**","us",3
$pass = -join $parts
$parts -join "~"

#endregion

#demo hashtables

#Creating
$e = @{Name="Jeff";Title="MVP";Computer=$env:COMPUTERNAME}
$e

#this is its own objects
$e | gm

#enumerating key
$e.Keys

#reference elements
$e.Item("computer")
$e.computer

#creating an empty hash table
$f=@{}

#addin to it
$f.Aaa("Name","Jeff")
$f.Add("Company","Globomantics")
$f.Add("Office","Evanston")

#changing an Item
$f.Office
$f.Office = "Chicago"
$f

#keys must be unique
$f.add("Name","jane")
$f.ContainsKey("name")

#removing an Item
$f.Remove("name")
$f

#group-object can create a hash table
$source = get-eventlog system, =newest 100
group source -AsHashTable
$source

#get a specific entry
$source.Eventlog

#handle names with spaces
$source.'Service Control Manager'

#this value is an array of event log objects
$source.Eventlog[0..3]
$source.Eventlog[0].message

#using GetEnumerator()
$source | Get-Member
$source.GetEnumerator() | Get-Member

#this will fail
$source | sort name | Select -first 5

#heres another appraoch
$source.GetEnumerator() | sort name | select -first 5
