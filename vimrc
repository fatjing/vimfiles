" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

filetype plugin indent on
syntax enable

" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^linux\|^Eterm'
  set t_Co=16
endif
"let base16colorspace=256
"color base16-tomorrow-night
color hybrid

set mouse=a
set guioptions=

if has('gui_win32')
  set guifont=Consolas:h10.5
  " set guifontwide=Microsoft\ YaHei\ Mono:h10.5
  set renderoptions=type:directx,gamma:1.0,contrast:0.5,level:1,geom:1,renmode:4,taamode:1
elseif has('gui_gtk')
  set guifont=Inconsolata\ 12
  set guifontwide=WenQuanYi\ Micro\ Hei\ Mono\ 12
endif

set visualbell
set ttyfast

set nobackup
set noswapfile
"set undofile
"au FocusLost * :wa    " save on losing focus

set history=5000    " cmdline history
if !empty(&viminfo)
  set viminfo^=!
endif
set sessionoptions-=options

set hidden    " allow buffer switching without saving
set autoread

set backspace=indent,eol,start
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
set nrformats-=octal

if has('path_extra')
  setglobal tags-=./tags tags-=./tags; tags^=./tags;
endif

set encoding=utf-8
set fileformats=unix,dos

set smarttab        " tab in front of a line depends on 'shiftwidth'
set tabstop=4       " number of spaces per tab for display
set shiftwidth=4    " number of spaces to use for each step of (auto)indent
set softtabstop=4   " number of spaces per tab in insert mode
set expandtab       " in insert mode: use spaces to insert a <Tab>
set autoindent      " automatically indent to match adjacent line
set breakindent     " wrapped line continue visually indented

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
set statusline+=%=                                 " left/right separator
set statusline+=%{synIDattr(synID(line('.'),col('.'),1),'name')}   " syntax id
set statusline+=\ 0x%B\ \                          " character under cursor
set statusline+=[%l/%L,%-4(%3(%c%V]%)%)\ %P        " offset

"-----------------------------------------------------------------------------
" key mappings
"-----------------------------------------------------------------------------

set timeoutlen=2500    " mapping delay
set ttimeoutlen=100    " key code delay

" Delete all entered characters before the cursor in the current line
inoremap <C-U> <C-G>u<C-U>

let mapleader = "\<Space>"

inoremap jk <ESC>
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;

nnoremap j gj
nnoremap gj j
nnoremap k gk
nnoremap gk k

" buffer navigation
nnoremap <silent> <left> :bprev<CR>
nnoremap <silent> <right> :bnext<CR>
nnoremap <Leader>b :ls<cr>:e #

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
nnoremap <Leader>s :%s/
nnoremap <silent> <Leader>h :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>

set diffopt+=vertical  " start diff mode with vertical splits
set splitright
nnoremap <Leader>w <C-w>
" open a new vertical split and switch over to it
nnoremap <Leader>v <C-w>v<C-w>l
" navigate among split windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" copy to / paste from system clipboard
nnoremap <Leader>y "+y
vnoremap <Leader>y "+y
nnoremap <Leader>p "+p
vnoremap <Leader>p "+p

" reselect last paste
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" edit .vimrc file on the fly
nnoremap <Leader>ev <C-w>v<C-w>l:e $MYVIMRC<CR>

" fold tag
nnoremap <Leader>FT Vatzf

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

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

" dirvish
" Use *-* to open the current file directory
let g:dirvish_mode = ':sort ,^.*[\/],'

" Rainbow Parentheses Improved
nnoremap <Leader>r :RainbowToggle<CR>
let g:rainbow_active = 0

" FencView (iconv.dll required for Windows)
" use :FencAutoDetect, or use :FencView and then select from encoding list

" Plugins by tpope {{{
"
" abolish
" find, substitute, and abbreviate several variations of a word at once

" commentary
" Use *gcc* to comment out a line, *gc* to comment out the target of a motion

" dispatch
" Asynchronous build and test dispatcher

" endwise
" end certain structures automatically

" fugitive
" git wrapper

" sleuth
" Automatically adjusts 'shiftwidth' and 'expandtab' heuristically

" surround
" A tool for dealing with pairs of surroundings. See :h surround

" unimpaired
" several pairs of bracket maps
" }}} tpope

" ListToggle
" Toggle quickfix/location list, default keymappings: *<Leader>q* *<Leader>l*

" VOoM
" VOoM (Vim Outliner of Markups) is a plugin for Vim that emulates a two-pane
" text outliner

" vim-Slime
" Grab some text and 'send' it to a GNU Screen / tmux / whimrepl session.
" Default key binding: <Ctrl-c><Ctrl-c> (hold Ctrl and double-tap c)
"let g:slime_target = 'tmux'

" scratch.vim
" default key binding in normal and visual modes: *gs*
let g:scratch_insert_autohide = 0

" vim-closer
" closes brackets when pressing Enter

" ultisnips and snippets
" insert a piece of often-typed text into your document using a trigger word
" followed by a <Tab> (default key binding)
let g:UltiSnipsExpandTrigger = '<C-j>'

" YouCompleteMe {{{
let g:ycm_add_preview_to_completeopt = 0
let g:ycm_show_diagnostics_ui = 0
let g:ycm_server_log_level = 'info'
let g:ycm_min_num_identifier_candidate_chars = 2
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_complete_in_strings=1
let g:ycm_key_invoke_completion = '<c-z>'
noremap <c-z> <NOP>
set completeopt=menu,menuone

let g:ycm_semantic_triggers =  {
            \ 'c,cpp,python,java,go,erlang,perl': ['re!\w{2}'],
            \ 'cs,lua,javascript': ['re!\w{2}'],
            \ }
"let g:ycm_key_list_select_completion = ['<TAB>', '<Down>']
"let g:ycm_key_invoke_completion = '<C-Space>'
"let g:ycm_key_detailed_diagnostics = '<leader>d'
" }}} YCM

" Gutentags {{{
let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']
let g:gutentags_ctags_tagfile = '.tags'
let g:gutentags_cache_dir = expand('~/.cache/tags')
"let g:gutentags_auto_add_gtags_cscope = 0

let g:gutentags_modules = []
if executable('ctags')
  let g:gutentags_modules += ['ctags']
endif
if executable('gtags-cscope') && executable('gtags')
  let g:gutentags_modules += ['gtags_cscope']
endif

let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']
" universal ctags
"let g:gutentags_ctags_extra_args += ['--output-format=e-ctags']
" }}} Gutentags

" ALE {{{
let g:ale_linters_explicit = 1
let g:ale_completion_delay = 500
let g:ale_echo_delay = 20
let g:ale_lint_delay = 500
let g:ale_echo_msg_format = '[%linter%] %code: %%s'
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1

let g:ale_c_gcc_options = '-Wall -O2 -std=c99'
let g:ale_cpp_gcc_options = '-Wall -O2 -std=c++14'
let g:ale_c_cppcheck_options = ''
let g:ale_cpp_cppcheck_options = ''

let g:ale_sign_error = "\ue009\ue009"
hi! clear SpellBad
hi! clear SpellCap
hi! clear SpellRare
hi! SpellBad gui=undercurl guisp=red
hi! SpellCap gui=undercurl guisp=blue
hi! SpellRare gui=undercurl guisp=magenta
" }}} ALE

" Denite {{{
" }}} Denite
