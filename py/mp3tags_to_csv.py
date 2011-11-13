#!/usr/bin/env python2.7
# vim: set tabstop=4 shiftwidth=4 :


__doc__ = """
A script that takes reads the ID3 tag data from a collection of MP3 files and
stores the data in a CSV file. Any empty tags will be written as '' to the CSV
file.

Usage: mp3tags_to_csv.py [optional options] -f files

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
from argparse import ArgumentParser
from os import path
import sys


# List of possible ID3 tags to record.
allowed_tags = ['artist', 'genre', 'title']


# Open a file for writing, prompting the user if it already exists.
def open_file_to_write(file_name):
    """
    Opens file for writing, prompting for if a use wishes to overwrite an
    existing file.

    Args:
        file_name: The name of the file to open.

    Returns:
        A file object pointing to the opened file if successful. None
        otherwise.
    """
    # If the path is a directory, abort.
    if path.isdir(file_name):
        print 'Filename %s refers to a currently existing directory. Aborting.'
        return None
    # If the file already exists make sure the user wants to overwrite.
    if path.isfile(file_name):
        while True:
            ans = raw_input('File %s currently exists. Overwrite? (y/n): ')
            if ans in ['y', 'Y']:
                break
            elif ans in ['n', 'N']:
                return None
    return open(file_name, 'w')


# Create argument parser.
def parse_args():
    """
    Parse input arguments into a list of tags and a list of files. Assumes
    that the flag corresponding to a tag is '-' followed by the first letter of
    the tag.

    Returns: (flags, files)
        tags: A list of the tags for which flags were passed in.
        ofile_name: A string with the output file name.
        ifile_paths: A list of the input filenames passed in.
    """
    tags = []
    ofile_name = 'output.csv'
    ifile_paths = []
    if len(sys.argv) < 2:
        print 'Too few arguments.'
        sys.exit()
    if sys.argv[1] == '--help' or sys.argv[1] == '--h':
        print __doc__
        sys.exit()
    for j in xrange(1,len(sys.argv)):
        arg = sys.argv[j]
        if arg == '-o':
            ofile_name = sys.argv[j + 1] if len(sys.argv) > j else None
            if ofile[0] == '-' or ofile is None:
                print 'No output file specified.'
                sys.exit()
        if arg[0] == '-':
            for i in xrange(len(allowed_tags)):
                if arg[1] == allowed_tags[i][0]:
                    tags.append(allowed_tags[i])
        else:
            ifile_paths.append(arg)
    return (tags, ofile_name, ifile_paths)


# Parse options.
(tags, ofile_name, ifile_paths) = parse_args()
if ifile_paths is None:
    print "No input files specified so there's nothing to do. Exiting."
    sys.exit()
# Set up output file for writing.
ofile = open_file_to_write(path.abspath(ofile_name))
if ofile is None:
    sys.exit()
ofile.write('filename')
for i in xrange(len(tags)):
    ofile.write(', %s' % tags[i])
ofile.write('\n')

# Iterate over input files, writing their filename and tags.
for ifile_path in ifile_paths:
    for ifile_name in iglob(ifile_path):
        # Ignore non-MP3 files.
        (ifile_root, ifile_ext) = path.splitext(ifile_name)
        if ifile_ext.lower() != '.mp3':
            continue
        # Write filename and rest of fields separated by commas.
        ofile.write(ifile_name)
        ifile = EasyID3(path.abspath(ifile_name))
        for tag in tags:
            try:
                tag_string = ifile[tag][0]
            except KeyError:
                 tag_string = ''
            ofile.write(', %s' % tag_string)
        ofile.write('\n')
ofile.close()
print 'Done.'
