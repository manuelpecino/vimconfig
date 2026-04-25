" ==============================================================================
" 1. AUTO-INSTALL VIM-PLUG (For seamless setup on new machines)
" ==============================================================================
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" ==============================================================================
" 2. PLUGINS
" ==============================================================================
call plug#begin('~/.vim/plugged')

" File Explorer & Fuzzy Search
Plug 'preservim/nerdtree'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Visuals & Theme
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'

" Coding Utilities
Plug 'tpope/vim-commentary' " Press 'gcc' to comment out a line
Plug 'jiangmiao/auto-pairs' " Auto-closes (), [], {}
Plug 'airblade/vim-gitgutter' " Shows git changes in the left margin

" ------------------------------------------------------------------------------
" NEW: Language Support, Linting, and Autocompletion
" ------------------------------------------------------------------------------
Plug 'sheerun/vim-polyglot'                      " Better syntax highlighting
Plug 'dense-analysis/ale'                        " Auto-formatting and linting
Plug 'neoclide/coc.nvim', {'branch': 'release'}  " VSCode-like Autocompletion

call plug#end()

" ==============================================================================
" 3. SANE DEFAULTS
" ==============================================================================
syntax on                     " Enable syntax highlighting
set number norelativenumber     " Show absolute line numbers only
set noshowmode                " Hide default mode text (Airline handles it)
set tabstop=4                 " 1 tab = 4 spaces
set shiftwidth=4              " Indentation size
set expandtab                 " Convert tabs to spaces
set smartindent               " Auto-indent new lines
set ignorecase smartcase      " Smart case-sensitive search
set noswapfile                " Disable annoying .swp files
set clipboard=unnamedplus     " Use the system clipboard
set cursorline                " Highlight the current line
set termguicolors             " True color support

" ==============================================================================
" 4. THEME CONFIGURATION
" ==============================================================================
set background=dark
" Delay theme loading slightly to prevent errors on first launch
autocmd vimenter * ++nested colorscheme gruvbox 

" ==============================================================================
" 5. CUSTOM KEYBINDINGS
" ==============================================================================
let mapleader = " "

" Toggle File Explorer
nnoremap <leader>n :NERDTreeToggle<CR>
" Fuzzy find files
nnoremap <leader>f :Files<CR>
" Clear highlighted searches
nnoremap <esc> :noh<return><esc>

" ==============================================================================
" 6. LINTING & FORMATTING (ALE)
" ==============================================================================
" Tell ALE which tools to use for which language
let g:ale_linters = {
\   'c': ['clang'],
\   'cpp': ['clang'],
\   'python': ['flake8'],
\   'sh': ['shellcheck'],
\}

" Tell ALE how to format the code automatically
let g:ale_fixers = {
\   'c': ['clang-format'],
\   'cpp': ['clang-format'],
\   'python': ['black'],
\   'sh': ['shfmt'],
\}

" Auto-format every time you save a file!
let g:ale_fix_on_save = 1 

" ==============================================================================
" 7. AUTOCOMPLETION (CoC)
" ==============================================================================
" Use Tab and Shift+Tab to navigate the completion menu
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" GoTo code navigation (Press 'gd' while hovering over a function to jump to it)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
