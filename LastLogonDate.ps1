

Get-ADUser –Filter * -property LastLogonDate, LastLogonTimeStamp | select SAMAccountName, LastLogonDate, LastLogonTimeStamp | Sort LastLogonDate | ft –a
