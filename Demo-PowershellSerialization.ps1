#region no type information
get-service | Select name,DisplayName,status | Export-csv c:\work\svc.csv -NoTypeInformation -Delimiter ";"

psedit c:\work\svc.csv

#endregion

#region appending
#keep properties the same
 
#run at least 3 times with a little time between each sample
get-process svchost |
Add-Member -MemberType NoteProperty -name SampleTime -Value (get-date) -PassThru | 
Select * -ExcludeProperty Modules,Threads | Export-Csv c:\work\svchost.csv -Append

#region Import-CSV

#region default delimiter is comma
$impsvc = Import-Csv C:\work\svchost.csv
$impsvc
$impsvc | gm

#endregion

#region work with any csv
