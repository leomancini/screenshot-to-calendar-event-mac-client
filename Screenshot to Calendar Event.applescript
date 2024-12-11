on open dropped_items
	try
		set progress total steps to 1
		set progress completed steps to 0
		set progress description to "Processing image..."
		set progress additional description to ""
		
		set imageFile to item 1 of dropped_items as alias
		set imagePath to POSIX path of imageFile
		
		set base64Data to do shell script "base64 -i " & quoted form of imagePath
		
		tell application "Finder"
			set scriptPath to (container of (path to me)) as text
		end tell
		set scriptFolder to POSIX path of scriptPath
		
		set tempFile to scriptFolder & ".temp_response.txt"
		
		do shell script "cd " & quoted form of scriptFolder & " && curl -X POST -H 'Content-Type: application/json' -d '{\"image\": \"" & base64Data & "\"}' 'https://screenshot-to-calendar-event-server.noshado.ws' > " & quoted form of tempFile
		
		set filename to do shell script "head -n1 " & quoted form of tempFile & " | sed 's/filename://'"
		
		do shell script "sed -n '/BEGIN:VCALENDAR/,$p' " & quoted form of tempFile & " > " & quoted form of (scriptFolder & filename)
		
		do shell script "rm " & quoted form of tempFile
		
		set progress completed steps to 1
		set progress additional description to "Complete!"
		delay 1
		
	on error errMsg
		display dialog "Error: " & errMsg buttons {"OK"} default button "OK" with icon stop
	end try
end open