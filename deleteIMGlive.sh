#!/bin/bash

D='/Volumes/TBSSD'
DD='TMP' #2011-2020/2016

find "$D/$DD" -type f | egrep "/IMG_.*\.mov" | while read aF
do
	echo "$aF"
	baseFileName=`basename "$aF" .mov`
	inDir=`dirname "$aF"`
	if [ -f "$inDir/$baseFileName.jpeg" ]
	then
		rm "$inDir/$baseFileName.mov"
		echo "  deleted"
	fi
done
exit 0

