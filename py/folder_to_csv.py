#!/usr/bin/env python2.7
# vim: set tabstop=4 shiftwidth=4 :


__doc__ = """
A script that stores the (path|filename) of all files in a given folder in a
CSV file.

Usage: folder_to_csv.py [options] folder

Options:
    -o outputfile.csv: The output CSV file to write to. output.csv by default.

Defaults:
    The output goes to output.csv by default.
"""


from glob import iglob
from os import path
import sys

from lib229 import open_file_to_write
from lib229 import parse_args


ALLOWED_EXTENSIONS = ['.jpg', '.png']


# Parse options.
(tags, ofile_name, ifile_paths) = parse_args(__doc__)
if ifile_paths is None:
    print "No input files specified so there's nothing to do. Exiting."
    sys.exit()
# Set up output file for writing.
ofile = open_file_to_write(path.abspath(ofile_name))
if ofile is None:
    print 'Unable to open output file.'
    sys.exit()
ofile.write('path|filename')

# Iterate over input files, writing their filename and genre.
for ifile_path in ifile_paths:
    for ifile_name in iglob(ifile_path):
        # Ignore directories
        if not path.isfile(ifile_name):
            continue
        # Ignore files with incorrect extension.
        (ifile_root, ifile_ext) = path.splitext(ifile_name)
        if ifile_ext.lower() not in ALLOWED_EXTENSIONS:
            continue
        # Write path and filename to output file.
        ofile.write(path.abspath(ifile_name))
        ofile.write('|')
        ofile.write(path.basename(ifile_name))
        ofile.write('\n')
ofile.close()
print 'Done.'
