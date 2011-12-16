#!/usr/bin/env python

import os
import sys

if len(sys.argv) < 5:
  print('Usage: renumber.py prefix digits dest file1 [file2 file3 ...]')
  exit(1)

prefix = sys.argv[1]
digits = int(sys.argv[2])
dest = os.path.abspath(sys.argv[3])
files = sys.argv[4:]
print(files)
for i in range(len(files)):
  if os.path.isfile(files[i]):
    (root, ext) = os.path.splitext(files[i])
    #Debug
    print(files[i], ' to ', '%s/%s%0*d%s' % (dest, prefix, digits, i, ext))

    os.rename(files[i], '%s/%s%0*d%s' % (dest, prefix, digits, i, ext))
