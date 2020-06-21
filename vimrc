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
silent! color hybrid

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
set statusline+=[%{&ft==''?'no\ ft':&ft},             " filetype
set statusline+=%{&bomb?'bom,':''}                    " BOM
set statusline+=%{&fenc==''?&enc:&fenc},              " file encoding
set statusline+=%{&ff}]                               " file format
set statusline+=%{fugitive#statusline()}              " FUGITIVE git branch
set statusline+=%m%r%w                                " flags
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

" navigation key bindings for insert and command-line mode
inoremap <C-A> <Home>
inoremap <C-E> <End>
cnoremap <C-A> <C-B>
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
nnoremap <silent> <Left> :bprev<CR>
nnoremap <silent> <Right> :bnext<CR>
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
nnoremap <Leader>w <C-W>
" open a new vertical split and switch over to it
nnoremap <Leader>v <C-W>v<C-W>l
" navigate through split windows
nnoremap <C-J> <C-W>w
nnoremap <C-K> <C-W>W

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
nnoremap <Leader>ev <C-W>v<C-W>l:e $MYVIMRC<CR>

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

" Plugin on-demand loading {{{
" Load plugin on event
function s:load_on_evnt(pack, event, pat)
  augroup LoadPlugin
    execute printf(
      \ 'autocmd %s %s ++once packadd %s',
      \ a:event, a:pat, a:pack)
  augroup END
endfunction

" Load plugin on command
function s:load_on_cmd(pack, cmd)
  if !exists(':'.a:cmd)
    execute printf(
      \ 'command! -nargs=* -range -bang -complete=file %s delc %s | packadd %s | call s:exe_cmd(%s, "<bang>", <line1>, <line2>, <q-args>)',
      \ a:cmd, a:cmd, a:pack, string(a:cmd))
  endif
endfunction

function s:exe_cmd(cmd, bang, l1, l2, args)
  execute printf('%s%s%s %s', (a:l1 == a:l2 ? '' : (a:l1.','.a:l2)), a:cmd, a:bang, a:args)
endfunction

" Load plugin on mapping
function s:load_on_map(pack, map, modes)
  for mode in a:modes
    execute printf(
      \ '%snoremap <silent> %s %s:<C-U>call <SID>exe_map(%s, %s, %s)<CR>',
      \ mode, a:map, mode=='i'?'<C-O>':'', string(a:pack), string(substitute(a:map, '<', '\<lt>', 'g')), string(mode))
  endfor
endfunction

function s:exe_map(pack, map, mode)
  execute 'silent! unmap' a:map
  execute 'silent! iunmap' a:map
  execute 'packadd' a:pack
  if a:mode != 'i'
    let prefix = v:count ? v:count : ''
    let prefix .= '"'.v:register
    if a:mode == 'v' | let prefix .= 'gv' | endif
    if mode(1) == 'no'
      if v:operator == 'c'
        let prefix = "\<Esc>" . prefix
      endif
      let prefix .= v:operator
    endif
    call feedkeys(prefix, 'n')
  endif
  execute 'call feedkeys("' . substitute(a:map, '<', '\\<', 'g') . '")'
endfunction
" }}}

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

" vim-slime
" Grab some text and 'send' it to a GNU Screen / tmux / whimrepl session.
" Default key binding: <Ctrl-c><Ctrl-c> (hold Ctrl and double-tap c)
call s:load_on_map('vim-slime', '<C-C><C-C>', ['n', 'v'])
let g:slime_target = 'vimterminal'

" scratch.vim
call s:load_on_map('scratch.vim', 'gs', ['n', 'v'])
let g:scratch_insert_autohide = 0

" fencview
" use :FencAutoDetect, or use :FencView and then select from encoding list
call s:load_on_cmd('fencview', 'FencAutoDetect')

" Rainbow Parentheses Improved
call s:load_on_cmd('rainbow', 'RainbowToggle')
nnoremap <Leader>r :RainbowToggle<CR>
let g:rainbow_active = 0

" VOoM
" Vim Outliner of Markups is a plugin that emulates a two-pane text outliner
call s:load_on_cmd('VOoM', 'Voom')

" asyncrun.vim
call s:load_on_cmd('asyncrun.vom', 'AsyncRun')
let g:asyncrun_bell = 1
let g:asyncrun_open = 15
if has('win32')
  let g:asyncrun_encs = 'cp936'
endif
" cooperate with fugitive
command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>

" vim-easy-align
call s:load_on_cmd('vim-easy-align', 'EasyAlign')

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
command! -nargs=1 SourceScript execute 'source '.s:home.'/'.'<args>'
augroup LoadCoc
  autocmd!
  au InsertEnter * SourceScript init/coc.vim | packadd coc.nvim-release | au! LoadCoc
augroup END
