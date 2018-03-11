#
# This script is designed to loop forever with a 5 second wait between
# each loop. It will check if Windows Media Center is recording
# and if it is, then update a binary sensor in Home Assistant.
# 
# Forked from WMC Status Light PowerShell Script from:
# Pat O'Brien - http://obrienlabs.net
# April 8, 2016
#
# Modified to communicate with Home Assistant
# Brent Saltzman - http://brentsaltzman.com
# March 11, 2018
#

while($true) {
	# WMC is open locally or on an extender
        #  $wmcshell = Get-Process ehshell -ErrorAction SilentlyContinue
	
	# WMC is recording a show
    $wmcrec = Get-Process ehrec -ErrorAction SilentlyContinue
	
    if ( $wmcrec) {
        # Recording a show, tell Home Assistant

        Write-Host "ehshell.exe or ehrec.exe found, telling Home Assistant that WMC is recording"
	$data = "{"state": "on", "attributes": {"friendly_name": "WMC Recording Status"}}"
		Invoke-RestMethod -URI "http://IP_ADDRESS:8123/api/states/binary_sensor.WMCRecording"
    } else {
        # Not recording a show, set status to green
        Write-Host "ehshell.exe or ehrec.exe not found, telling Home Assistant that WMC is not recording"
	$data = "{"state": "off", "attributes": {"friendly_name": "WMC Recording Status"}}"
		Invoke-RestMethod -URI "http://IP_ADDRESS:8123/api/states/binary_sensor.WMCRecording"
    }
    
    # Sleep for 30 seconds, then check again
    Start-Sleep -s 30
}
