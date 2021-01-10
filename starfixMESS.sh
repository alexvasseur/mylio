#!/bin/bash

S='/Volumes/TBSSD/TMP'
D='/Volumes/TBSSD/MYLIO'
DD='2011-2020/2019'

find "$S" -type f | grep "\.xmp" | while read F
do
	echo "$F"
	FB=`basename "$F" .xmp`
	XMP="$FB.xmp"

	#FAV=`grep "toile" "$F" | wc -l | xargs`
	#if [ $FAV -lt 1 ]
	#then
	#	#echo " not fav"
	#	rm "$F"
	#else
	#	echo " FAV"
	#fi

	FDEST=`realpath "$F" --relative-to="$S"`

	#if [ -f "$D/$DD/$FDEST" ]
	#then
		echo "found $D/$DD/$FDEST"
		destDir=`dirname "$S/$FDEST"`
		finalDestDir=`dirname "$D/$DD/$FDEST"`
		#echo cp "$destDir/$XMP" "$finalDestDir"
		cp "$F" "$finalDestDir"
	#else
	#	echo "ERROR not found $F"
	#fi

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

