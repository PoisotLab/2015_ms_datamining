#! /usr/bin/env python3

with open('bib.keys', 'r') as infile:
    data = infile.read()
my_keys = data.splitlines()

import tammy

l = tammy.library()

l.export(keys=my_keys, path=".", output="citeproc-json")
