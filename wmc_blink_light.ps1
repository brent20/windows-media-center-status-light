#
# This script is designed to loop forever with a 5 second wait between
# each loop. It will check if Windows Media Center is recording
# and if it is, then set the blink(1) light to RED. If it is not recording
# set the blink(1) light to GREEN. 
# 
# This script uses the blink(1) GUI software with the API server enabled. 
# You could use the blink(1) CLI utility instead if you wanted. I chose 
# to go with the GUI API so that I could use the GUI if needed.
#
# Pat O'Brien - http://obrienlabs.net
# April 8, 2016
#

while($true) {
	# WMC is open locally or on an extender
    $wmcshell = Get-Process ehshell -ErrorAction SilentlyContinue
	
	# WMC is recording a show
    $wmcrec = Get-Process ehrec -ErrorAction SilentlyContinue
	
    if ( $wmcshell -or $wmcrec) {
        # Recording a show, set status to red
        Write-Host "ehshell.exe or ehrec.exe found, setting blink(1) status to red"
		Invoke-RestMethod -URI "http://localhost:8934/blink1/fadeToRGB?rgb=%23FF0000"
    } else {
        # Not recording a show, set status to green
        Write-Host "ehshell.exe or ehrec.exe not found, setting blink(1) status to green"
		Invoke-RestMethod -URI "http://localhost:8934/blink1/fadeToRGB?rgb=%2300FF00"
    }
    
    # Sleep for 5 seconds, then check again
    Start-Sleep -s 5
}
