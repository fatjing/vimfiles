" Plugin on-demand loading

if exists('g:autoloaded_load_plugin')
  finish
endif
let g:autoloaded_load_plugin = 1

" to list
function! s:to_a(v)
  return type(a:v) == type([]) ? a:v : [a:v]
endfunction

" load plugin on event
function! load_plugin#load_on_evnt(pack, event, pat)
  augroup LoadPlugin
    execute printf(
      \ 'autocmd %s %s ++once packadd %s',
      \ a:event, a:pat, a:pack)
  augroup END
endfunction

" load plugin on command
function! load_plugin#load_on_cmd(pack, cmds)
  for cmd in s:to_a(a:cmds)
    call s:load_on_cmd_helper(a:pack, cmd)
  endfor
endfunction

function! s:load_on_cmd_helper(pack, cmd)
  if !exists(':'.a:cmd)
    execute printf(
      \ 'command! -nargs=* -range -bang -complete=file %s delc %s | packadd %s | call s:exe_cmd(%s, "<bang>", <line1>, <line2>, <q-args>)',
      \ a:cmd, a:cmd, a:pack, string(a:cmd))
  endif
endfunction

function! s:exe_cmd(cmd, bang, l1, l2, args)
  execute printf('%s%s%s %s', (a:l1 == a:l2 ? '' : (a:l1.','.a:l2)), a:cmd, a:bang, a:args)
endfunction

" load plugin on mapping
function! load_plugin#load_on_map(pack, map, modes)
  for mode in a:modes
    execute printf(
      \ '%snoremap <silent> %s %s:<C-U>call <SID>exe_map(%s, %s, %s)<CR>',
      \ mode, a:map, mode=='i'?'<C-O>':'', string(a:pack), string(substitute(a:map, '<', '\<lt>', 'g')), string(mode))
  endfor
endfunction

function! s:exe_map(pack, map, mode)
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
