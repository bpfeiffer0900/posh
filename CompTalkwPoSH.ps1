<# 
.Synopsis 
    This script will make your computer speak. 
 
 
.Description 
    This script will utlize System.speech to make your computer talk. This will demonstrate the usage of .NET Assemblies using Powershell.
 
 
.Example 
    Get-supportinfo.ps1 -ComputerName Client1 -Username User1 
 
 
.Example 
    Get-supportinfo.ps1 -ComputerName Client1 -Username User1 | out-file c:\userinfo.txt 
  
    Send output to a text file.   
#>

# Script Name = CompTalkwPoSH.ps1 
# Creator = Bill Pfeiffer
# Date = 2016-12-05
# Updated = 2016-12-05
# References, if any
# https://app.pluralsight.com/player?course=play-by-play-discovering-powershell-minasi&author=mark-minasi&name=play-by-play-discovering-powershell-minasi-m3&clip=1

# Add .NET Assembly in Powershell script
Add-type -AssemblyName System.speech

# speech variable
$talk = New-Object System.speech.synthesis.SpeechSynthesizer

# speak with default voice
$talk.speak("Howdy Powershell Fans!")

# set speech variable with a different voice
$talk.SelectVoice("Microsoft Zira Desktop")

# talk with Zira
$talk.speak("Howdy Powershell Fans!")

# add names to variable
$names = ($talk.GetInstalledVoices().VoiceInfo.name)

# Loop through voices using Foreach
$names | foreach {$talk.SelectVoice($_);$talk.speak("Hello From $_")}