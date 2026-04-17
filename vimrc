augroup mygroup
  autocmd!
augroup END

filetype plugin indent on
syntax enable


" Section: ui settings

if has('gui_running')
  set guioptions=
  set winaltkeys=no
endif
set mouse=nvi    " to select text with the terminal, go to command-line mode first

if &term =~ '256color'
  set termguicolors    " use true colors in the terminal
endif
"set background=light
silent! color nord

" set cursor shape, see `:h termcap-cursor-shape`
if &term =~ 'xterm\|tmux'
  let &t_SI = "\e[5 q"      " blink bar for insert mode
  let &t_SR = "\e[3 q"      " blink underline for replace mode
  let &t_EI = "\e[1 q"      " blink block for other modes
  let &t_ti ..= "\e[1 q"    " blink block when vim starts
  let &t_te ..= "\e[0 q"    " terminal default when vim exits
endif


" Section: file settings

setglobal tags-=./tags tags-=./tags; tags^=./tags;
if !empty(&viminfo)
  set viminfo^=!
endif
set history=4000    " cmdline history
set sessionoptions-=options
set viewoptions-=options

set nowritebackup
set noswapfile
set autoread
set hidden    " allow buffer switching without saving
set tabpagemax=50


" Section: editing behavior

set nrformats-=octal
set virtualedit=block
set diffopt+=algorithm:histogram

" autocompletion; see `ins-autocompletion`, `cmdline-autocompletion`
"set autocomplete
set complete-=i
set completeopt=fuzzy,menuone,noselect,popup
autocmd mygroup CmdlineChanged [:] call wildtrigger()
set wildmode=noselect:lastused,full
set wildoptions=fuzzy,pum

" search and substitute
set ignorecase
set smartcase
set hlsearch
set incsearch
set nowrapscan


" Section: text formatting and display

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
set scrolloff=5
set sidescroll=1
set sidescrolloff=7


" Section: info display

set lazyredraw
set belloff=all
set cursorline
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
set relativenumber
set signcolumn=number

set laststatus=2    " always display status line
set statusline=     " clear the statusline for when vimrc is reloaded
set statusline+=%<%f\                                    " relative path
set statusline+=[%{&ft!=#''?&ft:'no\ ft'},\              " filetype
set statusline+=%{&fenc!=#''?&fenc:&enc}                 " file encoding
set statusline+=%{&bomb?',\ bom':''}                     " BOM
set statusline+=%{&ff!=#'unix'?',\ '..&ff:''}]           " file format
set statusline+=%m%r%w                                   " flags
set statusline+=%(\ %{FugitiveHead()}%)                  " Fugitive git branch
set statusline+=%(\ %{coc#status()}%)                    " coc status
set statusline+=%=                                       " separation point
set statusline+=%(%{StatuslineGetSyntaxID()}\ %)         " syntax id
set statusline+=%B\                                      " character hex code
set statusline+=%{v:hlsearch?LastSearchCount()..'\ ':''} " search count
set statusline+=[\ %l/%L:%-4(%v\ ]%)\ %p%%               " line info

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
  let result = searchcount(#{maxcount: 2000})
  if empty(result)
    return ''
  endif
  if result.incomplete ==# 1     " timed out
    return printf('[?/??]')
  elseif result.incomplete ==# 2 " max count exceeded
    let current = result.current > result.maxcount ? '>'..result.maxcount : result.current
    return printf('[%s/>%d]', current, result.maxcount)
  endif
  return printf('[%d/%d]', result.current, result.total)
endfunction
" }}}


" Section: key mappings and commands

set nolangremap
set ttimeout           " time out for key codes
set ttimeoutlen=50     " key code delay
set timeoutlen=2500    " mapping delay

let mapleader = "\<Space>"
noremap <Leader>; :

noremap <Leader>os <Cmd>call StatuslineToggleSyntaxID()<CR>

" fix alt key as meta key, see `:h set-termcap`, `:h map-alt-keys`
if !has('gui_running') && !has('nvim')
  for i in range(26)
    let key = nr2char(char2nr('a') + i)
    silent! exe "set <M-"..key..">=\<Esc>"..key
  endfor
  silent! exe "set <M-=>=\<Esc>="
endif

" readline (emacs) mappings for insert and command-line modes, reference vim-rsi
inoremap        <C-A> <C-O>^
inoremap   <C-X><C-A> <C-A>
inoremap <expr> <C-E> col('.')>strlen(getline('.'))<bar><bar>pumvisible()?"\<Lt>C-E>":"\<Lt>End>"
inoremap <expr> <C-B> getline('.')=~'^\s*$'&&col('.')>strlen(getline('.'))?"0\<Lt>C-D>\<Lt>Esc>kJs":"\<Lt>Left>"
inoremap <expr> <C-F> col('.')>strlen(getline('.'))?"\<Lt>C-F>":"\<Lt>Right>"
inoremap <expr> <C-D> col('.')>strlen(getline('.'))?"\<Lt>C-D>":"\<Lt>Del>"

cnoremap        <C-A> <Home>
cnoremap   <C-X><C-A> <C-A>
cnoremap        <C-B> <Left>
cnoremap <expr> <C-F> getcmdpos()>strlen(getcmdline())?&cedit:"\<Lt>Right>"
cnoremap <expr> <C-D> getcmdpos()>strlen(getcmdline())?"\<Lt>C-D>":"\<Lt>Del>"

noremap!        <M-b> <S-Left>
noremap!        <M-f> <S-Right>
noremap!        <M-d> <C-O>dw
cnoremap        <M-d> <S-Right><C-W>
noremap!        <M-n> <Down>
noremap!        <M-p> <Up>
if !has('gui_running') && !has('nvim')
  silent! exe "set <F34>=\<Esc>\<C-?>"
  noremap!      <F34> <C-W>
else
  noremap!      <M-BS> <C-W>
endif

" autocompletion
inoremap <silent><expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
cnoremap <expr> <Up>   wildmenumode() ? "\<C-E>\<Up>"   : "\<Up>"
cnoremap <expr> <Down> wildmenumode() ? "\<C-E>\<Down>" : "\<Down>"

" navigate by screen lines
noremap <M-j> gj
noremap <M-k> gk

" Break undo before deleting
inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>

" quick save
noremap  <C-s> <Cmd>update<CR>
inoremap <C-s> <C-o><Cmd>update<CR>

" buffers
nnoremap <Left> <Cmd>bprev<CR>
nnoremap <Right> <Cmd>bnext<CR>
nnoremap <Leader>b :<C-u>ls<CR>:b<Space>
" delete a buffer without closing the window
noremap <silent> <Leader>d <Cmd>bp<Bar>bd#<CR>

" windows
noremap <Leader>w <C-W>
noremap <Leader>v <C-W>v
noremap <Leader>q <C-W>c
noremap <C-j> <C-W>w
noremap <C-k> <C-W>W

" tabpage
noremap <Leader>tt <Cmd>tabnew<CR>
noremap <Leader>tc <Cmd>tabclose<CR>
noremap <Leader>to <Cmd>tabonly<CR>
noremap <Leader>th <Cmd>tabmove -<CR>
noremap <Leader>tl <Cmd>tabmove +<CR>

" terminal
tnoremap <M-q> <C-\><C-n>

" search and substitute
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

" Make Y consistent with C and D. See :help Y
nnoremap Y y$

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
    au BufLeave * set nostartofline | au StayPut BufReadPost *
                  \ set startofline | au! StayPut BufReadPost
  augroup END
endif


" Section: plugin settings

" Load builtin plugins
packadd! comment
packadd! helptoc
packadd! matchit

" netrw
let g:netrw_banner = 0
let g:netrw_home = expand('~/.cache/netrw')

" source settings from ./init
let g:vimrc_path = fnamemodify(resolve(expand('<sfile>:p')), ':h')
exe 'source '..g:vimrc_path..'/init/plugins.vim'


" Section: filetype specific

" Correctly highlight $() and other modern affordances in filetype=sh.
if !exists('g:is_posix') && !exists('g:is_bash') && !exists('g:is_kornshell') && !exists('g:is_dash')
  let g:is_posix = 1
endif
