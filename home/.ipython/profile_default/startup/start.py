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

    def _last_assignment(self):
        if self._get_last_value() is None:
            last_in = self.shell.user_ns['In'][-1]
            if '=' in last_in:
                varname = last_in.split('=')[0].strip()
                if varname in self.shell.user_ns:
                    return (varname, self.shell.user_ns[varname])
        # Default
        return False

    def _get_last_value(self):
        # Hackish solution for '_' not being set to None if output
        # of last statement actually was None
        if self.shell.execution_count not in self.shell.user_ns['Out']:
            res = None
        else:
            res = self.shell.user_ns['_']

        return res

    def _get_description(self, value):
        has_len_but_not_iter = lambda v:(
            hasattr(v, '__len__') and not hasattr(v, '__iter__')
        )
        desc = str(type(value)) if value is not None else 'None'
        if '<class ' in desc:
            desc = desc[8:-2]
        elif '<type ' in desc:
            desc = desc[7:-2]
        try:
            safe_types = (tuple, list, dict, set, basestring, Sequence)
            if isinstance(value, type):
                pass
            elif hasattr(value, 'shape'):
                desc = '{}, shape {}'.format(desc, value.shape)
            elif isinstance(value, safe_types) or has_len_but_not_iter(value):
                desc = '{}, len {}'.format(desc, len(value))
        except Exception:
            pass
        return desc

    def post_execute(self):
        self.prev_texc = self.texc
        elap = _time() - self.t_pre
        if elap >= 1:
            self.texc = str(round(elap, 1)) + ' s'
        else:
            self.texc = str(int(round(elap*1000,0))) + ' ms'
        assignment = self._last_assignment()
        lastval = assignment[1] if assignment else self._get_last_value()
        desc = self._get_description(lastval)
        if assignment:
            desc = "Assigned '{}', {}".format(assignment[0], desc)
        # Only add or update user namespace var if it is safe to do so
        self.shell.push({'_last_value_desc': desc})
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
        txt = '{t}, {last_desc}\nIn[{n}]: '.format(
           t=self.shell.user_ns.get('texc'),
           last_desc=self.shell.user_ns.get('_last_value_desc'),
           n=self.shell.execution_count,
        )
        return [(Token.Prompt, txt)]


ExecTimer(get_ipython()).register()
get_ipython().prompts = InfoPrompt(get_ipython())
