filetype plugin indent on
syntax enable

augroup mygroup
  autocmd!
augroup END


" Section: ui settings

if has('gui_running')
  set guioptions=
  set winaltkeys=no
endif

set mouse=nvi    " to select text with the terminal, go to command-line mode first

" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^Eterm'
  set t_Co=16
endif

if &term =~ '256color'
  "set t_ut=           " disable Background Color Erase (BCE)
  set termguicolors    " use true colors in the terminal
endif

set background=dark
silent! color iceberg

" set cursor shape, see `:h termcap-cursor-shape`
if &term =~ 'xterm\|tmux'
  let &t_SI = "\e[5 q"      " blink bar for insert mode
  let &t_SR = "\e[3 q"      " blink underline for replace mode
  let &t_EI = "\e[1 q"      " blink block for other modes
  let &t_ti ..= "\e[1 q"    " blink block when vim starts
  let &t_te ..= "\e[0 q"    " terminal default when vim exits
endif


" Section: general settings

if has('path_extra')
  setglobal tags-=./tags tags-=./tags; tags^=./tags;
endif

if !empty(&viminfo)
  set viminfo^=!
endif
set sessionoptions-=options
set viewoptions-=options
set history=5000    " cmdline history
set tabpagemax=50

set nobackup
set nowritebackup
set noswapfile
set autoread
set hidden    " allow buffer switching without saving


" Section: editing behavior and text display

set backspace=indent,eol,start
set complete-=i
set nrformats-=octal
set virtualedit=block
set diffopt+=algorithm:histogram

set fileformats=unix,dos
if has('multi_byte')
  set formatoptions+=mM
endif
set formatoptions+=j
autocmd mygroup FileType * setlocal fo-=r fo-=o  " do not insert comment leader

set smarttab         " tab in front of a line depends on 'shiftwidth'
set tabstop=4        " number of spaces per tab for display
set shiftwidth=4     " number of spaces to use for each step of (auto)indent
set softtabstop=4    " number of spaces per tab in insert mode
set expandtab        " in insert mode: use spaces to insert a <Tab>
set autoindent       " automatically indent to match adjacent line

set foldmethod=marker
set display=truncate
set smoothscroll
set scrolloff=1
set sidescroll=1
set sidescrolloff=7


" Section: message and info display

set lazyredraw
set visualbell

set cursorline
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
set relativenumber
set signcolumn=number

set wildmenu                   " enable ctrl-n and ctrl-p to scroll thru matches
set wildmode=list:longest      " make cmdline tab completion similar to bash
set wildignore=*.o,*.obj,*~    " stuff to ignore when tab completing
set wildignore+=*/.git/*,*/.svn/*,*/node_modules/*

set laststatus=2    " always display status line
set statusline=     " clear the statusline for when vimrc is reloaded
set statusline+=%<%f\                                   " relative path
set statusline+=[%{&ft!=#''?&ft:'no\ ft'},\             " filetype
set statusline+=%{&fenc!=#''?&fenc:&enc}                " file encoding
set statusline+=%{&bomb?',\ bom':''}                    " BOM
set statusline+=%{&ff!=#'unix'?',\ '..&ff:''}]          " file format
set statusline+=%m%r%w                                  " flags
set statusline+=\ %{FugitiveHead()}                     " Fugitive git branch
set statusline+=\ %{coc#status()}                       " coc status
set statusline+=%=                                      " left/right separator
set statusline+=%{StatuslineGetSyntaxID()}              " syntax id
set statusline+=\ %B\                                   " character under cursor
set statusline+=%{v:hlsearch?LastSearchCount():''}      " search count
set statusline+=%4([\ %v%):%l/%L\ ]\ %P                 " offset

" statusline helpers {{{
" toggle syntax id
let g:syntax_id_toggle = 0
function! StatuslineGetSyntaxID()
  return g:syntax_id_toggle ? synIDattr(synID(line('.'), col('.'), 1), 'name') : ''
endfunction

function! StatuslineToggleSyntaxID()
  let g:syntax_id_toggle = !g:syntax_id_toggle
endfunction

" get last search count, see `:h searchcount()`
function! LastSearchCount() abort
  let result = searchcount(#{maxcount: 1000})
  if empty(result)
    return ''
  endif

  if result.incomplete ==# 0    " search fully completed
    return printf('[%d/%d]', result.current, result.total)
  elseif result.incomplete ==# 2    " max count exceeded
    let current = result.current > result.maxcount ? '>'..result.maxcount : result.current
    return printf('[%s/>%d]', current, result.maxcount)
  else    " timed out
    return printf('[?/??]')
  endif
endfunction
" }}}


" Section: key mappings and commands

set nolangremap
set ttimeout           " time out for key codes
set ttimeoutlen=50     " key code delay
set timeoutlen=2500    " mapping delay

let mapleader = "\<Space>"

noremap <Leader>ts <Cmd>call StatuslineToggleSyntaxID()<CR>

noremap ; :
noremap \ ;

" fix alt key as meta key, see :set-termcap
if !has('gui_running') && !has('nvim')
  for i in range(26)
    let key = nr2char(char2nr('a') + i)
    execute "set <M-"..key..">=\e"..key
  endfor
endif

" readline emacs editing mode shortcuts
noremap! <C-a> <Home>
noremap! <C-e> <End>
noremap! <C-d> <Del>
noremap! <C-b> <Left>
noremap! <C-f> <Right>
noremap! <M-b> <C-Left>
noremap! <M-f> <C-Right>
noremap! <M-h> <C-Left>
noremap! <M-l> <C-Right>

noremap <M-j> gj
noremap <M-k> gk
tnoremap <M-q> <C-\><C-n>

" Break undo before deleting
inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>

" Make Y consistent with C and D. See :help Y
nnoremap Y y$

" buffer navigation
noremap <silent> <Left> <Cmd>bprev<CR>
noremap <silent> <Right> <Cmd>bnext<CR>
"noremap <Leader>b :<C-u>ls<CR>:e #
" delete a buffer without closing the window
noremap <silent> <Leader>d <Cmd>bp<Bar>bd#<CR>

" split windows
set splitright
nnoremap <Leader>w <C-W>
nnoremap <Leader>v <C-W>v
nnoremap <C-J> <C-W>w
nnoremap <C-K> <C-W>W
nnoremap <C-H> <C-W>h
nnoremap <C-L> <C-W>l

" search and substitute
set ignorecase
set smartcase
set hlsearch
set incsearch
noremap / /\v
nnoremap <Leader>s :%s///g<Left><Left>
vnoremap <Leader>s :s///g<Left><Left>
nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>

" count number of matches of the last search pattern
nnoremap <Leader>n :call PreserveViewRun('%s///gne')<CR>

" strip all trailing whitespace in the current file
nnoremap <F4> :call PreserveViewRun('%s/\s\+$//e')<CR>

function! PreserveViewRun(command)
  let l:winview = winsaveview()
  execute a:command
  call winrestview(l:winview)
endfunction

" copy to / paste from system clipboard
noremap <Leader>y "*y
noremap <Leader>p "*p
" paste from the most recent yank, see `:h v_P`
noremap <Leader>0 "0p
" cycle through numbered registers, see `:h redo-register`
noremap <Leader>1 "1p

" reselect last paste
nnoremap <expr> gp '`['..strpart(getregtype(), 0, 1)..'`]'

" set working directory to the current file
noremap <Leader>z <Cmd>lcd %:p:h<Bar>pwd<CR>

" jump to the last known cursor position, see :h `quote
nnoremap <Leader>' g`"

" don't reset the cursor upon returning to a buffer
if &startofline
  augroup StayPut
    autocmd!
    au BufLeave * set nostartofline | au StayPut CursorMoved,CursorMovedI *
                  \ set startofline | au! StayPut CursorMoved,CursorMovedI
  augroup END
endif


" Section: plugin settings

" Load matchit.vim
if !exists('g:loaded_matchit')
  runtime! macros/matchit.vim
endif

" netrw
let g:netrw_banner = 0
let g:netrw_home = expand('~/.cache/netrw')
let g:netrw_liststyle = 3

" source settings from ./init
let s:home = fnamemodify(resolve(expand('<sfile>:p')), ':h')
command! -nargs=1 SourceScript execute 'source '..s:home..'/<args>'
SourceScript init/plugins.vim
SourceScript init/coc.vim

" vim-color-patch
let g:cpatch_path = s:home..'/colors/patch'


" Section: filetype specific

" Correctly highlight $() and other modern affordances in filetype=sh.
if !exists('g:is_posix') && !exists('g:is_bash') && !exists('g:is_kornshell') && !exists('g:is_dash')
  let g:is_posix = 1
endif
