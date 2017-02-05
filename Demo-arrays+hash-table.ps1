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


#end region

#demo Hash Tables

#creating hash table (Key value pair)
$e = @{Name="Jeff";Title="MVP";Computer=$env:COMPUTERNAME}
$e

#this is its own objects
$e = gm

#enumerating keys
$e.keys

#referencing elements
$e.Item("computer")
$e.computer

#creating an empty hash table
$f=@{}

#adding to it
$f.Add("Name","Jeff")
$f.Add("Company","Globamantics")
$f.Add("Office","Evanston")
$f

#changing an items
$f.Office
$f.Office = "Chicago"

#keys must be unique
$f.Add("Name","Jane")
$f.ContainsKey("Name")

#removing an items
$f.remove("name")
$f

#group-object can create a hash table
$source = get-eventlog system -newest 100 | group Source -AsHashTable
$source

#get a specific entry
$source.Eventlog

#handles names with spaces
$source.'Service Controler Manager'

#this value is an array of event log objects
$source.Eventlog[0..3]
$source.Eventlog[0].message

#using GetEnumerator()
$source | Get-Member
$source.GetEnumerator() | Get-Member

#this will fail
$source | sort Name | select -first 5

#heres the correct approach
$source.GetEnumerator()| Sort Name | select -frist 5

#or another thing you might want to try. This will fail
$source | where {$_.name -match "winlogon"}

#although, you could do this:
$source.keys | where {$_ -match "winlogon"} | foreach { $source.Item($_)}

#but this is a little easier and slightly faster
$source.GetEnumerator() | where {$_.name -match "winlogon"} | select -expand value

#hash tables are unordered
$hash = @{
    Name = "Jeff"
    Company = "Contoso"
    Office = "Holland"
    Computer = $env:COMPUTERNAME
    OS = (get-ciminstance Win32_OperatingSystem -Property Caption).Caption
}
$hash

#hashtables as obkect properties
$os = Get-CimInstance Win32_OperatingSystem
$cs = Get-CimInstance Win32_ComputerSystem

$properties = [ordered]@{
    Cpmputername = $os.CSName
    MemoryMB = $cs.TotalPhysicalMemory/1mb -As [int]
    LastBoot = $os.LastBootUpTime
}

New-Object -TypeName psobject -Property $properties

#hashtables as custom objects
[pscustomobject]$properties

#a larger examples
#assume computers all running Powershell 3.0
$computers = $env:COMPUTERNAME, "chi-dc01","chi-dc03"
$data = foreach ($computer in $computers) {
    #simplified without any real error handling
    $os = Get-CimInstance win32_OperatingSystem -ComputerName $computers
    $cs = Get-CimInstance Win32_ComputerSystem -ComputerName $computers
    $cdrive = Get-CimInstance Win32_LogicalDisk -filter "deviceid='C:'"

    [PSCustomObject][ordered]@{}
}

$data
#analyze the data
$data | sort runtime | select computername,runtime


