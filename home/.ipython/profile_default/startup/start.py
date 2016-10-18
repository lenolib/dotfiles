from datetime import datetime, timedelta, date

import os
import sys

from IPython.terminal.prompts import Prompts, Token

import numpy as np
import pandas as pd
import matplotlib as mpl

from matplotlib.pyplot import plot, show, tight_layout, plot_date, gcf, gca
import matplotlib.pyplot as plt

from time import time
from time import time as _time  # Used here, avoids problems if overwritten
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

class ExecTimer(object):
    def __init__(self, ip):
        self.shell = ip
        self.t_pre = _time()
        self.texc = 0
        self.prev_texc = 0

    def pre_execute(self):
        self.t_pre = _time()

    def post_execute(self):
        self.prev_texc = self.texc
        elap = _time() - self.t_pre
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

class InfoPrompt(Prompts):
    def in_prompt_tokens(self, cli=None):
        txt = '{t}, {reslen}\nIn[{n}]: '.format(
           t=self.shell.user_ns['texc'],
           reslen=self.shell.user_ns['reslen'],
           n=self.shell.execution_count,
        )
        return [(Token.Prompt, txt)]

ExecTimer(get_ipython()).register()
get_ipython().prompts = InfoPrompt(get_ipython())
