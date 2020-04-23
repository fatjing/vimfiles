" Use Vim defaults. Must put at the start
set nocompatible

filetype plugin indent on
if !exists('g:syntax_on')
  syntax enable
endif

set mouse=nvi
set mousemodel=popup

if has('gui_running')
  set guioptions=
  set winaltkeys=no
  if has('gui_win32')
    set guifont=Consolas:h10
    "set guifontwide=Microsoft\ YaHei\ Mono:h10
    "set renderoptions=type:directx,gamma:1.0,contrast:0.5,level:1,geom:1,renmode:4,taamode:1
  elseif has('gui_gtk')
    set guifont=Inconsolata\ 12
    set guifontwide=WenQuanYi\ Micro\ Hei\ Mono\ 12
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
color hybrid

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
set foldopen+=jump


" Section: message and info display

set lazyredraw
set visualbell

set cursorline
set display=lastline
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
set relativenumber
set scrolloff=1
set sidescrolloff=7

set laststatus=2    " always display status line
set statusline=     " clear the statusline for when vimrc is reloaded
set statusline+=%-n\                                  " buffer number
set statusline+=%<%.79f\                              " file name
set statusline+=[%{strlen(&ft)?&ft:'no\ ft'},         " filetype
set statusline+=%{&bomb?'bom,':''}                    " BOM
set statusline+=%{strlen(&fenc)?&fenc.',':''}         " file encoding
set statusline+=%{&fileformat}]                       " file format
set statusline+=%{fugitive#statusline()}              " FUGITIVE git branch
set statusline+=%m%r%w                                " flags
set statusline+=\ %{coc#status()}%{get(b:,'coc_current_function','')} " coc
set statusline+=%=                                    " left/right separator
set statusline+=%{synIDattr(synID(line('.'),col('.'),1),'name')}   " syntax id
set statusline+=\ 0x%B\ \                             " character under cursor
set statusline+=[%l/%L,%-6(%4(%c%V]%)%)\ %P           " offset

"set noshowmode
set wildmenu                 " enable ctrl-n and ctrl-p to scroll thru matches
set wildmode=list:longest    " make cmdline tab completion similar to bash
set wildignore=*.o,*.obj,*~  " stuff to ignore when tab completing


" Section: key mappings and commands

set timeoutlen=2500    " mapping delay
set ttimeoutlen=80     " key code delay

let mapleader = "\<Space>"

inoremap ;f <Esc>
nnoremap ; :
vnoremap ; :
nnoremap \ ;
vnoremap \ ;

nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

" navigation key bindings for insert and command-line mode
inoremap <C-a> <Home>
inoremap <C-e> <End>
cnoremap <C-a> <C-b>
noremap! <M-b> <C-Left>
noremap! <M-f> <C-Right>
execute "set <M-b>=\eb"
execute "set <M-f>=\ef"

" Break undo before deleting
inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>

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

function! s:preserve_state_run(command)
  " Preparation: save last search, and view of the current window
  let _s=@/
  let l:winview = winsaveview()
  " Do the business
  execute a:command
  " Cleanup: restore previous search history, and view of the window
  let @/=_s
  call winrestview(l:winview)
endfunction
" strip all trailing whitespace in the current file
nnoremap <F4> :call <SID>preserve_state_run("%s/\\s\\+$//e")<CR>

" don't reset the cursor upon returning to a buffer:
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

" dirvish
" Use *-* to open the current file directory
let g:dirvish_mode = ':sort ,^.*[\/],'

" Plugins by tpope {{{
" vim-commentary
" Use *gcc* to comment out a line, *gc* to comment out the target of a motion

" vim-endwise
" end certain structures automatically

" vim-fugitive
" git wrapper

" vim-sleuth
" Automatically adjusts 'shiftwidth' and 'expandtab' heuristically

" vim-surround
" A tool for dealing with pairs of surroundings. See :h surround

" vim-unimpaired
" several pairs of bracket maps
" }}} tpope

" ListToggle
" Toggle quickfix/location list, default keymappings: *<Leader>q* *<Leader>l*

" Lazy load plugin via key mapping
" Pass function name as extra argument for plugin configuration
function! s:pack_add(pack, key, mode, ...) abort
  execute 'unmap ' . a:key
  if a:0 | execute 'call ' . a:1 . '()' | endif
  execute 'packadd ' . a:pack
  if a:mode == 'v' | execute 'normal gv' | endif
  execute 'normal ' . a:key
endfunction

" vim-slime
" Grab some text and 'send' it to a GNU Screen / tmux / whimrepl session.
" Default key binding: <Ctrl-c><Ctrl-c> (hold Ctrl and double-tap c)
if !exists('g:loaded_slime')
  nnoremap <C-c><C-c> :call <SID>pack_add('vim-slime', "\<lt>C-c>\<lt>C-c>", 'n')<CR>
  vnoremap <C-c><C-c> :call <SID>pack_add('vim-slime', "\<lt>C-c>\<lt>C-c>", 'v')<CR>
  let g:slime_target = 'vimterminal'
endif

" scratch.vim
if !exists('g:scratch_insert_autohide')
  nnoremap gs :call <SID>pack_add('scratch.vim', 'gs', 'n')<CR>
  vnoremap gs :call <SID>pack_add('scratch.vim', 'gs', 'v')<CR>
  let g:scratch_insert_autohide = 0
endif

" fencview
" use :FencAutoDetect, or use :FencView and then select from encoding list
if !exists(':FencAutoDetect')
  command FencAutoDetect delc FencAutoDetect | packadd fencview | FencAutoDetect
endif

" Rainbow Parentheses Improved
if !exists(':RainbowToggle')
  command RainbowToggle delc RainbowToggle | packadd rainbow | RainbowToggle
endif
nnoremap <Leader>r :RainbowToggle<CR>
let g:rainbow_active = 0

" VOoM
" Vim Outliner of Markups is a plugin that emulates a two-pane text outliner
if !exists(':Voom')
  command -nargs=* Voom delcommand Voom | packadd VOoM | Voom <args>
endif

" asyncrun.vim
if !exists(':AsyncRun')
  command -bang -nargs=* -range -complete=file AsyncRun delc AsyncRun |
          \ packadd asyncrun.vim | <line1>,<line2>AsyncRun<bang> <args>
  " cooperate with fugitive
  command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>
endif
let g:asyncrun_bell = 1
let g:asyncrun_open = 15
if has('win32')
  let g:asyncrun_encs = 'cp936'
endif

" vim-easy-align
if !exists(':EasyAlign')
  command -range -nargs=* EasyAlign delcommand EasyAlign |
          \ packadd vim-easy-align | <line1>,<line2>EasyAlign <args>
endif

" vim-gutentags {{{
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
" }}} vim-gutentags

" LeaderF {{{
let g:Lf_ShortcutF = '<Leader>ff'
"let g:Lf_ShortcutB = '<Leader>fb'
nnoremap <Leader>fm :Leaderf mru<CR>
nnoremap <Leader>fp :Leaderf! function<CR>
nnoremap <Leader>ft :Leaderf! bufTag<CR>
nnoremap <Leader>fl :Leaderf line<CR>
nnoremap <Leader>fe :Leaderf rg --wd-mode=c -e<Space>
nnoremap <Leader>fr :Leaderf! --recall<CR>

let g:Lf_WindowPosition = 'popup'
let g:Lf_PreviewInPopup = 1
let g:Lf_PopupHeight = 0.5
let g:Lf_ShowRelativePath = 0
let g:Lf_CacheDirectory = expand('~/.cache')
let g:Lf_RootMarkers = ['.root', '.project', '.git', '.svn', '.hg']
let g:Lf_WorkingDirectoryMode = 'Ac'
let g:Lf_HideHelp = 1

let g:Lf_WildIgnore = {
      \ 'dir': ['.svn', '.git', '.hg', 'node_modules'],
      \ 'file': ['*.sw?', '~$*', '*.bak', '*.exe', '*.o', '*.so', '*.py[co]']
      \ }
" }}} LeaderF

" Coc
let s:home = fnamemodify(resolve(expand('<sfile>:p')), ':h')
command! -nargs=1 SourceScript exec 'so '.s:home.'/'.'<args>'
SourceScript init/coc.vim
