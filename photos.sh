#!/bin/bash

R='/Volumes/BLUESSD/MYLIO'
#R='/Volumes/BLUESSD/MYLIO/Événements iPhoto'
#R='/Volumes/BLUESSD/PHOTOS/Événements iPhoto'

## report size
find "$R" -type d | while read F
do
	CountF=`ls "$F" | grep -v ".xmp" | wc -l | xargs`
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

