#!/bin/bash

D='/Volumes/TBSSD/MYLIO'
DD='2011-2020/2019'
TESTFOR="2019"

find "$D/$DD" -type d | while read d
do
	echo "TEST $d"
	previous=""
	noPrevious=()
		echo $d
		ls -tr "$d/" | grep -v "\.xmp" | grep -v "\.avi" | grep -v "\.mpg" | grep -v "\.mov" | grep -v "\.m4v" | grep -v "mp4" | while read aF
		do
			echo "$aF"
			year=`exiftool -DateTimeOriginal "$d/$aF" | cut -d':' -f2`
			if [ "$year" == " $TESTFOR" ] # there is a space
			then
				previous="$aF"
				# flush noPrevious
				for failed in "${noPrevious[@]}"
				do
					echo "purging $failed with $aF - $d"
					exiftool -TagsFromFile "$d/$aF" -AllDates "$d/$failed"
				done
				noPrevious=()
			else	
				if [ "$previous" != "" ]
				then
					echo "FIX $aF with $previous - $year - $d"
					exiftool -TagsFromFile "$d/$previous" -AllDates "$d/$aF" 
				else
					echo "FIX failed, no previous for $aF - $d"
					noPrevious=("${noPrevious[@]}" "$aF")
				fi
			fi
		done
done
exit 0


ls "$S" | grep -v "\.xmp" | while read F
do
	echo "$F"
	FB=`basename $F .avi`
	XMP="$FB.xmp"

	FIND=`find "$D/$DD" -name $F`
	if [ `basename "$FIND" .avi` = $FB ]
	then
		cp "$S/$XMP" "`dirname "$FIND"`"
		echo "  FIXED $FIND"
	fi
done
exit

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

