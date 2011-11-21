# Usefil common functions for python scripts.
# vim: set shiftwidth=4 tabstop=4 :


from os import path
import sys


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


# Parse arguments.
def parse_args(doc, allowed_tags=[]):
    """
    Parse input arguments into a list of tags and a list of files. Assumes
    that the flag corresponding to a tag is '-' followed by the first letter of
    the tag.

    Args:
        doc: The desired output when the '--help' argument is used.
        allowed_tags: The tags we accept in the command line. ie 'artist',
        'genre', etc.

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
        print doc
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
