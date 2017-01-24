# Demo Powershell Arrays and Hash Tables

#Credit goes to Jeff Hicks and his Pluralsight videos - This is just me hammering it into my brain

#region array usage and language
$a = 1..10
$a

#how many?
$a.count

#access by index number
$a[0]
$a[1..3]
$a[-1]

#arrays of objects
$b = get-service s*
$b[0]

#treat it as an objects
$b[0].DisplayName

#in v2 we would need this to select a single property
$b | select DisplayName
$b | select DisplayName gm
$b | select -expand DisplayName

#now we can do this
$b.DisplayName

#arrays can contain different objects
#any comma seprated list is an array
$c=1, "b",3,$PSVersionTable,(get-process w*)
$c.Count$c[3].PSVersion

#even arrays of arrays
$c[-1]
$c[-1][0]

#create an empty array
$d=@()
$d+=200
$d

#these will fail
$d-=9

#best way to remove items is to filter out the ones you dont want
$d = $d | where {$_ -ge 100}

#end region

#region practical examples

#these examples can all be done interactively in the console of an array of the domain controller names
$dcs = "CHI-DC01","CHI-DC02","CHI-DC03"
$service = "wuauserv","winmgmt"

