" coc.nvim settings

set updatetime=300
" execute 'let &statusline="'.substitute(&statusline, '%=', ' %{coc#status()}%=', '').'"'

let g:coc_start_at_startup = 0
let g:coc_config_home = fnamemodify(resolve(expand('<sfile>:p')), ':h')
" let g:coc_global_extensions = ['coc-pairs', 'coc-snippets', 'coc-tag', 'coc-word', 'coc-json']

" Use tab for trigger completion with characters ahead and navigate
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ <SID>check_backspace() ? "\<TAB>" : coc#refresh()

inoremap <expr> <S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<S-TAB>"

function! s:check_backspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~# '\s'
endfunction

" Use <CR> to confirm completion and notify coc.nvim to format on enter
inoremap <silent><expr> <CR>
      \ coc#pum#visible() && coc#pum#info()['index'] != -1 ? coc#pum#confirm() :
      \ "\<C-g>u\<CR>\<C-r>=coc#on_enter()\<CR>\<C-r>=EndwiseDiscretionary()\<CR>"

" Use <C-j> for both snippet expand and jump
imap <C-j> <Plug>(coc-snippets-expand-jump)

" Use <C-e> to cancel completion or move cursor to end of line
inoremap <silent><expr> <C-e> coc#pum#visible() ? coc#pum#cancel() : "\<End>"

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
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'ni')
  endif
endfunction

" Highlight symbol and its references
nmap <silent> <leader>ah :call CocActionAsync('highlight')<CR>

" Symbol renaming
nmap <leader>an <Plug>(coc-rename)

" Formatting selected code
xmap <leader>gq <Plug>(coc-format-selected)
nmap <leader>gq <Plug>(coc-format-selected)

augroup MyCocEventGroup
  autocmd!
  " Setup formatexpr specified filetype(s)
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Apply code actions to the selected code block
xmap <leader>a <Plug>(coc-codeaction-selected)
nmap <leader>a <Plug>(coc-codeaction-selected)

" Apply code actions to the current buffer
nmap <leader>ab <Plug>(coc-codeaction-source)

" Apply code actions at the cursor position
nmap <leader>ac <Plug>(coc-codeaction-cursor)

" Apply quickfix action to fix diagnostic on the current line
nmap <leader>af <Plug>(coc-fix-current)

" Apply refactor code actions
nmap <leader>ar <Plug>(coc-codeaction-refactor)

" Run Code Lens action on the current line
nmap <leader>al <Plug>(coc-codelens-action)

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

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR :call CocActionAsync('runCommand', 'editor.action.organizeImport')

" Mappings for CoCList
" Show all diagnostics
nnoremap <silent><nowait> <Leader>ld :CocList diagnostics<CR>
" Show commands
nnoremap <silent><nowait> <Leader>lc :CocList commands<CR>
" Find symbol of current document
nnoremap <silent><nowait> <Leader>lo :CocList outline<CR>
" Search workspace symbols
nnoremap <silent><nowait> <Leader>ls :CocList -I symbols<CR>
" Do default action for next item
nnoremap <silent><nowait> <Leader>lj :CocNext<CR>
" Do default action for previous item
nnoremap <silent><nowait> <Leader>lk :CocPrev<CR>
" Resume latest coc list
nnoremap <silent><nowait> <Leader>lr :CocListResume<CR>

" coc-explorer
noremap <Leader>ex <Cmd>CocCommand explorer<CR>
