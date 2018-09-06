# PDFCheck

A couple of quick-and-dirty scripts to check recovered PDFs from Disk Drill.

## Background / Purpose

Disk Drill (and many other file recovery utilities) can often recover files after they have been deleted, but the filenames are typically lost.  This is obnoxious, especially if you have tens of thousands of recovered files to sort through.

However, Disk Drill can also recover files that it *thinks* are PDFs, but actually aren't.

These scripts are designed to help the user:

1. Determine which files, among those having a `.pdf` extension, are likely to be actual PDFs.  This is done using the `pdfinfo` command, part of the `xpdf` suite.
2. Of those presumed-valid PDFs, check for "Title" metadata in the document.
3. Copy valid PDFs to a subdirectory ("VALID"), renaming them using the Title metadata if possible.

Alternately, the `pdfrename.sh` script will rename the files in-place, instead of copying them to a subdirectory.  This is probably not a safe plan.

# pdfcheck.sh

Usage: `./pdfcheck.sh`

This script scans the working directory for PDF files (`.pdf` extension) and uses `pdfinfo` to try and determine whether they are valid.  If they are valid, the filename is added to the `goodfiles.out` list.  If `goodfiles.out` exists when the script is run, it will terminate rather than overwriting the existing file.

# pdfrename.sh

Usage: `pdfrename.sh goodfiles.out`

Takes the list of good PDF files produced by `pdfcheck.sh` and renames them using the Title metadata, if it exists in the document.  Both renamed and un-renamable (but probably valid) PDF files are added to an output list, by default `pdfrename.out`, for further processing if desired. Also produces fairly verbose messages to stdout.

# pdfmove.sh

Usage: `pdfmove.sh goodfiles.out`

Similar to `pdfrename.sh` except instead of renaming the files in place, it *copies* all the valid PDFs (from `goodfiles.out`) to a subdirectory, renaming the ones with Title metadata in the process. This is a safer tool than `pdfrename.sh`.
