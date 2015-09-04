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
from collections import Sequence
import pprint
import blessings

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

_imported = ['os', 'datetime', 'date', 'timedelta', 'pd', 'time', 'np', 'mpl',
'plt', 'gcf', 'gca', 'tight_layout', 'show', 'plot', 'plot_date',
'show', 'decomp', 'partial', 'add', 'itemgetter', 'repeat', 'starmap',
'division', 'print func.'
]

print(
    '\nImported in {}: \n'.format(__file__)+
      '--------\n'+ tabulate(_imported)
)

class ExecTimer(object):
    def __init__(self, ip):
        self.shell = ip
        self.t_pre = time()
        self.texc = 0
        self.prev_texc = 0

    def pre_execute(self):
        self.t_pre = time()

    def post_execute(self):
        self.prev_texc = self.texc
        elap = time() - self.t_pre
        if elap >= 1:
            self.texc = str(round(elap, 1)) + ' s'
        else:
            self.texc = str(int(round(elap*1000,0))) + ' ms'
        res = self.shell.user_ns['_']
        restype = str(type(res))
        if '<class ' in restype:
            resdesc = restype[8:-2]
        elif '<type ' in restype:
            resdesc = restype[7:-2]
        else:
            resdesc = restype
        is_safe_type = lambda obj: isinstance(
            obj,
            (tuple, list, dict, set, basestring, Sequence)
        )
        try:
            if isinstance(res, type):
                pass
            elif hasattr(res, 'shape'):
                resdesc = '{}, shape {}'.format(resdesc, res.shape)
            elif is_safe_type(res) or (hasattr(res, '__len__')
                                       and not hasattr(res, '__iter__')):
                resdesc = '{}, len {}'.format(resdesc, len(res))
        except Exception:
            pass
        # Only add or update user namespace var if it is safe to do so
        self.shell.push({'reslen':resdesc})
        if 'texc' not in self.shell.user_ns or \
                self.shell.user_ns['texc'] == self.prev_texc:
            self.shell.push({'texc': self.texc})
        else:
            pass

    def register(self):
        self.shell.events.register('pre_execute', self.pre_execute)
        self.shell.events.register('post_execute', self.post_execute)

ExecTimer(get_ipython()).register()

# Edit config here instead of in ipython_config.py
get_ipython().run_line_magic(
    'config',
    r"PromptManager.in_template = '{color.Green}{texc}, {reslen}\nIn[\\#]: '"
)
