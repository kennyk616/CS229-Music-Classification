#!/usr/bin/env python2.7
# vim: set tabstop=4 shiftwidth=4 :


__doc__ = """
A script that takes reads the genre data for a collection of AU files from the
folders the files are in. So a file in the folder 'abcd/file.au' will be
identified as genre 'abcd'. The script stores the filename and genre data in a
CSV file.

Usage: gztan_to_csv.py [options] files

Options:
    -o outputfile.csv: The output CSV file to write to. output.csv by default.

Files: 
    Cannot start with '-'. Can be any list of files or wildcard expressions
    that evaluate to files (ie '/path/to/file/*.suffix'). The script will only
    attempt to read the tags of MP3 files.

Defaults:
    The output goes to output.csv by default.
"""


from glob import iglob
from os import path
import sys

from lib229 import open_file_to_write
from lib229 import parse_args


# List of possible ID3 tags to record.
allowed_tags = ['genre']


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
ofile.write('filename')
for i in xrange(len(allowed_tags)):
    ofile.write('|%s' % allowed_tags[i])
ofile.write('\n')

# Iterate over input files, writing their filename and genre.
for ifile_path in ifile_paths:
    for ifile_name in iglob(ifile_path):
        # Ignore non-AU files.
        (ifile_root, ifile_ext) = path.splitext(ifile_name)
        if ifile_ext.lower() != '.au':
            continue
        # Write filename and rest of fields separated by commas.
        ofile.write(path.abspath(ifile_name))
        ifile_dir = path.dirname(path.abspath(ifile_name)).split(path.sep)
        ifile_dir = ifile_dir[-1]
        ofile.write('|' + ifile_dir)
        ofile.write('\n')
ofile.close()
print 'Done.'
