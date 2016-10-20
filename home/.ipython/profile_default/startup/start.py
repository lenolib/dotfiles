from datetime import datetime, timedelta, date

import os
import sys

import numpy as np
import pandas as pd
import matplotlib as mpl

from matplotlib.pyplot import plot, show, tight_layout, plot_date, gcf, gca
import matplotlib.pyplot as plt

from time import time
from functools import partial
from operator import add, itemgetter, attrgetter
from itertools import repeat, starmap
from collections import Sequence
import pprint
import blessings

try:
    from liteutils.base import decomp
except ImportError:
    print('Could not find liteutils, skippin decomp import')

#import pudb.ipython, pudb.lowlevel
#pudb.lowlevel.detect_encoding = lambda _: ('utf-8', [])


pd.set_option('display.width', None)  # Detect terminal width

pp = pprint.pprint
DF = pd.DataFrame
stamp = pd.Timestamp
S = pd.Series
fig = plt.figure
DT = datetime
tdel = timedelta


values_as_their_types = lambda dictionary: dict(map(
    lambda (k, v): (k, type(v)),
    dictionary.iteritems(),
))
_globals0 = values_as_their_types(globals())
def gdiff():
    new_globals = values_as_their_types(globals())
    keydiff = set(new_globals.keys()) - set(_globals0.keys())
    diff = dict(filter(
        lambda (k, v): k in keydiff,
        new_globals.iteritems()
    ))

    return diff

def tabulate(words, termwidth=79, pad=3):
    width = len(max(words, key=len)) + pad
    ncols = max(1, termwidth // width)
    nrows = (len(words) - 1) // ncols + 1
    table = []
    for i in xrange(nrows):
        row = words[i::nrows]
        format_str = ('%%-%ds' % width) * len(row)
        table.append(format_str % tuple(row))
    return '\n'.join(table)

_imported = ['os', 'sys', 'datetime', 'date', 'timedelta', 'pd', 'time', 'np', 'mpl',
'plt', 'gcf', 'gca', 'tight_layout', 'show', 'plot', 'plot_date',
'show', 'decomp', 'partial', 'add', 'itemgetter', 'attrgetter', 'repeat', 'starmap',
'division', 'print func.'
]

print(
    '\nImported in {}: \n'.format(__file__)+
      '--------\n'+ tabulate(_imported)
)
