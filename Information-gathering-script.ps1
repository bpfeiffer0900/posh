<#
.Synopsis
    Short Description

.Description
    Long Description

.Example
    Get-supportinfo.ps1 -ComputerName Client1 -Username User1

.Example
    Get-supportinfo.ps1 -ComputerName Client1 -Username User1 | out-file c:\userinfo.txt
 
    Send output to a text file.  
#>

# Script Name = Get-helpdesksupport.ps1
# Creator = Michael Bender
# Date = July 31, 2015
# Updated = August 14, 2015
# References, if any

##Parameters for Computername $ Username
Param (
    [Parameter(Mandatory=$true)][string]$computername
    [Parameter(Mandatory=$true)][string]$username
) 

#Variables


#IP Address
$DNSFQDN = Resolve-Dnsname -name $ComputerName | select Name,IPaddress

#DNS Server
$DNSServer = (Get-DnsClientServerAddress -cimsession (New-CimSession -computername $computername) -InterfaceAlias "ethernet0" -AddressFamily IPv4).ServerAddresses

#OS Description
$OS = (Get-CimInstance Win32_OperatingSystem -Computername $ComputerName).Caption

#System Memory
$memory = ((((Get-CimInstance Win32_PhysicalMemory -Comoutername $ComputerName).capacity|measure -Sum).Sum)/1gb)

#Last Reboot
$Reboot = (Get-CimInstance -Class Win32_OperatingSystem -ComputerName $ComputerName).LastBootUpTime

#Disk Space/ Free Space
$drive = Invoke-Command -ComputerName $ComputerName {get-psdrive | where Name -eq "C"}
$Freespace = [Math]::Round(($drive.free)/1gb)

#Last User Logon Date and Time
$lastlogonuser = get-aduser -Identity wpfeiffer -Property *).LastLogonDate
If ($lastlogonuser -eq $null) {
    $lastlogonuser = "User has not logged onto the network since account creation"
}

#Retrieve Group Membership of AD User Account
$ADGroupMembership = get-aduser -Identity wpfeiffer -Property *).memberof

#User Accounts on the Local System
(Get-CimInstance Win32_UserAccount -CimSession )

#Printer
$Printers = Get-Printer -ComputerName $Computername | Select -Propert Name,DriverName,Type | ft -AutoSize

#Write Output to Screen & Make Availbale for pipeline commands
Write-Output "Username: $username" ; ""
Write-Output $userAccounts; ""
Write-Output "DNS Name & IP Address of Target:"
Write-Output $DNSFQDN
Write-Output "DNS Server of Target: $DNSServer"
Write-Output "Last User Logon Attempt: $LastLogonUser"
Write-Output "Computername: $Computername"
Write-Output "Total System RAM: $memory GB" ; ""
Write-Output "Freespace onC: $Freespace GB"
Write-Output "Printers Installed: "
Write-Output $Printers
Write-Output "Group Membership ( Displayed as Distinguished Name )"
Write-Output $ADGroupMembership