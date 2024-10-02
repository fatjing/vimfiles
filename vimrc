" Use Vim defaults. Must put at the start
set nocompatible

filetype plugin indent on
if !exists('g:syntax_on')
  syntax enable
endif


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

" set cursor shape, see |termcap-cursor-shape|
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
set history=5000    " cmdline history
set sessionoptions-=options
set viewoptions-=options

set nobackup
set nowritebackup
set noswapfile
"set undofile
"au FocusLost * :wa    " save on losing focus

set autoread
set hidden    " allow buffer switching without saving


" Section: editing behavior and text display

set backspace=indent,eol,start
set nrformats-=octal
set complete-=i
set virtualedit=block

set fileformats=unix,dos
set formatoptions+=j
if has('multi_byte')
  set encoding=utf-8
  set fileencodings=ucs-bom,utf-8,gbk,gb18030,big5,euc-jp,latin1
  set formatoptions+=mM
endif

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
set statusline+=%{&ff!=#'unix'?',\ '.&ff:''}]           " file format
set statusline+=%m%r%w                                  " flags
set statusline+=\ %{FugitiveHead()}                     " Fugitive git branch
set statusline+=%{gutentags#statusline('\ ')}           " Gutentags
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

" get last search count, see |searchcount()|
function! LastSearchCount() abort
  let result = searchcount(#{maxcount: 1000})
  if empty(result)
    return ''
  endif

  if result.incomplete ==# 0    " search fully completed
    return printf('[%d/%d]', result.current, result.total)
  elseif result.incomplete ==# 2    " max count exceeded
    let current = result.current > result.maxcount ? '>'.result.maxcount : result.current
    return printf('[%s/>%d]', current, result.maxcount)
  else    " timed out
    return printf('[?/??]')
  endif
endfunction
" }}}


" Section: key mappings and commands

set nolangremap
set ttimeout
set timeoutlen=2500    " mapping delay
set ttimeoutlen=50     " key code delay

let mapleader = "\<Space>"

noremap <Leader>ts <Cmd>call StatuslineToggleSyntaxID()<CR>

noremap ; :
noremap \ ;

" fix alt key as meta key, see :set-termcap
if !has('gui_running') && !has('nvim')
  for i in range(26)
    let key = nr2char(char2nr('a') + i)
    execute "set <M-".key.">=\e".key
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
tnoremap <M-n> <C-\><C-n>

" Break undo before deleting
inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>

" Make Y consistent with C and D. See :help Y
nnoremap Y y$

" buffer navigation
nnoremap <silent> <Left> :bprev<CR>
nnoremap <silent> <Right> :bnext<CR>
"nnoremap <Leader>b :ls<CR>:e #
" delete a buffer without closing the window
nnoremap <silent> <Leader>d :bp<Bar>bd#<CR>

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
set incsearch
set hlsearch
noremap / /\v
nnoremap <Leader>s :%s/
nnoremap <silent> <Leader>h :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>

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

" cycle through numbered registers
" first do '"1p' and then do 'u.' repeatedly, see |redo-register|
noremap <Leader>1 "1p
noremap <Leader>0 "0p

" reselect last paste
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" move selected text up and down
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv

" set working directory to the current file
nnoremap <Leader>wd :cd %:p:h<CR>:pwd<CR>

" edit vimrc file on the fly
nnoremap <Leader>ev <C-W>v:e ~/.config/vim/vimrc<CR>

" fold tag
nnoremap <Leader>FT Vatzf

" don't reset the cursor upon returning to a buffer
if &startofline
  augroup StayPut
    autocmd!
    au BufLeave * set nostartofline | au StayPut CursorMoved,CursorMovedI *
                  \ set startofline | au! StayPut CursorMoved,CursorMovedI
  augroup END
endif

set diffopt+=vertical  " start diff mode with vertical splits
set diffopt+=indent-heuristic,algorithm:histogram
" see the difference between the current buffer and the file it was loaded from
if !exists(':DiffOrig')
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
                   \ | wincmd p | diffthis
endif


" Section: plugin settings

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

" netrw
let g:netrw_banner = 0
let g:netrw_home = expand('~/.cache/netrw')
let g:netrw_liststyle = 3

" lightline.vim {{{
let g:lightline = {
    \ 'colorscheme': 'Tomorrow_Night_Bright',
    \ 'active': {
    \   'left': [['mode', 'paste'], ['relativepath', 'modified', 'readonly'], ['fileinfo'],
    \             ['gitbranch'], ['gutentags'], ['cocstatus']],
    \   'right': [['lineinfo'], ['percent'], ['searchcount'], ['charvaluehex'], ['syntax_id']]
    \   },
    \ 'component': {
    \   'relativepath': '%<%f',
    \   'lineinfo': '%2v:%l/%-2L',
    \   'fileinfo': '[%{&ft!=#""?&ft:"no ft"}, %{&fenc!=#""?&fenc:&enc}%{&bomb?", bom":""}%{&ff!=#"unix"?", ".&ff:""}]',
    \   'searchcount': '%{v:hlsearch?LastSearchCount():""}'
    \   },
    \ 'component_function': {
    \   'gitbranch': 'FugitiveHead',
    \   'gutentags': 'gutentags#statusline',
    \   'cocstatus': 'coc#status',
    \   'syntax_id': 'StatuslineGetSyntaxID'
    \   }
    \ }
" }}}

" vim-dirvish
" Use `-` to open the current file directory
let g:dirvish_mode = ':sort i ,^.*[\/],'

" vim-sneak
" Type `s` followed by two characters to move; use `z` for operations
let g:sneak#s_next = 1
let g:sneak#use_ic_scs = 1

" vim-commentary
" Use `gcc` to comment out a line, `gc` to comment out the target of a motion
call load_plugin#load_on_map('vim-commentary', 'gc', 'nxo')

" vim-endwise
" End certain structures automatically
"call load_plugin#load_on_evnt('vim-endwise', 'InsertEnter', '*')

" vim-fugitive
nnoremap <Leader>i :Git<CR>

" vim-surround
" A tool for dealing with pairs of surroundings. See :h surround

" vim-unimpaired
" Provide several pairs of bracket maps. See :h unimpaired

" ListToggle
" Toggle quickfix/location list, default keymappings: `<Leader>q` `<Leader>l`
call load_plugin#load_on_map('ListToggle', '<Space>q', 'n')
let g:lt_height = 12

" scratch.vim
call load_plugin#load_on_map('scratch.vim', 'gs', 'nx')
let g:scratch_autohide = 0
let g:scratch_insert_autohide = 0

" fencview
" use :FencAutoDetect, or use :FencView and then select from encoding list
call load_plugin#load_on_cmd('fencview', 'FencAutoDetect')

" Rainbow Parentheses Improved
call load_plugin#load_on_cmd('rainbow', 'RainbowToggle')
noremap <Leader>r <Cmd>RainbowToggle<CR>
let g:rainbow_active = 0

" VOoM
" Vim Outliner of Markups is a plugin that emulates a two-pane text outliner
call load_plugin#load_on_cmd('VOoM', 'Voom')

" vim-easy-align
call load_plugin#load_on_cmd('vim-easy-align', 'EasyAlign')

" vim-color-patch
let g:cpatch_path = '~/.config/vim/colors/patch'

" vim-terminal-help
call load_plugin#load_on_map('vim-terminal-help', '<M-=>', 'nx')
exe "set <M-=>=\e="
let g:terminal_height = 15

" asyncrun.vim
call load_plugin#load_on_cmd('asyncrun.vim', 'AsyncRun')
let g:asyncrun_bell = 1
let g:asyncrun_open = 12
if has('win32')
  let g:asyncrun_encs = 'cp936'
endif
" cooperate with fugitive
command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>

" asynctasks.vim
call load_plugin#load_on_cmd('asynctasks.vim', ['AsyncTask', 'AsyncTaskList'])
noremap <silent><F5> :AsyncTask file-run<CR>
noremap <silent><F9> :AsyncTask file-build<CR>

" vim-gutentags {{{
let g:gutentags_project_root = ['.root', '.project', '.git', '.svn', '.hg']
let g:gutentags_cache_dir = expand('~/.cache/tags')

let g:gutentags_modules = []
if executable('ctags')
  let g:gutentags_modules += ['ctags']
endif
if executable('gtags-cscope') && executable('gtags')
  let g:gutentags_modules += ['gtags_cscope']
endif

let g:gutentags_ctags_tagfile = '.tags'
let g:gutentags_ctags_exclude = ['*/build/*', '*/dist/*']
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']
let g:gutentags_ctags_extra_args += ['--output-format=e-ctags']  " universal ctags

let g:gutentags_auto_add_gtags_cscope = 0
let $GTAGSLABEL = 'native-pygments'
" }}}

" LeaderF {{{
let g:Lf_ShortcutF = '<Leader>ff'
"let g:Lf_ShortcutB = '<Leader>fb'
nnoremap <Leader>fm :Leaderf mru<CR>
nnoremap <Leader>fz :Leaderf tag<CR>
nnoremap <Leader>ft :Leaderf bufTag<CR>
nnoremap <Leader>fc :Leaderf function<CR>
nnoremap <Leader>fl :Leaderf line<CR>
nnoremap <Leader>fq :Leaderf quickfix<CR>
nnoremap <Leader>fs :Leaderf self<CR>
nnoremap <Leader>fr :Leaderf! --recall<CR>
nnoremap <Leader>fe :Leaderf rg -e<Space>
nnoremap <Leader>fg :Leaderf git<CR>

let g:Lf_WindowPosition = 'popup'
let g:Lf_CacheDirectory = expand('~/.cache')
let g:Lf_UseCache = 0
let g:Lf_RootMarkers = ['.root', '.project', '.git', '.svn', '.hg']
let g:Lf_WorkingDirectoryMode = 'Ac'
let g:Lf_HideHelp = 1
let g:Lf_PreviewResult = { 'File': 0, 'Buffer': 0, 'Mru': 0, 'Tag': 0, 'BufTag': 0,
      \ 'Function': 0, 'Line': 0, 'Colorscheme': 0, 'Rg': 0, 'Gtags': 0 }

let g:Lf_WildIgnore = {
      \ 'dir': ['.svn', '.git', '.hg', 'node_modules'],
      \ 'file': ['*.sw?', '~$*', '*.bak', '*.exe', '*.o', '*.so', '*.py[co]']
      \ }
let g:Lf_RgConfig = [
      \ '--smart-case',
      \ '--glob=!node_modules/*'
      \ ]
" }}}

let s:home = fnamemodify(resolve(expand('<sfile>:p')), ':h')
command! -nargs=1 SourceScript execute 'source '.s:home.'/'.'<args>'

" Coc
SourceScript init/coc.vim
augroup StartCoc
  autocmd!
  au InsertEnter * packadd vim-snippets | call coc#rpc#start_server() | au! StartCoc
augroup END
