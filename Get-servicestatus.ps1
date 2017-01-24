# Get-ServiceStatus.ps1 - Script displays the status of services running on a specified machine. 

# Creates a Mandatory Parameter for Computername to be input
Param (
    [Parameter(Mandatory=$true)][string]$computername
)

#Creates a variable that contains the output of Get-Service
#Since this has multiple objects, it's referred to as an array
$Service = Get-Service -ComputerName $computername

#ForEach construct will run through each object (aka each service) in $Service
#It will perform all actions contained in the script block for each object
Foreach ($a in $Service) {

    #Creates variables containing the status and displayname properties
    $ServiceStatus = $a.Status
    $ServiceDisplayName = $a.DisplayName

    #If Else makes a decision based on $Servicestatus value
    if ($servicestatus -eq "Running")
        {
        Write-output "$ServiceDisplayname is $Servicestatus"
        }
    else 
        {
        Write-Output "$ServiceDisplayname is $Servicestatus"
    }
}