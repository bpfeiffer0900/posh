#credit to Jeff Hicks from Pluralsight - This is for me to help gain muscle memory

#demo object members in action

#region Get-Member

get-service
get-service | get-member

#see just properties
get-service | get-member -Membertype Properties

#once you know the properties you can use them
get-service | Select Name,Status, ServiceType | ft -AutoSize

#end region

#region creating custom properties
#select object#start some new processes
notepad;calc.exe

#start time only works locally
get-process | where starttime | select ID,Name,StartTime, @{Name="RunTime";Expression={(Get-Date) - $_.StartTime}} | sort RunTime

#format-table
$computers = $env:COMPUTERNAME
Get-CimInstance win32_logicaldisk -filter "drivetype=3" -comp $computers | Format-Table -Groupby PSComputername -Property DeviceID,VolumeName,
@{N="SizeGB";E={[math]::Round($_.Size/1GB)}},
@{N="FreeGB";E={[math]::Round($_.Freespace/1GB,2)}},
@{N="PerFree";E={[math]::Round(($_.Freespace/$_.size)*100,2)}}

#passthru a single change
dir C:\scripts -file -recurse
Add-Member AliasProperty Size -value length -PassThru | saort size -descending | select FullName,size -first 10

#a practical example
$files | Add-Member –Membertype AliasProperty -Name Size –Value Length 
$files | Add-Member ScriptProperty –Name FileAge –Value {(Get-Date) - ($this.LastWriteTime)} 
$files | Add-Member ScriptProperty –Name FileAgeDays –Value {[int]((Get-Date) - ($this.LastWriteTime)).TotalDays} 
$files | Add-Member Noteproperty Computername $env:computername 
$files | sort Size –desc | Select FullName,Size,FileAge*,Computername –first 10

#endregion

#region creating new objects

#using New-PSObject
#purely for demonstration purposes
$dt = new-object system.datetime 2014,12,31
$dt

#using a type accelerator is better
[datetime]$d = "12/31/2014"
$d

#creating a custom object
$h = [ordered]@{
    Computername=$env:COMPUTERNAME
    User=$env:USERNAME
    Processes = (Get-Process).count
    Running = Get-Service | where {$_.status -eq 'running'}
}

#using [pscustomobject]
[pscustomobject]$h

#putting it all together

$computers = "chi-dc01","chi-dc02"
$DCS = foreach ($computer in $computers) {
    $ntds = dir \\$computer\admin$\ntds\ntds.dit
    $os = Get-wmiobject win32_operatingsystem -Computername $computer
    $DSlog = Get-Eventlogs 'Directory Service' -newest 20 -computer $computer
    $netlogon = Get-wmiobject win32_share -filter "name='Netlogon'" -ComputerName $computer
    $sysvol = get-wmiobject win32_share -filter "name='Sysvol'" -Computer $computer

    #create a custom object for each domain controller
    [System.Management.Automation.PSCustomObject][ordered]@{
        Computername = $os.csname
        OperatingSystem = $os.caption
        ServicePack = $os.servicepackmajorversion
        NTDS = $ntds
        DSlog = $DSlog
        Netlogon = $netlogon.path
        Sysvol = $sysvol.path
    }
}

$DCS

$dcs | select -expand NTDS

#or expand like This
$dcs.dslog | where {$_.entrytype -ne 'information'} | select Timegenerate,Entrytype,Source,Message,
@{N="Computername";E={$_.machinename}} | out-gridview

#endregion

