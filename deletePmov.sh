#!/bin/bash

D='/Volumes/TBSSD/TMP'
DD='' #2011-2020/2016

find "$D/$DD" -type f | egrep "/P.*\.mov" | while read aF
do
	echo "$aF"
	baseFileName=`basename "$aF" .mov`
	inDir=`dirname "$aF"`
	if [ -f "$inDir/$baseFileName.jpeg" ]
	then
		echo rm "$inDir/$baseFileName.jpeg"
		echo "  deleted"
	fi
done
exit 0

