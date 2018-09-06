#!/usr/bin/env bash
#  Move PDF files, renaming them if possible based on metadata
#  Usage:  ./pdfmove.sh goodfiles.out
#   goodfiles.out is the output from the `pdfcheck.sh` script

inputfile="$1"
destdir="VALID"

# Create dest dir
mkdir -p "$destdir"

cat "$inputfile" | while read f; do
	if [ ! -f "$f" ]
	then
		echo "ERROR: $f does not exist"
		continue
	fi
	
	echo "INFO: Processing $f"
	
	# Retrieve title if it exists...
	meta_title=$(\
		pdfinfo "$f" |\
		grep 'Title:' |\
		cut -f2 -d':' |\
		sed -e 's/^[[:space:]]*//'|\
		sed -e 's/[[:space:]]*$//'\
	)
	
	if [ -n "$meta_title" ]
	then
		# PDF title can be very long, cut to 32 chars max, spaces to underscores
		truncname=$(\
			echo "$meta_title" |\
			tr '[:space:]' '_' |\
			cut -c 1-32\
		)
		newname=$(printf '%s.pdf' "$truncname")
		
		if [ ! -f "$destdir"/"$newname" ]
		then
			cp "$f" "$destdir"/"$newname"
			echo "INFO: $f now $newname; copied to $destdir"
		else
			echo "ERROR: Copy $f to $destdir/$newname skipped; file already exists"
		fi
	else
		cp "$f" "$destdir"
		echo "WARN: $f is a valid PDF but lacks title metadata, copying to $destdir"
	fi	
done
