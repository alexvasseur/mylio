#!/bin/bash

S='/Volumes/TBSSD/MYLIO'
SS='2011-2020/2020'
BACKUP='/Volumes/TBSSD/BACKUP'

find "$S/$SS" -type f | grep "\.xmp" | while read F
do
	FB=`basename "$F" .xmp`
	DB=`dirname "$F"`

	FIND=`find "$DB" -name "$FB.*" | grep -v "\.xmp" | egrep -v "jpeg_original|\.avi$|preview.jpeg|\.mpg$|\.mov$|\.png_original$"`
	FINDCOUNT=`find "$DB" -name "$FB.*" | grep -v "\.xmp" | egrep -v "jpeg_original|\.avi$|preview.jpeg|\.mpg$|\.mov$|\.png_original$" | wc -l`
	if [ $FINDCOUNT -gt 1 ]
	then
		echo "ERROR $FB"
		echo "  $FIND"
	elif [ $FINDCOUNT == 0 ]
	then
		echo "  NOTHING" >/dev/null
	else 
		#echo "  XMP with file $FIND"
		STAR=`egrep -c "star1|toile" "$F" | xargs`
		if [ $STAR -gt 0 ]
		then
			echo "$FIND"
			DEST=`realpath "$F" --relative-to="$S"`
			ditto "$F" "$BACKUP/$DEST"
			DEST=`realpath "$FIND" --relative-to="$S"`
			ditto "$FIND" "$BACKUP/$DEST"

			exiftool -P -rating=1 -overwrite_original_in_place "$FIND"
			
			###exiftool -DateTimeOriginal
		fi
	fi
done
exit 0


