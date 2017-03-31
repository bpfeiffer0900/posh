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

#endregion

#region Format-List



#endregion

