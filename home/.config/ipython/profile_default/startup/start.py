from datetime import datetime, timedelta, date
import os
import pandas as pd
from time import time
import numpy as np
import matplotlib as mpl
from matplotlib.pyplot import plot, show, tight_layout, plot_date, gcf, gca
import matplotlib.pyplot as plt
try:
    from utils.base import decomp
except ImportError:
    print('Could not find utils, skippin decomp import')
from functools import partial
from operator import add, itemgetter
from itertools import repeat, starmap
import pprint
pp = pprint.pprint
values_as_their_types = lambda dictionary: dict(map(
    lambda (k, v): (k, type(v)),
    dictionary.iteritems(),
))
pd.set_option('display.width', None)  # Detect terminal width
DF = pd.DataFrame
S = pd.Series
globals0 = values_as_their_types(globals())
def gdiff():
    new_globals = values_as_their_types(globals())
    keydiff = set(new_globals.keys()) - set(globals0.keys())
    diff = dict(filter(
        lambda (k, v): k in keydiff,
        new_globals.iteritems()
    ))

    return diff

print(
    '\nImported in {}: \n'.format(__file__)+
    '--------\n'+
    ' '.join([
        'os', 'datetime', 'date', 'timedelta', 'pd', 'time', 'np', 'mpl',
        'plt', 'gcf', 'gca', 'tight_layout', 'show', 'plot', 'plot_date',
        'show', 'decomp', 'partial', 'add', 'itemgetter',
        'repeat', 'starmap', '(division, print_function)'
    ])
)
