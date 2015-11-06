#!/usr/bin/env python3

import glob
import os
import re
import sys
import shutil


def myrename(src_filename):
    if os.path.isfile(src_filename):
        filename, extension = os.path.splitext(src_filename)
    elif os.path.isdir(src_filename):
        filename, extension = src_filename, ''

    chars_to_remove = [' ', ',', '(', ')', '[', ']', "'", '!']
    filename = filename.replace('&', 'and')

    for character in chars_to_remove:
        if character in filename:
            filename = filename.replace(character, '.')

    # replace with '-' (hyphen)
    annoying_strings = ['.-.', '.-', '.-', '._.']
    for string in annoying_strings:
        if string in filename:
            filename = filename.replace(string, '-')

    # replace with '_' (underscore)
    annoying_strings = ['_.', '._']
    for string in annoying_strings:
        if string in filename:
            filename = filename.replace(string, '_')

    # filename = filename.replace('..', '.')
    filename = re.sub('\.+', '.', filename)
    filename = re.sub(r'\.$', '', filename)
    filename = re.sub(r'-$', '', filename)

    return filename + extension


def mymove(src_filename, dest_filename):
    print("Moving {} => {}".format(src_filename, dest_filename))
    shutil.move(src_filename, dest_filename)


if __name__ == '__main__':
    filename_list = []

    if len(sys.argv) > 1:
        filename_list = sys.argv[1:]
    else:  # presume all files in cwd
        filename_list = glob.glob('*')

    for filename in filename_list:
        if os.path.exists(filename):
            new_filename = myrename(filename)
            mymove(filename, new_filename)
        else:
            print("{} does't exist".format(filename))
