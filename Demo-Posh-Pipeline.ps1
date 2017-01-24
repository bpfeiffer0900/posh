# Demo Powershell Pipeline

#Credit goes to Jeff Hicks and his Pluralsight videos - This is just me hammering it into my brain

#region Pipelining...
get-service -name s*
get-service -name s* | where {$_.status -eq 'running'}
get-service -name s* | where {$_.status -eq 'running'} | restart-service -WhatIf 

## Using Variables
$p = Get-Process
## this is the same thing as running Get-Process at the previous point
$p

$p | where {$_.workingset -gt 20mb}
## objects can change in the Pipeline
$p | where {$_.workingset -gt 20mb} | measure-object WorkingSet -sum -Average

##passthru
notepad;notepad
get-process notepad
get-process notepad | stop-process | Tee-Object -Variable killed
$killed

## look at help and see -passthru
help Stop-Process
get-process notepad | stop-process -PassThru | Tee-Object -Variable killed

#endregion

#region Write-Host vs Write-Output

## These are all equivalent
write-output Jeff
write Jeff

##need quotes here so Powershell knows this is a string
"Jeff"

##But this is hard to tell apart
Write-host "Jeff"

## But it is not written to the Pipeline
write "Jeff" | Get-Member

##Change font color
Write-Host "I am logged on as $env:USERDOMAIN\$env:USERNAME" -Foreground Green 

## you generall dont need to explicitly call write-output

##sidebar on variable expansion
$n = "Jeff"
"I am $n"
'I am $n'
"The value of `$n is $n"
"I am $n on computer $env:computername."

##this is where it gets tricky
$ = get-service bits
$s.displayname
$s.Status
"The $s.displayname is $s.status."

##need a subexpression
"The $($s.displayname) is $($s.status)."

#endregion

#region ForEach-Object...
calc;calc;calc
Get-Process calc

##the process object has a CloudMainWindows() method but you can onlu 
##it one at a time
get-process calc | foreach {
    write-host "Closing process $($I.id)" -fore Yellow
    $_.CloseMainWindow()
    }

##this is ForEach-Object
dir C:\ -Directory | foreach {
    $stats = dir $_.FullName -Recurse -File |
        Measure-Object length -Sum
    $_ | Select-Object FullName,
    @{Name="Size";Expression={$stats.sum}},
    @{Name="Files";Expression={$stats.count}}
} | Sort Size

#endregion

#region ForEach Enumerator
##filter out processes that dont have a path like system
$processes = Get-Wmiobject Win32_process -filter "executablepath like '%'"
foreach($process in $processes) {
        get-acl $process.executablepath
}

##this will fail
foreach ($process in $processes) {get-acl $process.executablepath} | tt -Variable paths

##but you could do this because each ACL object is written to the Pipeline
$paths = foreach ($process in $processes) {
    get-acl $process.executablepath
}

##this is better
Get-WmiObject Win32_process -filter "executablepath like '%'" | select -expandproperty executablepath -unique | get-acl

##but sometimes you really need to use foreach
help acout_foreach -ShowWindow

$seed = "P@ssw0rd"
$new = ""
foreach ($letter in $seed.ToCharArray()) {
    $new+=$([int]$letter+1) -as [char]
}
$new

#endregion

#region stream redirection
##simple redirection
get-process s* > procs.txt
get-content procs.txt

##or append
get-process w* >>procs.txt
cat procs.txt

##still recommend using Out-File
get-wmiobject win32_logicaldisk -comp "FOO", $env:computername 2>err.txt
dir err.txt
cat err.txt

##or use with scripts - Regular output
script.ps1 -Verbose

##now with redirection
script.ps1 -Verbose 2>err.txt 3>warn.txt 4>verbose.txt

#merge verbose to success
script.ps1 -verbose 4>&1 1>out.txt 2>err.txt

#endregion