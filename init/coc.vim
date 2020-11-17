" coc.nvim settings

let g:coc_config_home = fnamemodify(resolve(expand('<sfile>:p')), ':h')
" let g:coc_global_extensions = ['coc-pairs', 'coc-snippets', 'coc-tag', 'coc-json',
"       \ 'coc-html', 'coc-css', 'coc-eslint', 'coc-tsserver', 'coc-vetur',
"       \ 'coc-python', 'coc-java'
"       \ ]

exe 'let &statusline="'.substitute(&statusline, '%=', " %{coc#status()}%{get(b:,'coc_current_function','')}%=", '').'"'
"set cmdheight=2
set updatetime=300
set shortmess+=c
"set signcolumn=number

" Use tab for trigger completion with characters ahead and navigate
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" : coc#refresh()

inoremap <expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~# '\s'
endfunction

" Use <CR> to confirm completion and notify coc.nvim to format on enter
inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm() :
      \ "\<C-g>u\<CR>\<C-r>=coc#on_enter()\<CR>"

" Use <C-j> for both snippet expand and jump
imap <C-j> <Plug>(coc-snippets-expand-jump)

" Use <c-space> to trigger completion
inoremap <silent><expr> <c-space> coc#refresh()

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> <leader>gd <Plug>(coc-definition)
nmap <silent> <leader>gy <Plug>(coc-type-definition)
nmap <silent> <leader>gi <Plug>(coc-implementation)
nmap <silent> <leader>gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Symbol renaming
nmap <leader>gn <Plug>(coc-rename)

" Formatting selected code
xmap <leader>gq <Plug>(coc-format-selected)
nmap <leader>gq <Plug>(coc-format-selected)

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Apply codeAction to the selected region
xmap <leader>ga <Plug>(coc-codeaction-selected)
nmap <leader>ga <Plug>(coc-codeaction-selected)

" Apply AutoFix to problem on the current line
nmap <leader>gf <Plug>(coc-fix-current)

" Map function and class text objects
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" coc-yank
nnoremap <silent> <leader>fy :<C-u>CocList --normal yank<CR>
