#!/usr/bin/env bash

# Test PDFs in a directory for validity.
# The `pdfinfo` command comes from the `xpdf` suite on MacOS (brew install xpdf)

if [ -f goodfiles.out ]
then
	echo "goodfiles.out exists; terminating"
	exit 1
fi

for filename in *.pdf; do
    [ -e "$filename" ] || continue
    if pdfinfo "$filename" > /dev/null 2> /dev/null
    then
        echo "GOOD:" "$filename"
		echo "$filename" >> goodfiles.out
    else
        echo "BAD: " "$filename"
    fi
done
