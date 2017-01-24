$service = Get-Service | where Status –EQ "Stopped" 

Foreach ($a in $service) { 
$Name = $a.Displayname 
$Status = $a.status 
Write-output "$name is $status" 
}