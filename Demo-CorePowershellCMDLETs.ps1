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

#getting items by attribute
dir c:\scripts -Directory
dir c:\scripts -File

dir c:\ -Hidden
dir c:\ -Hidden -File

#works with other providers
Import-module ActiveDirectory
pushd
cd ad:
dir

#sometimes it isnt apparent
dir DOMAIN

#in this case you need to use the distinguished name or use tab completion
dir '.\OU=Empoyees,DC=DOMAIN,DC=local' -Recurse

#filter needs to be an LDAP filter
dir -Recurse -filter "(&(objectclass=user)(givenname=jack))"
dir -Recurse -filter "(&(objectclass=user)(givenname=j*))"

popd

#endregion

#region Where-object
#legacy syntax
get-service | where {$_.status -eq 'Stopped'}

#new syntax
get-service | where stats -eq 'Stopped'

dir c:\scripts -fie | where Length -ge 100kb

dir C:\scripts\*.ps1 | where LastWriteTime -gt (Get-Date).AddDays(-90)
dir C:\scripts\*.ps1 -Recurse | where LastWriteTime -gt (Get-Date).AddDays(-90)

#filtering
Measure-command {
    dir C:\scripts -Recurse | where {$_.extension -eq '.ps1'}
}

Measure-command {
    dir C:\scripts -Recurse -filter '*.ps1'
}

#use filtering for those things you cant otherwise filter
dir c:\ -recurse -filter '*.xml' | where {$_.LastWriteTime.Year -eq '2012'}

#endregion

#region Sort-Object

get-process -computername computer | sort WS
get-process -computername computer | sort WS - descending

#startime property only available locally
#skip processes without a startime property
C:\WINDOWS\notepad.exe
get-process | where StartTime | sort @{Expression={(Get-Date) - $_starttime}}

#endregion

#region Select -Object

#objects
get-process | sort WS -descending | select -First 5
get-process | sort WS -descending | select -Last 5

#properties
dir C:\scripts -file | select Name,Length

#create customproperties
$data = dir C:\scripts -file | select Name,@{Name="Size";Expression={$_.Length}},LastWriteTime,@{Name="Age";Expression={((Get-Date) - $_.lastwritetime).Days}} | Sort Size -Descendin

#selecting is not the same as formatting
$data
$data | ft -Auto

#unique
get-process | select Name -Unique
get-process | select Name -Unique | sort name

#or select unique objects
1,4,5,1,6,6,7,8 | select -Unique
Get-process | select -Unique

#expand properties
get-service winmgmt | select DependentServices

#endregion

#region Group-Objects
$logs = Get-eventlog system -newest 100 | group Source
$logs

#this is a different objects
$logs | sort count -Descending
$logs | gm

#get grouped objects
$logs[0].Group
$logs[0].Group | Select EntryType,Message

#create without the elements
get-eventlog System -newest 100 | group EntryType -NoElement | sort count

#or create a hashtable
$grouphash = get-eventlog System -newest 100 | group EntryType -AsHashTable -AsString

#forced Powershell to treat EntryType as a string, because it is technically [system.diagnostics.eventlogentrytype]
$grouphash
$grouphash.error

#endregion

#region Get-Content

get-content C:\scripts\transcript01.txt

#get the head (alias parameter)
get-content c:\windows\windowsupdate.log -head 5

#get the tail of a file
get-content c:\windows\windowsupdate.log -tail 5

#endregion

#region Putting it all together
cat C:\scripts\computers.txt | foreach {Test-connection $_ -count 1 -quiet}

$data = get-wmiobject win32_operatingsystem -Computername (cat C:\scripts\computers.txt) 
select Caption,@{Name="Computername";Expression={$_.CSName}},
@{Name="FreePhysMemBytes";Expression={$_.FreePhysicalMemory*1kb}},
@{Name="TotalPhysMemBytes";Expression={$_.TotalVisibleMemorySize*1kb}},
@{Name="PercentFreeMem";Expression={
($_.FreePhysicalMemory/$_.TotalVisibleMemorySize)*100}},
NumberofUsers,NumberofProcesses |
Group Computername -AsHashTable -AsString

#analyze the data
$data.GetEnumerator() | select -expand Value | where {$_.percentFreeMem -le 25} |
sort PercentFreeMem -Desc | 
select Comp*,P*,Num*

#abbreviations and sofrtcuts to simulate how you would type it
