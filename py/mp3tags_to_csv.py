#!/usr/bin/env python2.7
# vim: set tabstop=4 shiftwidth=4 :


__doc__ = """
A script that takes reads the ID3 tag data from a collection of MP3 files and
stores the data in a CSV file. Any empty tags will be written as '' to the CSV
file.

Usage: mp3tags_to_csv.py [options] files

Options:
    -a: Include artist field in CSV file. False by default.
    -g: Include genre field in CSV file. False by default.
    -t: Include title field in CSV file. False by default.
    -o outputfile.csv: The output CSV file to write to. output.csv by default.

Files: 
    Cannot start with '-'. Can be any list of files or wildcard expressions
    that evaluate to files (ie '/path/to/file/*.suffix'). The script will only
    attempt to read the tags of MP3 files.

Defaults:
    The output goes to output.csv by default. No tags are parsed by default (so
    if you don't want to waste time you should specify what tags you want).
"""


from glob import iglob
from mutagen.easyid3 import EasyID3
from os import path
import sys

from lib229 import open_file_to_write
from lib229 import parse_args


# List of possible ID3 tags to record.
allowed_tags = ['artist', 'genre', 'title']


# Parse options.
(tags, ofile_name, ifile_paths) = parse_args(__doc__, allowed_tags)
if ifile_paths is None:
    print "No input files specified so there's nothing to do. Exiting."
    sys.exit()
# Set up output file for writing.
ofile = open_file_to_write(path.abspath(ofile_name))
if ofile is None:
    print 'Unable to open output file.'
    sys.exit()
ofile.write('filename')
for i in xrange(len(tags)):
    ofile.write('|%s' % tags[i])
ofile.write('\n')

# Iterate over input files, writing their filename and tags.
for ifile_path in ifile_paths:
    for ifile_name in iglob(ifile_path):
        # Ignore non-MP3 files.
        (ifile_root, ifile_ext) = path.splitext(ifile_name)
        if ifile_ext.lower() != '.mp3':
            continue
        # Write filename and rest of fields separated by commas.
        ofile.write(path.abspath(ifile_name))
        ifile = EasyID3(path.abspath(ifile_name))
        for tag in tags:
            try:
                tag_string = ifile[tag][0]
            except KeyError:
                 tag_string = ''
            ofile.write('|%s' % tag_string)
        ofile.write('\n')
ofile.close()
print 'Done.'
