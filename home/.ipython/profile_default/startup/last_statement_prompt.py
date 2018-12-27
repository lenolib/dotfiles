from __future__ import division, print_function

from IPython.terminal.prompts import Prompts, Token
from time import time as _time


class LastStatementDescriberPrompt(object):
    """
    This class provides a more informative ipython prompt:
    - Times last statement
    - Brief description of last statement result (also works for assignments)
    
    Examples:
    ---------
    In[1]: j=range(9)

    2 ms, Assigned 'j', list, len 9
    In[2]: 'hi'
    Out[2]: 'hi'

    6 ms, str, len 2
    In[3]:


    Installation
    ------------
    Drop this file into ~/.ipython/profile_default/startup/
    It should get run automatically at ipython startup
    """
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
            safe_types = (tuple, list, dict, set, str, Sequence)
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

    def install(self):
        class InfoPrompt(Prompts):
            def in_prompt_tokens(self, cli=None):
                txt = '{t}, {last_desc}\nIn[{n}]: '.format(
                   t=self.shell.user_ns.get('texc'),
                   last_desc=self.shell.user_ns.get('_last_value_desc'),
                   n=self.shell.execution_count,
                )
                return [(Token.Prompt, txt)]

        self.register()
        self.shell.prompts = InfoPrompt(self.shell)


LastStatementDescriberPrompt(get_ipython()).install()
