on makeFolder(tPath)
	do shell script "mkdir -p " & quoted form of POSIX path of tPath
end makeFolder

--set dest to "/Volumes/BLUESSD/PHOTOS/" --Users/avasseur/TestScript/"
set dest to "/Users/avasseur/__PHOTOS/"

set orig to true

-- list of {"ALBUM", album name ,in folder id ,in folder id} or {folder id, in folder id}
-- list of their names with a unique id from the tree deep navigation


tell application "Photos"
	activate
	
	--	set f to folder id "E4008621-09AB-40C5-8DA3-933503397AD9/L0/020" of folder id "9870324C-9E5A-46F2-A71B-78BF0A9DC036/L0/020"
	--	set fR to folder id "9870324C-9E5A-46F2-A71B-78BF0A9DC036/L0/020"
	--	set f to folder id "E4008621-09AB-40C5-8DA3-933503397AD9/L0/020" of fR
	--	my log_event("done test")
	--	return {"done"}
	
	set myContainerNames to {}
	set myContainers to {}
	set pos to 1
	
	set folderIds to (id of folders)
	set debug to {}
	repeat with fID in folderIds
		set debug to debug & (name of folder id fID) & fID
		
		set ff to folder id fID
		set sub to (id of folders of ff)
		repeat with stuff in sub
			set debug to debug & stuff
		end repeat
		
		set debug to debug & sub
	end repeat
	--return {"debug "} & debug
	
	repeat with fID in folderIds
		set ff to folder id fID
		if (not name of ff = "ƒvŽnements iPhoto") then
			set {myContainers, myContainerNames, pos} to my deepTree("/", ff, {}, myContainers, myContainerNames, pos)
		end if
	end repeat
	
	set nested to (name of albums)
	repeat with fName in nested
		set entry to "ALBUM:" & fName
		set myContainers to myContainers & entry
		set myContainerNames to myContainerNames & (pos & " :" & fName as string)
		set pos to pos + 1
	end repeat
end tell

on deepTree(folderPath, folderFrom, folderHierarchy, fillList, fillListNames, pos)
	tell application "Photos"
		--activate
		
		-- build hierarchy
		set currentH to id of folderFrom & ":" & folderHierarchy
		--my info_event("" & folderPath & "/" & name of folderFrom & "/")
		
		set fillList to fillList & currentH
		set fName to name of folderFrom
		set fillListNames to fillListNames & ("****" & pos & " :" & fName as string)
		set pos to pos + 1
		
		-- // TEMP SKIP
		set nested to id of folders of folderFrom
		repeat with fID in nested
			set {fillList, fillListNames, pos} to my deepTree(folderPath & "/" & fName, folder id fID of folderFrom, currentH, fillList, fillListNames, pos)
		end repeat
		
		-- albums
		set nested to (name of albums of folderFrom)
		repeat with fName in nested
			--set allMedias to (get media items of album fName in folderFrom)
			--my info_event("" & folderPath & "/" & name of folderFrom & "/" & fName & " | " & fName & " | " & (length of allMedias))
			
			--repeat with mediaItem in allMedias
			--	my info_event(filename of mediaItem)
			--end repeat
			--end if
			
			set entry to "ALBUM:" & fName & ":" & currentH --id of folderFrom
			set fillList to fillList & entry -- TODO hierarchy
			set fillListNames to fillListNames & (pos & " :" & fName as string)
			set pos to pos + 1
		end repeat
		
		
	end tell
	return {fillList, fillListNames, pos}
end deepTree


set l to myContainerNames
--set l to unsorted -- sortList(unsorted) -- Leonie



set albNames to choose from list l with prompt "Select some albums" with multiple selections allowed

on getPositionOfItemInList(theItem, theList)
	repeat with a from 1 to count of theList
		set itemA to item a of theList
		if itemA as string = theItem as string then
			return a
		end if
	end repeat
	return 0
end getPositionOfItemInList

tell application "Photos"
	if albNames is not false then -- not cancelled 
		
		
		--set progress total steps to length of albNames
		--set progress completed steps to 0
		--set progress description to "Exporting album..."
		--set myprogress to 0
		
		
		repeat with tName in albNames
			
			--return {"Done :"} & tName
			--return {"Done :"} & my getPositionOfItemInList(tName, myContainerNames)
			set fff to item (my getPositionOfItemInList(tName, myContainerNames)) of myContainers
			-- return {"Done :"} & my split(fff, ":")
			set fffH to my split(fff, ":")
			
			if (item 1 of fffH = "ALBUM") then
				set albumName to item 2 of fffH
				set {theAlbum, thePath} to my getAlbum(fffH)
				
				set newDestName to dest & thePath & "/"
				my makeFolder(newDestName)
				set tFolder to newDestName as POSIX file as text
				
				if orig then
					my log_event(thePath & " | " & length of (get media items of theAlbum))
					with timeout of 120 * 60 seconds -- 120 minutes
						export (get media items of theAlbum) to (tFolder as alias) with using originals
						my log_event(thePath & " | DONE")
					end timeout
				end if
				--return {"Found an album"} & thePath
			else
				--return {"Not an album"} & fffH
			end if
			
		end repeat
		display dialog "DONE"
	end if
end tell

on exportAlbum(albumH, tFolder)
	tell application "Photos"
		set depth to length of albumH
		if (depth = 4) then
			export (get media items of album (item 3 of albumH)) to (tFolder as alias) with using originals
		else if (depth = 5) then
			export (get media items of album (item 3 of albumH) in folder id (item 4 of albumH)) to (tFolder as alias) with using originals
		else if (depth = 6) then
			export (get media items of album (item 3 of albumH) in folder id (item 4 of albumH) in folder id (item 5 of albumH)) to (tFolder as alias) with using originals
		end if
	end tell
end exportAlbum

on getAlbum(albumH)
	tell application "Photos"
		set depth to length of albumH
		if (depth = 4) then
			return {album (item 2 of albumH) in folder id (item 3 of albumH), name of folder id (item 3 of albumH) & "/" & (item 2 of albumH)}
		else if (depth = 5) then
			return {album (item 2 of albumH) in folder id (item 3 of albumH) in folder id (item 4 of albumH), name of folder id (item 4 of albumH) & "/" & name of folder id (item 3 of albumH) in folder id (item 4 of albumH) & "/" & (item 2 of albumH)}
		else if (depth = 6) then
			return {album (item 2 of albumH) in folder id (item 3 of albumH) in folder id (item 4 of albumH) in folder id (item 5 of albumH), name of folder id (item 5 of albumH) & "/" & name of folder id (item 4 of albumH) in folder id (item 5 of albumH) & "/" & name of folder id (item 3 of albumH) in folder id (item 4 of albumH) in folder id (item 5 of albumH) & "/" & (item 2 of albumH)}
			--		else if (depth = 7) then
			--			return album (item 2 of albumH) in folder id (item 3 of albumH) in folder id (item 4 of albumH) in folder id (item 5 of albumH) in folder id (item 6 of albumH)
			--		else if (depth = 8) then
			--			return album (item 2 of albumH) in folder id (item 3 of albumH) in folder id (item 4 of albumH) in folder id (item 5 of albumH) in folder id (item 6 of albumH) in folder id (item 7 of albumH)
		else
			return {album "can't find - " & albumH, "/"}
		end if
	end tell
end getAlbum

to split(someText, delimiter)
	set AppleScript's text item delimiters to delimiter
	set someText to someText's text items
	set AppleScript's text item delimiters to {""} --> restore delimiters to default value
	return someText
end split


tell application "Finder"
	open (tFolder as alias)
	return {"Done: "} & albNames
end tell

on log_event(themessage)
	set yesDo to true
	if yesDo then
		set theLine to (do shell script "date +'%Y-%m-%d %H:%M:%S'" as string) & " | " & themessage
		do shell script "echo \"" & theLine & "\" >> ~/Desktop/photoExporter.log"
	end if
end log_event
on info_event(themessage)
	set yesDo to true
	if yesDo then
		--set theLine to (do shell script "date +'%Y-%m-%d %H:%M:%S'" as string) & " | " & themessage
		set theLine to themessage
		do shell script "echo \"" & theLine & "\" >> ~/Desktop/photoExporterDETAIL.log"
	end if
end info_event

