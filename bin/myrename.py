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

dst_filename, dst_extension = os.path.splitext(src_filename)

chars_to_remove = [' ', ',', '(', ')', '[', ']', ]

for character in chars_to_remove:
    if character in dst_filename:
        dst_filename = dst_filename.replace(character, '.')

dst_filename = dst_filename.replace('..', '.')
dst_filename = re.sub('\.$', '', dst_filename)

print("Moving {} => {}".format(src_filename, dst_filename + dst_extension))
shutil.move(src_filename, dst_filename + dst_extension)
