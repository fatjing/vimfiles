" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" activate pathogen
runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

filetype plugin indent on
syntax on

set guioptions=
set mouse=a

"set background=dark
"let base16colorspace=256
color base16-tomorrow

if has('gui_win32')
    set guifont=Consolas:h10.5
    set guifontwide=Microsoft\ YaHei\ Mono:h10.5
elseif has('gui_gtk2')
    set guifont=Inconsolata\ 12
    set guifontwide=WenQuanYi\ Micro\ Hei\ Mono\ 12
endif

set visualbell
set ttyfast

set nobackup
set noswapfile
"au FocusLost * :wa    " save on losing focus
"set undofile
set history=5000    " cmdline history

set hidden    " allow buffer switching without saving

set backspace=indent,eol,start
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
set nrformats-=octal

set encoding=utf-8
set fileformats=unix,dos

set tabstop=4       " number of spaces per tab for display
set shiftwidth=4    " number of spaces to use for each step of (auto)indent
set softtabstop=4   " number of spaces per tab in insert mode
set expandtab       " in insert mode: use spaces to insert a <Tab>
set autoindent      " automatically indent to match adjacent line

" text formatting
set formatoptions+=j
if has('multi_byte')
    set fo+=mM
endif
"set textwidth=78
"set colorcolumn=85

set scrolloff=3
set sidescrolloff=7
set display+=lastline

set showmode    " show current mode down the bottom
set showcmd     " show incomplete cmds down the bottom
set wildmenu    " enable ctrl-n and ctrl-p to scroll thru matches
set wildmode=list:longest    " make cmdline tab completion similar to bash
set wildignore=*.o,*.obj,*~  " stuff to ignore when tab completing

set cursorline
set relativenumber

set ruler
set laststatus=2    " always display status line
" statusline setup
set statusline=    " clear the statusline for when vimrc is reloaded
set statusline+=%-n\                               " buffer number
set statusline+=%<%.79f\                           " file name
set statusline+=[%{strlen(&ft)?&ft:'n/a'},         " filetype
set statusline+=%{&bomb?'bom,':''}                 " BOM
set statusline+=%{&fenc},                          " file encoding
set statusline+=%{&fileformat}]                    " file format
set statusline+=%{fugitive#statusline()}           " FUGITIVE git branch
set statusline+=%m%r%w                             " flags
set statusline+=%#warningmsg#%{SyntasticStatuslineFlag()}%*     " SYNTASTIC
set statusline+=%=                                 " left/right separator
set statusline+=%{synIDattr(synID(line('.'),col('.'),1),'name')}   " syntax
set statusline+=\ 0x%B\ \                          " character under cursor
set statusline+=[%l/%L,%-4(%3(%c%V]%)%)\ %P        " offset

"-----------------------------------------------------------------------------
" key mappings
"-----------------------------------------------------------------------------

set timeoutlen=2500    " mapping delay
set ttimeoutlen=50     " key code delay

let mapleader = "\<Space>"

inoremap jk <ESC>
nnoremap ; :
nnoremap : ;
vnoremap ; :

nnoremap j gj
nnoremap k gk

" buffer navigation
nnoremap <silent> <left> :bprev<CR>
nnoremap <silent> <right> :bnext<CR>
nnoremap gb :ls<cr>:e #

" make Y consistent with C and D. See :help Y
nnoremap Y y$

" searching
set gdefault
set ignorecase
set smartcase
set incsearch
set hlsearch
set showmatch
nnoremap / /\v
vnoremap / /\v
nnoremap <Leader>s :%s/\v
nnoremap <silent> <Leader>h :noh<CR>
nnoremap <Tab> %
vnoremap <Tab> %

nnoremap <Leader>w <C-w>
" open a new vertical split and switch over to it
nnoremap <Leader>v <C-w>v<C-w>l
" navigate among split windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" start diff mode with vertical splits
set diffopt=vertical

" copy to / paste from system clipboard
nnoremap <Leader>y "*y
vnoremap <Leader>y "*y
nnoremap <Leader>p "*p
vnoremap <Leader>p "*p

" reselect last paste
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" edit .vimrc file on the fly
nnoremap <Leader>ev <C-w>v<C-w>l:e $MYVIMRC<CR>

" fold tag
nnoremap <Leader>ft Vatzf

" sort CSS properties
nnoremap <Leader>CS ?{<CR>jV/^\s*\}?$<CR>k:sort<CR>:noh<CR>

function! PreserveStateRun(command)
    " Preparation: save last search, and view of the current window
    let _s=@/
    let l:winview = winsaveview()
    " Do the business
    execute a:command
    " Clean up: restore previous search history, and view of the window
    let @/=_s
    call winrestview(l:winview)
endfunction
" strip all trailing whitespace in the current file
nnoremap <F4> :call PreserveStateRun("%s/\\s\\+$//e")<CR>

"-----------------------------------------------------------------------------
" plugin shortcuts and settings
"-----------------------------------------------------------------------------

" dirvish
" Use *-* to open the current file directory

" Tagbar (ctags required)
nnoremap <silent> <F9> :TagbarToggle<CR>

" Rainbow Parentheses Improved
nnoremap <Leader>r :RainbowToggle<CR>
let g:rainbow_active = 0

" FencView (iconv.dll required for Windows)
" use :FencAutoDetect, or use :FencView and then select from encoding list

" Plugins by tpope {{{
"
" commentary
" Use *gcc* to comment out a line, *gc* to comment out the target of a motion

" dispatch
" Asynchronous build and test dispatcher

" fugitive
" git wrapper

" sleuth
" Automatically adjusts 'shiftwidth' and 'expandtab' heuristically

" surround
" A tool for dealing with pairs of surroundings. Delete surroundings is *ds*.
" Change surroundings is *cs*. *ys* takes a motion or text object as the first
" object, and wraps it using the second argument. See :h surround-targets

" unimpaired
" several pairs of bracket maps
" }}}

" ListToggle
" Toggle quickfix/location list, default keymappings: *<Leader>q* *<Leader>l*

" vim-Slime
" Grab some text and 'send' it to a GNU Screen / tmux / whimrepl session.
" Default key binding: <Ctrl-c><Ctrl-c> (hold Ctrl and double-tap c)
"let g:slime_target = 'tmux'

" scratch.vim
" default key binding in normal and visual modes: *gs*
let g:scratch_insert_autohide = 0

" sparkup
" open an html file, type in something (e.g., #header > h1), then press
" <Ctrl-e>. Pressing <Ctrl-n> will cycle through empty elements

" ultisnips and snippets
" insert a piece of often-typed text into your document using a trigger word
" followed by a <Tab> (default key binding)
let g:UltiSnipsExpandTrigger = '<C-j>'

" YouCompleteMe
"let g:ycm_key_list_select_completion = ['<TAB>', '<Down>']
"let g:ycm_key_invoke_completion = '<C-Space>'
"let g:ycm_key_detailed_diagnostics = '<leader>d'
"let g:ycm_min_num_of_chars_for_completion = 3

" Syntastic {{{
nnoremap <Leader>E :Errors<CR>
nnoremap <Leader>S :SyntasticCheck<CR>
let g:syntastic_check_on_wq = 0
"let g:syntastic_aggregate_errors = 1
let g:syntastic_enable_signs = 0
let g:syntastic_auto_jump = 1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_mode_map = {
    \ 'mode': 'passive',
    \ 'active_filetypes': [],
    \ 'passive_filetypes': [] }
" python
let g:syntastic_python_checkers = ['flake8']
" C
let g:syntastic_c_check_header = 1
" C++
let g:syntastic_cpp_check_header = 1
" }}}

" Unite {{{
call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])
call unite#custom#profile('default', 'context', {'start_insert': 1})

let g:unite_source_rec_max_cache_files = 5000

let g:unite_source_grep_command = 'ag'
let g:unite_source_grep_default_opts = '--nogroup --nocolor --column'
let g:unite_source_grep_recursive_opt = ''

function! s:unite_settings()
    nmap <buffer> <esc> <plug>(unite_exit)
    imap <buffer> <esc> <plug>(unite_exit)
endfunction
autocmd FileType unite call s:unite_settings()

nnoremap [unite] <nop>
nmap <Leader><Space> [unite]

if has('win32')
    nnoremap <silent> [unite]a :<C-u>Unite -toggle -auto-resize -buffer-name=mixed file_rec:! buffer file_mru bookmark<cr><c-u>
    nnoremap <silent> [unite]f :<C-u>Unite -toggle -auto-resize -buffer-name=files file_rec:!<cr><c-u>
else
    nnoremap <silent> [unite]a :<C-u>Unite -toggle -auto-resize -buffer-name=mixed file_rec/async:! buffer file_mru bookmark<cr><c-u>
    nnoremap <silent> [unite]f :<C-u>Unite -toggle -auto-resize -buffer-name=files file_rec/async:!<cr><c-u>
endif
nnoremap <silent> [unite]r :<C-u>Unite -buffer-name=recent file_mru<cr>
nnoremap <silent> [unite]y :<C-u>Unite -buffer-name=yanks history/yank<cr>
nnoremap <silent> [unite]l :<C-u>Unite -auto-resize -buffer-name=line line<cr>
nnoremap <silent> [unite]b :<C-u>Unite -auto-resize -buffer-name=buffers buffer<cr>
nnoremap <silent> [unite]/ :<C-u>Unite -no-quit -buffer-name=search grep:.<cr>
nnoremap <silent> [unite]m :<C-u>Unite -auto-resize -buffer-name=mappings mapping<cr>
nnoremap <silent> [unite]s :<C-u>Unite -quick-match buffer<cr>
" }}}
