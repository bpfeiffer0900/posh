# Demo Powershell Fomatting

#Credit goes to Jeff Hicks and his Pluralsight videos - This is just me hammering it into my brain

#Region Format-wide

get-process | Format-Wide
get-process | Format-wide -column 4
get-process | format-wide -AutoSize

#sort on property before grouping
Get-Service | Sort Status | fw -GroupBy status 

#endregion

#Region Format-Table

#this is fine if you think you want to do something else with
#the output

get-process | sort VM -Descending | Select ID,Name,VM,@{N="Computername";E={$_.Machinename}} -first 10
get-process | sort VM -Descending | Select ID,Name,VM,@{N="Computername";E={$_.Machinename}} -first 10 | format-table
get-process | sort VM -Descending | Select ID,Name,VM,@{N="Computername";E={$_.Machinename}} -first 10 | format-table -AutoSize

#grouping by property
get-eventlog System -newest 50 | Format-Table -GroupBy EntryType -Property TimeGenerated,Source,Message -Wrap

#should sort first
get-eventlog System -newest 50 | Sort EntryType | Format-Table -GroupBy EntryType -Property TimeGenerated,Source,Message -Wrap

#formatting has to be last

#this will fail
$computer = Get-ChildItem Env:\COMPUTERNAME | select Value | fw

Get-CimInstance Win32_OperatingSystem -comp $computer | Format-Table @{n="OS";e={
    [regex]$rx="Microsoft|Windows|\(R|)"
    $rx.Replace($_.Caption,""),Trim()}
    },InstallDate,
    @{n="Computername";e={$_.CSName}},
    @{n="SP";e={$_.ServicePackmajorversion}} -auto |
    Sort InstallDate
}}

#see why?
gcim win32_operatingsystem | ft Caption,CSName,InstallDate | gm

#process data before formatting
Get-CimInstance Win32_OperatingSystem -comp $computer | Format-Table @{n="OS";e={
    [regex]$rx="Microsoft|Windows|\(R|)"
    $rx.Replace($_.Caption,"").Trim()}
    },InstallDate,
    @{n="Computername";e={$_.CSName}},
    @{n="SP";e={$_.ServicePackmajorversion}} -auto |
    Sort InstallDate

#endregion

#region Format-List
#great way to discover object properties
get-process system | Format-List *
get-process | ft
get-process | fl
dir C:\scripts
dir C:\scripts | fl

#grouping
dir C:\scripts |sort Extension
dir C:\scripts |sort Extension | fl



#endregion

