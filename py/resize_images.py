#!/usr/bin/env python2.7
__doc__ = """
An image resize script that crops all images in the input folder to squares,
and then resizes them to SCALE_TO by SCALE_TO dimensions.

Usage:
  resize_image.py /dir/with/pics /dir/to/store/pics [SCALE_TO]

Args:
  -The directory containing images to crop/scale.
  -The directory in which to store resized images.
  -Value for SCALE_TO (default is 64).

Note: Adapted from a script by 'Osure Ronald O. :: R - Labs (c) 2010' posted at
http://www.daniweb.com/software-development/python/code/311214.
 
"""
 

from PIL import Image
import glob,os,sys

 
EXT_SUFFIX = '-small' #Resized image file name suffix before extension name example, xxy-rlabs.png
SCALE_TO = 64 #Size to scale to (sidelength of square image)
IMG_EXTENSIONS = ['*.jpg','*.JPG','*.png','*.PNG'] #Add your image extension types here

 
def get_crop_box(img_object,filename):
  i_width, i_height = img_object.size

  new_dim = min(i_width, i_height)

  #Debug
  print('%s cropped from: (%d,%d) to -> (%d,%d)' % (infile, i_width, i_height,
    new_dim, new_dim));

  return (0, 0, new_dim, new_dim)

 
if __name__=='__main__':
  if len(sys.argv) != 3 and len(sys.argv) != 4:
    print(__doc__);
    sys.exit(1)

  if len(sys.argv) == 4:
    SCALE_TO = int(sys.argv[3])

  files = []
  os.chdir(sys.argv[1])
  for w in IMG_EXTENSIONS:
    files.extend(glob.glob(w))
  #Get absolute path
  path_to_store = os.path.abspath(sys.argv[2])
  #Append separator
  path_to_store = path_to_store+os.path.sep

  for infile in files:
    try:
      img = Image.open(infile)
    except IOError:
      print('Could not open file: %s', infile);
      continue

    crop_box = get_crop_box(img, infile)
    cropped_img = img.crop(crop_box)
    
    resized_img = cropped_img.resize((SCALE_TO, SCALE_TO))

    #Debug
    print('%s resized from: (%d,%d) to -> (%d,%d)' % (infile, crop_box[3],
      crop_box[2], SCALE_TO, SCALE_TO));

    filename,ext = os.path.splitext(infile)
    resized_img.save(path_to_store+filename.lower()+EXT_SUFFIX+ext)
