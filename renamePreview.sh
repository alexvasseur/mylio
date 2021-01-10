#!/bin/bash

D='/Volumes/BLUESSD/MYLIO'
DD='2000-2010/2010'

find "$D/$DD" -type f | grep "MOV(" | egrep "jpeg$" | while read aF
do
	echo "$aF"
	baseFileName=`basename "$aF" .jpeg`
	inDir=`dirname "$aF"`
	mv "$aF" "$inDir/$baseFileName.preview.jpeg" 
done
exit 0

