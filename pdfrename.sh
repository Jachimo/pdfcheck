#!/usr/bin/env bash

# Rename PDF files based on metadata
#  Useful for when PDFs have been recovered using Disk Drill
#  but the original filenames have been lost.
# 
# The input file should be a list of files to process,
# with one filename per line, delimited with LFs; this is
# the format produced by the "pdfcheck.sh" script, when run
# as `./pdfcheck.sh | grep GOOD | cut -f2 -d' ' > goodfiles.out`

inputfile="$1"

# Prepare log file - clear it if it exists!
logfile='pdfrename.out'
:> "$logfile"

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
		
		if [ ! -f "$newname" ]
		then
			mv "$f" "$newname"
			echo "RENAMED: $f TO $newname; adding to $logfile"
			echo "$newname" >> "$logfile"
		else
			echo "EXISTS: $f to $newname failed; file already exists"
		fi
	else
		echo "SKIPPED: $f is a valid PDF but lacks title metadata, adding to $logfile"
		echo "$f" >> "$logfile"
	fi	
done
