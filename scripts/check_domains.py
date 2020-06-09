#!/usr/bin/env python
import sys
sys.path.insert(0, '/usr/local/bin')
from __future__ import print_function
from hook import Storage, STORAGE_PATH

domains = sys.argv(1).split(',')
for domain in domains:
    storage = Storage(STORAGE_PATH)
    if not storage.fetch(DOMAIN):
        print('--debug-challenge', end="")
        sys.exit(0)
print('--non-interactive', end="")