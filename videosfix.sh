#!/bin/bash

S='/Volumes/TBSSD/TMPvideo'
D='/Volumes/TBSSD/MYLIO'
DD='2011-2020/2020'

#find "$D/$DD" -type f | grep "\.mov" | while read F
ls "$S" | grep "\.xmp" | while read F
do
	#echo "$F"
	FB=`basename "$F" .xmp`

	FIND=`find "$D/$DD" -name "$FB.*" | grep -v jpeg | grep -v xmp`
	if [ "x$FIND" != "x" ]
	then 
		destDir=`dirname "$FIND"`	
		cp "$S/$F" "$destDir"
		echo "  FIXED $FIND"
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

