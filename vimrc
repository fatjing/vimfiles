" Use Vim defaults. Must put at the start
set nocompatible

filetype plugin indent on
if !exists('g:syntax_on')
  syntax enable
endif


" Section: ui settings

set mouse=nvi
set mousemodel=popup

if has('gui_running')
  set guioptions=
  set winaltkeys=no
  if has('gui_win32')
    set guifont=Consolas:h10
    "set guifontwide=NSimSun:h11
  elseif has('gui_gtk')
    set guifont=Inconsolata\ 11
    set guifontwide=Sarasa\ Mono\ SC\ 11
  endif
else
  set background=dark
endif

if &term =~ '256color' && $TMUX != ''
  " disable Background Color Erase (BCE) so that color schemes
  " render properly when inside 256-color tmux and GNU screen.
  " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
  set t_ut=
endif

" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^linux\|^Eterm'
  set t_Co=16
endif

silent! color iceberg


" Section: general settings

if has('path_extra')
  setglobal tags-=./tags tags-=./tags; tags^=./tags;
endif

if !empty(&viminfo)
  set viminfo^=!
endif
set history=5000    " cmdline history
set sessionoptions-=options

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
set smoothscroll


" Section: message and info display

set lazyredraw
set visualbell

set cursorline
set display=lastline
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
set relativenumber
set signcolumn=number
set scrolloff=1
set sidescrolloff=7

set laststatus=2    " always display status line
set statusline=     " clear the statusline for when vimrc is reloaded
set statusline+=%<%.79{expand('%:~:.')}\              " relative path
set statusline+=[%{&ft==''?'no\ ft':&ft},             " filetype
set statusline+=%{&bomb?'bom,':''}                    " BOM
set statusline+=%{&fenc==''?&enc:&fenc},              " file encoding
set statusline+=%{&ff}]                               " file format
set statusline+=%{fugitive#statusline()}              " FUGITIVE git branch
set statusline+=%m%r%w                                " flags
set statusline+=%{gutentags#statusline('\ ')}         " Gutentags
set statusline+=%=                                    " left/right separator
set statusline+=%{synIDattr(synID(line('.'),col('.'),1),'name')}   " syntax id
set statusline+=\ 0x%B\                               " character under cursor
set statusline+=[%l/%L,%-6(%4(%c%V]%)%)%P             " offset

"set noshowmode
set wildmenu                 " enable ctrl-n and ctrl-p to scroll thru matches
set wildmode=list:longest    " make cmdline tab completion similar to bash
set wildignore=*.o,*.obj,*~  " stuff to ignore when tab completing
set wildignore+=*/.git/*,*/.svn/*,*/node_modules/*


" Section: key mappings and commands

set timeoutlen=2500    " mapping delay
set ttimeoutlen=80     " key code delay

let mapleader = "\<Space>"

nnoremap ; :
vnoremap ; :
nnoremap \ ;
vnoremap \ ;

" movement enhancement
inoremap <C-a> <Home>
inoremap <C-e> <End>
cnoremap <C-a> <C-b>
noremap! <C-d> <Del>
noremap! <M-b> <C-Left>
noremap! <M-f> <C-Right>
noremap! <M-h> <C-Left>
noremap! <M-l> <C-Right>

nnoremap <M-j> gj
nnoremap <M-k> gk
tnoremap <M-n> <C-\><C-n>

" fix alt key as meta key, see :set-termcap
if !has('gui_running') && !has('nvim')
  for i in range(26)
    let key = nr2char(char2nr('a') + i)
    execute "set <M-".key.">=\e".key
  endfor
endif

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

" search and substitute
set ignorecase
set smartcase
set incsearch
set hlsearch
nnoremap / /\v
vnoremap / /\v
nnoremap <Leader>s :%s/
nnoremap <silent> <Leader>h :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR>

" split windows
set splitright
nnoremap <Leader>w <C-W>
nnoremap <Leader>v <C-W>v
nnoremap <C-J> <C-W>w
nnoremap <C-K> <C-W>W
nnoremap <C-H> <C-W>h
nnoremap <C-L> <C-W>l

" copy to / paste from system clipboard
nnoremap <Leader>y "+y
vnoremap <Leader>y "+y
nnoremap <Leader>p "+p
vnoremap <Leader>p "+p

" cycle through numbered registers
" first do '"1p' and then do 'u.' repeatedly, see |redo-register|
nnoremap <Leader>1 "1p
nnoremap <Leader>0 "0p

" set working directory to the current file
nnoremap <Leader>wd :cd %:p:h<CR>:pwd<CR>

" reselect last paste
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" edit .vimrc file on the fly
nnoremap <Leader>ev <C-W>v<C-W>l:e $MYVIMRC<CR>

" fold tag
nnoremap <Leader>FT Vatzf

function! s:preserve_state_run(command)
  " Preparation: save last search, and view of the current window
  let l:search=@/
  let l:winview = winsaveview()
  " Do the business
  execute a:command
  " Cleanup: restore previous search history, and view of the window
  let @/=l:search
  call winrestview(l:winview)
endfunction
" strip all trailing whitespace in the current file
nnoremap <F4> :call <SID>preserve_state_run("%s/\\s\\+$//e")<CR>

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
let g:netrw_browse_split = 4
let g:netrw_home = expand('~/.cache/netrw')
let g:netrw_liststyle = 3
let g:netrw_winsize = 25

" vim-dirvish
" Use `-` to open the current file directory
let g:dirvish_mode = ':sort ,^.*[\/],'

" vim-sneak
" Type `s` followed by two characters to move; use `z` for operations
let g:sneak#s_next = 1
let g:sneak#use_ic_scs = 1

" vim-commentary
" Use `gcc` to comment out a line, `gc` to comment out the target of a motion
call load_plugin#load_on_map('vim-commentary', 'gc', 'nv')

" vim-endwise
" End certain structures automatically
"call load_plugin#load_on_evnt('vim-endwise', 'InsertEnter', '*')

" vim-surround
" A tool for dealing with pairs of surroundings. See :h surround

" vim-unimpaired
" Provide several pairs of bracket maps. See :h unimpaired

" ListToggle
" Toggle quickfix/location list, default keymappings: `<Leader>q` `<Leader>l`
call load_plugin#load_on_map('ListToggle', '<Space>q', 'n')
let g:lt_height = 12

" vim-flog
call load_plugin#load_on_cmd('vim-flog', 'Flog')

" scratch.vim
call load_plugin#load_on_map('scratch.vim', 'gs', 'nv')
let g:scratch_autohide = 0
let g:scratch_insert_autohide = 0

" fencview
" use :FencAutoDetect, or use :FencView and then select from encoding list
call load_plugin#load_on_cmd('fencview', 'FencAutoDetect')

" Rainbow Parentheses Improved
call load_plugin#load_on_cmd('rainbow', 'RainbowToggle')
nnoremap <Leader>r :RainbowToggle<CR>
let g:rainbow_active = 0

" VOoM
" Vim Outliner of Markups is a plugin that emulates a two-pane text outliner
call load_plugin#load_on_cmd('VOoM', 'Voom')

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

" vim-easy-align
call load_plugin#load_on_cmd('vim-easy-align', 'EasyAlign')

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
" }}} vim-gutentags

" LeaderF {{{
let g:Lf_ShortcutF = '<Leader>ff'
"let g:Lf_ShortcutB = '<Leader>fb'
nnoremap <Leader>fm :Leaderf mru<CR>
nnoremap <Leader>ft :Leaderf tag<CR>
nnoremap <Leader>fo :Leaderf bufTag<CR>
nnoremap <Leader>fg :Leaderf function<CR>
nnoremap <Leader>fl :Leaderf line<CR>
nnoremap <Leader>fs :Leaderf self<CR>
nnoremap <Leader>fe :Leaderf rg -e<Space>
nnoremap <Leader>fr :Leaderf! --recall<CR>
nnoremap <Leader>fq :Leaderf quickfix<CR>

let g:Lf_WindowPosition = 'popup'
let g:Lf_CacheDirectory = expand('~/.cache')
let g:Lf_UseCache = 0
let g:Lf_RootMarkers = ['.root', '.project', '.git', '.svn', '.hg']
let g:Lf_WorkingDirectoryMode = 'Ac'
let g:Lf_HideHelp = 1
let g:Lf_GtagsAutoUpdate = 0

let g:Lf_WildIgnore = {
      \ 'dir': ['.svn', '.git', '.hg', 'node_modules'],
      \ 'file': ['*.sw?', '~$*', '*.bak', '*.exe', '*.o', '*.so', '*.py[co]']
      \ }
let g:Lf_RgConfig = [
      \ '--smart-case',
      \ '--glob=!node_modules/*'
      \ ]
" }}} LeaderF

let s:home = fnamemodify(resolve(expand('<sfile>:p')), ':h')
command! -nargs=1 SourceScript execute 'source '.s:home.'/'.'<args>'

" Coc
SourceScript init/coc.vim
augroup StartCoc
  autocmd!
  au InsertEnter * packadd vim-snippets | call coc#rpc#start_server() | au! StartCoc
augroup END
