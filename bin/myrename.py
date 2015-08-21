#!/usr/bin/env python3

import sys
import shutil
import re
import os

if len(sys.argv) > 1:
    src_filename = sys.argv[1]
else:
    print("Please supply filename")
    sys.exit()

if not os.path.exists(src_filename):
    print("{} does't exist".format(src_filename))
    sys.exit()

if os.path.isfile(src_filename):
    dst_filename, dst_extension = os.path.splitext(src_filename)
elif os.path.isdir(src_filename):
    dst_filename, dst_extension = src_filename, ''

chars_to_remove = [' ', ',', '(', ')', '[', ']', "'", '!']
dst_filename = dst_filename.replace('&', 'and')

for character in chars_to_remove:
    if character in dst_filename:
        dst_filename = dst_filename.replace(character, '.')

# replace with '-' (hyphen)
annoying_strings = ['.-.', '.-', '.-', '._.']
for string in annoying_strings:
    if string in dst_filename:
        dst_filename = dst_filename.replace(string, '-')

# replace with '_' (underscore)
annoying_strings = ['_.', '._']
for string in annoying_strings:
    if string in dst_filename:
        dst_filename = dst_filename.replace(string, '_')

dst_filename = dst_filename.replace('..', '.')
dst_filename = re.sub(r'\.$', '', dst_filename)
dst_filename = re.sub(r'-$', '', dst_filename)

print("Moving {} => {}".format(src_filename, dst_filename + dst_extension))
shutil.move(src_filename, dst_filename + dst_extension)
