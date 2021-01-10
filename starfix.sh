#!/bin/bash

S='/Volumes/TBSSD/TMPstars'
D='/Volumes/TBSSD/MYLIO'
DD='2011-2020/2020'

ls "$S" | grep "\.xmp" | while read F
do
	#echo "$F"
	FB=`basename "$F" .xmp`

	FIND=`find "$D/$DD" -name "$FB.*" | grep -v "\.xmp" | grep -v "jpeg_original"`
	FINDCOUNT=`find "$D/$DD" -name "$FB.*" | grep -v "\.xmp" | grep -v "jpeg_original" | wc -l`
	if [ "x$FIND" != "x" ]
	then
		if [ $FINDCOUNT -gt 1 ]
		then
			echo "ERROR $FB"
			echo "$FIND"
		else 
			destDir=`dirname "$FIND"`	
			cp "$S/$F" "$destDir"
			echo "  FIXED $FIND"
		fi
	fi
done
exit 0

## report size
ls "$R" | while read F
do
	CountF=`ls "$R/$F" | wc -l | xargs`
	echo "$F | $CountF"
	#if [ $CountF == 0 ]
	#then
	#	rmdir "$R/$F"
	#else
	#	echo "Found $R/$F"
	#fi
done





exit 0

## find issue
cat photoExporter.log | grep -v DONE | while read l
do
	F=`echo $l | cut -d'|' -f2 | xargs | cut -d'/' -f2`
	Count=`echo $l | cut -d'|' -f3 | xargs`
	
	CountF=`ls "$R/$F" | wc -l | xargs`

 	if [ "$CountF" != "$Count" ]
	then
		echo "$F"
	fi	

done

