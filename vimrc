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

" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^linux\|^Eterm'
  set t_Co=16
endif
"let base16colorspace=256
"color base16-tomorrow-night
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
set breakindent      " wrapped line continue visually indented

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
set statusline+=%-n\                                  " buffer number
set statusline+=%<%.79f\                              " file name
set statusline+=[%{strlen(&ft)?&ft:'n/a'},            " filetype
set statusline+=%{&bomb?'bom,':''}                    " BOM
set statusline+=%{&fenc},                             " file encoding
set statusline+=%{&fileformat}]                       " file format
set statusline+=%{fugitive#statusline()}              " FUGITIVE git branch
set statusline+=%m%r%w                                " flags
set statusline+=%=                                    " left/right separator
set statusline+=%{synIDattr(synID(line('.'),col('.'),1),'name')}   " syntax id
set statusline+=\ 0x%B\ \                             " character under cursor
set statusline+=[%l/%L,%-4(%3(%c%V]%)%)\ %P           " offset

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

" Plugins by tpope {{{
"
" vim-abolish
" find, substitute, and abbreviate several variations of a word at once

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

" vim-closer
" closes brackets when pressing Enter

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

" ultisnips
if !exists(':UltiSnipsEdit')
  augroup LoadUltiSnips
    autocmd!
    au InsertEnter * ++once packadd vim-snippets | packadd ultisnips
  augroup END
endif
let g:UltiSnipsExpandTrigger = '<C-j>'

" YouCompleteMe {{{
if !exists('g:loaded_youcompleteme')
  augroup LoadYouCompleteMe
    autocmd!
    au InsertEnter * ++once packadd YouCompleteMe
  augroup END
endif
let g:ycm_add_preview_to_completeopt = 0
let g:ycm_show_diagnostics_ui = 0
let g:ycm_min_num_identifier_candidate_chars = 2
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_key_invoke_completion = '<C-z>'
noremap <C-z> <NOP>
set completeopt=menu,menuone

let g:ycm_semantic_triggers =  {
            \ 'c,cpp,python,java,go,erlang,perl': ['re!\w{2}'],
            \ 'cs,lua,javascript': ['re!\w{2}'],
            \ }
"let g:ycm_key_detailed_diagnostics = '<Leader>d'
" }}} YCM

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

" ale {{{
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
" }}} ale

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

