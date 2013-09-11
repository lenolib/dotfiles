execute pathogen#infect()
syntax on

""From http://sontek.net/blog/detail/turning-vim-into-a-modern-python-ide
filetype on " try to detect filetypes
filetype plugin indent on " enable loading indent file for filetype

set foldmethod=indent
set foldlevel=99
map <leader>td <Plug>TaskList
map <leader>g :GundoToggle<CR>

set tabstop=4
set shiftwidth=4
set expandtab

let g:pyflakes_use_quickfix = 0 " don't use the quickfix window
let g:pep8_map='<leader>8' " jump to pep8 violations in quickfix window

""Enable omnicode completion and set SuperTab to be context sensitive
au FileType python set omnifunc=pythoncomplete#Complete
let g:SuperTabDefaultCompletionType = "context"

map <leader>n :NERDTreeToggle<CR> 

map <leader>j :RopeGotoDefinition<CR>
map <leader>r :RopeRename<CR>

""Ack fuzzy text searching for anything 
""Using ! so as to not open the first result automatically
nmap <leader>a <Esc>:Ack! 

""Display current branch in statusline
"set statusline = 
"set statusline += %{fugitive#statusline()}


""Vim doesn't realize that you are in a virtualenv so it wont 
""give you code completion for libraries only installed there. 
""Add the following script to your ~/.vimrc to fix it:
" Add the virtualenv's site-packages to vim path
py << EOF
import os.path
import sys
import vim
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    sys.path.insert(0, project_base_dir)
    activate_this = os.path.join(project_base_dir,
    'bin/activate_this.py')
    execfile(activate_this, dict(__file__=activate_this))
EOF

""--------END sontek config tips-----------

set number
