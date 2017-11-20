#!/usr/bin/python
# Filename: using_sys.py

import sys

print 'The command line arguments are:'
argv = ["using_sys.py", "we", "are", "argument"]
for i in sys.argv:
    print i

print '\n\nThe PYTHONPATH is', sys.path, '\n'
