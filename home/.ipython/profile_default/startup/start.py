from datetime import datetime, timedelta, date

import os
import sys

try:
    import numpy as np
    import pandas as pd
    import matplotlib as mpl

    from matplotlib.pyplot import plot, show, tight_layout, plot_date, gcf, gca
    import matplotlib.pyplot as plt
    import pprint

    pd.set_option("display.width", None)  # Detect terminal width

    pp = pprint.pprint
    DF = pd.DataFrame
    stamp = pd.Timestamp
    S = pd.Series
    fig = plt.figure
    DT = datetime
    tdel = timedelta
except ImportError as ie:
    print("Could not import %s" % ie)

try:
    import blessings
except ImportError as ie:
    print("Could not import %s" % ie)

from time import time
from functools import partial
from operator import add, itemgetter, attrgetter
from itertools import repeat, starmap
from collections import defaultdict, OrderedDict
from collections.abc import Sequence, Iterable, Sized
from numbers import Number
from decimal import Decimal as _Decimal


# import pudb.ipython, pudb.lowlevel
# pudb.lowlevel.detect_encoding = lambda _: ('utf-8', [])


values_as_their_types = lambda dictionary: {k: type(v) for (k, v) in dictionary.items()}
_globals0 = values_as_their_types(globals())


def gdiff():
    new_globals = values_as_their_types(globals())
    keydiff = set(new_globals.keys()) - set(_globals0.keys())
    diff = {k: v for (k, v) in new_globals.items() if k in keydiff}

    return diff


def tabulate(words, termwidth=79, pad=3):
    width = len(max(words, key=len)) + pad
    ncols = max(1, termwidth // width)
    nrows = (len(words) - 1) // ncols + 1
    table = []
    for i in range(nrows):
        row = words[i::nrows]
        format_str = ("%%-%ds" % width) * len(row)
        table.append(format_str % tuple(row))
    return "\n".join(table)


def decomp(obj, depth=5, length=8, indent=0, index=""):
    """Print a recursive decomposition of an collection object down to [depth]

    Example
    -------
    >>> my_collection = [('foo',3), 4, [1,3]]
    >>> decomp(my_collection)
    list (3)
      tuple (2)    #0
        str (3)    #0 --> 'foo'
        int    #1 --> 3
      int    #1 --> 4
      list (2)    #2
        int    #0 --> 1
        int    #1 --> 3

    """

    def OUTPUT(*text):  # TODO sanitize argument from spurious newlines
        print(*text, end="")

    DISPLAY_AS_IS_TYPES = (Number, _Decimal, date)
    if depth == 0:
        OUTPUT(" " * indent, "[depth limit reached]" + "\n")
        return
    if length < 0:
        length = 0

    # Extract the type
    name = type(obj).__name__
    if type(obj).__module__ != "__builtin__":
        name = ".".join([type(obj).__module__, name])

    # Print it
    OUTPUT("".join([" " * indent, name]))

    # Display the object size, if any
    if isinstance(obj, Sized):
        OUTPUT(" (%i)" % len(obj))
    OUTPUT(index)
    # Display part or complete object for certain types
    if isinstance(obj, str):
        OUTPUT(" -->", "'%s'" % obj[:20])
        if len(obj) > 20:
            OUTPUT("...")
        OUTPUT("\n")
        return
    elif isinstance(obj, DISPLAY_AS_IS_TYPES):
        OUTPUT(" -->", obj, "\n")
        return

    # Possibly stop recursion
    if not isinstance(obj, Sized):
        if isinstance(obj, Iterable):  # We can't inspect the length
            OUTPUT("(Iterable but not Sized)")
        OUTPUT(index + "\n")
        return

    # Decompose approriate subitems recursively down to depth_limit
    if isinstance(obj, Iterable) and isinstance(obj, Sized):
        # TODO adapt for mappings (key,value)
        if len(obj) > length:
            OUTPUT(" [only showing first %i]" % length)
        OUTPUT("\n")

        # Decompose the first few items in sized iterables
        for index, item in zip(range(min(len(obj), length)), obj):
            decomp(
                item,
                depth=depth - 1,
                length=length - 2,
                indent=indent + 2,  # Increase indentation by 2 <-- MAGIC
                index="    #{}".format(index),
            )


_imported = [
    "os",
    "sys",
    "datetime",
    "date",
    "timedelta",
    "pd",
    "time",
    "np",
    "mpl",
    "plt",
    "gcf",
    "gca",
    "tight_layout",
    "show",
    "plot",
    "plot_date",
    "show",
    "decomp",
    "partial",
    "add",
    "itemgetter",
    "attrgetter",
    "repeat",
    "starmap",
    "division",
    "print func.",
]

print("\nImported in {}: \n".format(__file__) + "--------\n" + tabulate(_imported))
