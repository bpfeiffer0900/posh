Import-Module BitsTransfer

$Source="F:"

$Destination="D:\"

$folders = Get-ChildItem -Name -Path $source -Directory -Recurse

$bitsjob = Start-BitsTransfer -Source $Source\*.* -Destination $Destination -asynchronous -Priority Foreground

while( ($bitsjob.JobState.ToString() -eq 'Transferring') -or ($bitsjob.JobState.ToString() -eq 'Connecting') )

{

Sleep 4

}

Complete-BitsTransfer -BitsJob $bitsjob

foreach ($i in $folders)

{

$exists = Test-Path $Destination\$i

if ($exists -eq $false) {New-Item $Destination\$i -ItemType Directory}

$bitsjob = Start-BitsTransfer -Source $Source\$i\*.* -Destination $Destination\$i -asynchronous -Priority low

while( ($bitsjob.JobState.ToString() -eq 'Transferring') -or ($bitsjob.JobState.ToString() -eq 'Connecting') )

{

Sleep 4

}

Complete-BitsTransfer -BitsJob $bitsjob

}