" vim-color-patch
let g:cpatch_path = g:vimrc_path..'/colors/patch'

" vim-dirvish
" Use `-` to open the current file directory
let g:dirvish_mode = ':sort i ,^.*[\/],'

" vim-sneak
" Type `s` followed by two characters to move; use `z` for operations
let g:sneak#s_next = 1
let g:sneak#use_ic_scs = 1

" vim-endwise
" End certain structures automatically
"call load_plugin#load_on_evnt('vim-endwise', 'InsertEnter', '*')

" vim-fugitive
nnoremap <Leader>i :Git<CR>

" vim-surround
" A tool for dealing with pairs of surroundings. See :h surround

" vim-unimpaired
" Provide several pairs of bracket maps. See :h unimpaired

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

" vim-easy-align
call load_plugin#load_on_cmd('vim-easy-align', 'EasyAlign')

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

" Coc
autocmd mygroup InsertEnter * ++once packadd vim-snippets | call coc#rpc#start_server()

" LeaderF {{{
let g:Lf_HideHelp = 1
let g:Lf_UseCache = 0
let g:Lf_MruMaxFiles = 2000
let g:Lf_WindowPosition = 'popup'
let g:Lf_CacheDirectory = expand('~/.cache')
let g:Lf_RootMarkers = ['.root', '.project', '.git', '.svn', '.hg']
let g:Lf_WorkingDirectoryMode = 'Ac'
let g:Lf_PreviewResult = { 'File': 0, 'Buffer': 0, 'Mru': 0, 'Tag': 0, 'BufTag': 0,
      \ 'Function': 0, 'Line': 0, 'Colorscheme': 1, 'Rg': 0, 'Gtags': 0 }
let g:Lf_WildIgnore = {
      \ 'dir': ['.svn', '.git', '.hg', 'node_modules'],
      \ 'file': ['*.sw?', '~$*', '*.bak', '*.exe', '*.o', '*.so', '*.py[co]']
      \ }
let g:Lf_RgConfig = [
      \ '--smart-case',
      \ '--glob=!node_modules/*'
      \ ]

let g:Lf_ShortcutF = '<Leader>ff'
"let g:Lf_ShortcutB = '<Leader>b'
nnoremap <Leader>fm :Leaderf mru<CR>
nnoremap <Leader>ft :Leaderf bufTag<CR>
nnoremap <Leader>fc :Leaderf function<CR>
nnoremap <Leader>fl :Leaderf line<CR>
nnoremap <Leader>fq :Leaderf quickfix<CR>
nnoremap <Leader>fs :Leaderf self<CR>
nnoremap <Leader>fg :Leaderf git<CR>
nnoremap <Leader>fe :Leaderf rg --bottom -e<Space>

nnoremap <Leader>fr :Leaderf! --recall<CR>
noremap <Leader>fn <Cmd>Leaderf --next<CR>
noremap <Leader>fp <Cmd>Leaderf --previous<CR>

let g:Lf_Gtagslabel = 'native-pygments'
nnoremap <Leader>cu :Leaderf gtags --update<CR>
noremap <leader>cd :<C-U><C-R>=printf("Leaderf! gtags -d %s --auto-jump", expand("<cword>"))<CR><CR>
noremap <leader>cr :<C-U><C-R>=printf("Leaderf! gtags -r %s --auto-jump", expand("<cword>"))<CR><CR>
noremap <leader>cc :<C-U><C-R>=printf("Leaderf! gtags --by-context --auto-jump")<CR><CR>
" }}}

" lightline.vim {{{
let g:lightline = {
  \   'colorscheme': 'iceberg',
  \   'active': {
  \     'left': [['mode', 'paste'], ['relativepath', 'modified', 'readonly'],
  \              ['fileinfo'], ['gitbranch'], ['cocstatus']],
  \     'right': [['lineinfo'], ['percent'], ['searchcount'], ['charvaluehex'],
  \               ['syntax_id']]
  \   },
  \   'component': {
  \     'relativepath': '%<%f',
  \     'lineinfo': '%3l/%L:%-2v',
  \     'fileinfo': '[%{&ft!=#""?&ft:"no ft"}, %{&fenc!=#""?&fenc:&enc}%{&bomb?", bom":""}%{&ff!=#"unix"?", "..&ff:""}]',
  \     'searchcount': '%{v:hlsearch?LastSearchCount():""}'
  \   },
  \   'component_function': {
  \     'gitbranch': 'FugitiveHead',
  \     'cocstatus': 'coc#status',
  \     'syntax_id': 'StatuslineGetSyntaxID'
  \   }
  \ }

" update lightline colorscheme in sync with vim colorscheme
autocmd mygroup ColorScheme * call s:lightline_update()

function! s:lightline_update()
  if !exists('g:loaded_lightline')
    return
  endif
  try
    let g:lightline.colorscheme = g:colors_name
    call lightline#init()
    call lightline#colorscheme()
    call lightline#update()
  catch
  endtry
endfunction
" }}}
