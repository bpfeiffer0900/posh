##SimpleConfigv2.ps1
##
##Based on DSC Script from Jason Helmick
##
##This script will create a MOF File for isntalling the Web Server (IIS) Role
##It will also test the running of the configuration on a remote system

#Configuration Block
configuration WebServerConfig {

        ##Node Block used to determine target
        Node $ComputerName {

            ##Resource Block used to configure resources
            ## Windows Feature is a built-in resource Block
            WindowsFeature IIS{

                Name = 'web-server' ##Feature Name
                Ensure = 'Present' ##Determines install status. To uninstall the role, set Ensure to "Absent"
            }
        }
}
##Variable for name of Computer that configuration will apply to
$computername = 'DC01'

##Executes WebServerConfig configuration to create the MOFfile
WebServerConfig -OutputPath C:\scripts\Powershell\DSC\Config

##To run process for Configuration on DC01
Start-DscConfiguration -Path C:\Scripts\dsc\config -Computername DC01 -Whatif -Wait