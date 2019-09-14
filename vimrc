" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

filetype plugin indent on
if !exists('g:syntax_on')
  syntax enable
endif

if has('gui_running')
  set guioptions=
  if has('gui_win32')
    set guifont=Consolas:h10
    " set guifontwide=Microsoft\ YaHei\ Mono:h10.5
    " set renderoptions=type:directx,gamma:1.0,contrast:0.5,level:1,geom:1,renmode:4,taamode:1
  elseif has('gui_gtk')
    set guifont=Inconsolata\ 12
    set guifontwide=WenQuanYi\ Micro\ Hei\ Mono\ 12
  endif
else
  set noicon
  set background=dark
endif

" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^linux\|^Eterm'
  set t_Co=16
endif
"let base16colorspace=256
"color base16-tomorrow-night
color hybrid

set mouse=nvi
set mousemodel=popup
set winaltkeys=no

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

set smarttab        " tab in front of a line depends on 'shiftwidth'
set tabstop=4       " number of spaces per tab for display
set shiftwidth=4    " number of spaces to use for each step of (auto)indent
set softtabstop=4   " number of spaces per tab in insert mode
set expandtab       " in insert mode: use spaces to insert a <Tab>
set autoindent      " automatically indent to match adjacent line
set breakindent     " wrapped line continue visually indented

set foldmethod=marker
set foldopen+=jump


" Section: message and info display

set lazyredraw
set visualbell

set display=lastline
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
set relativenumber
set scrolloff=1
set sidescrolloff=7

set laststatus=2    " always display status line
set statusline=     " clear the statusline for when vimrc is reloaded
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

set showmode
set wildmenu    " enable ctrl-n and ctrl-p to scroll thru matches
set wildmode=list:longest    " make cmdline tab completion similar to bash
set wildignore=*.o,*.obj,*~  " stuff to ignore when tab completing


" Section: key mappings and commands

set timeoutlen=2500    " mapping delay
set ttimeoutlen=100    " key code delay

let mapleader = "\<Space>"

inoremap ;f <Esc>
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;

nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

" Allow undoing <C-U> (delete text typed in current line)
inoremap <C-U> <C-G>u<C-U>
" Make Y consistent with C and D. See :help Y
nnoremap Y y$

" buffer navigation
nnoremap <silent> <left> :bprev<CR>
nnoremap <silent> <right> :bnext<CR>
"nnoremap <Leader>b :ls<CR>:e #

" searching and substituting
set gdefault
set ignorecase
set smartcase
set incsearch
set hlsearch
nnoremap / /\v
vnoremap / /\v
nnoremap <Leader>s :%s/
nnoremap <silent> <Leader>h :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR>

set diffopt+=indent-heuristic,algorithm:histogram
set diffopt+=vertical  " start diff mode with vertical splits

set splitright
nnoremap <Leader>w <C-w>
" open a new vertical split and switch over to it
nnoremap <Leader>v <C-w>v<C-w>l
" navigate through split windows
nnoremap <C-j> <C-w>w
nnoremap <C-k> <C-w>W

" copy to / paste from system clipboard
nnoremap <Leader>y "+y
vnoremap <Leader>y "+y
nnoremap <Leader>p "+p
vnoremap <Leader>p "+p

" set working directory to the current file
nnoremap <Leader>d :cd %:p:h<CR>:pwd<CR>

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

" don't reset the cursor upon returning to a buffer:
if &startofline
  augroup StayPut
    au!
    autocmd BufLeave * set nostartofline |
    \ autocmd StayPut CursorMoved,CursorMovedI * set startofline |
    \ autocmd! StayPut CursorMoved,CursorMovedI
  augroup END
endif

if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
          \ | wincmd p | diffthis
endif


" Section: plugin shortcuts and settings

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

" UltiSnips
let g:UltiSnipsExpandTrigger = '<C-j>'

" YouCompleteMe {{{
let g:ycm_add_preview_to_completeopt = 0
let g:ycm_show_diagnostics_ui = 0
let g:ycm_server_log_level = 'info'
let g:ycm_min_num_identifier_candidate_chars = 2
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_complete_in_strings=1
let g:ycm_key_invoke_completion = '<C-z>'
noremap <C-z> <NOP>
set completeopt=menu,menuone

let g:ycm_semantic_triggers =  {
            \ 'c,cpp,python,java,go,erlang,perl': ['re!\w{2}'],
            \ 'cs,lua,javascript': ['re!\w{2}'],
            \ }
"let g:ycm_key_detailed_diagnostics = '<Leader>d'
" }}} YCM

" Gutentags {{{
let g:gutentags_project_root = ['.root', '.project', '.git', '.svn', '.hg']
let g:gutentags_ctags_tagfile = '.tags'
let g:gutentags_cache_dir = expand('~/.cache/tags')

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
let g:gutentags_ctags_extra_args += ['--output-format=e-ctags']  " universal ctags
let g:gutentags_auto_add_gtags_cscope = 0
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

" LeaderF {{{
let g:Lf_ShortcutF = '<Leader>ff'
let g:Lf_ShortcutB = '<Leader>b'
nnoremap <Leader>fm :Leaderf mru<CR>
nnoremap <Leader>fp :Leaderf! function<CR>
nnoremap <Leader>ft :Leaderf tag<CR>
nnoremap <Leader>fl :Leaderf line<CR>
nnoremap <Leader>fe :Leaderf rg --wd-mode=c -e<Space>
nnoremap <Leader>fr :LeaderfRgRecall<CR>

let g:Lf_WindowHeight = 0.40
let g:Lf_ShowRelativePath = 0
let g:Lf_CacheDirectory = expand('~/.cache')
let g:Lf_PreviewResult = {'Function': 0, 'BufTag': 0}
let g:Lf_RootMarkers = ['.root', '.project', '.git', '.svn', '.hg']
let g:Lf_WorkingDirectoryMode = 'Ac'
let g:Lf_HideHelp = 1
" }}} LeaderF

