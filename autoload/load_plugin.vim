" Plugin on-demand loading

if exists('g:autoloaded_load_plugin')
  finish
endif
let g:autoloaded_load_plugin = 1

" to list
function! s:to_a(v)
  return type(a:v) == type([]) ? a:v : [a:v]
endfunction

function! s:dummy()
endfunction
let g:load_plugin_callbacks = {}

" load plugin on event
function! load_plugin#load_on_evnt(pack, event, pat, ...)
  let g:load_plugin_callbacks[a:pack] = a:0 > 0 ? a:1 : function('s:dummy')
  augroup LoadPlugin
    execute printf(
      \ 'autocmd %s %s ++once call g:load_plugin_callbacks[%s]() | packadd %s',
      \ a:event, a:pat, string(a:pack), a:pack)
  augroup END
endfunction

" load plugin on command
function! load_plugin#load_on_cmd(pack, cmds, ...)
  let g:load_plugin_callbacks[a:pack] = a:0 > 0 ? a:1 : function('s:dummy')
  for cmd in s:to_a(a:cmds)
    if !exists(':'.cmd)
      execute printf(
        \ 'command! -nargs=* -range -bang -complete=file %s delc %s | call g:load_plugin_callbacks[%s]() | packadd %s | call s:exe_cmd(%s, "<bang>", <line1>, <line2>, <q-args>)',
        \ cmd, cmd, string(a:pack), a:pack, string(cmd))
    endif
  endfor
endfunction

function! s:exe_cmd(cmd, bang, l1, l2, args)
  execute printf('%s%s%s %s', (a:l1 == a:l2 ? '' : (a:l1.','.a:l2)), a:cmd, a:bang, a:args)
endfunction

" load plugin on mapping
function! load_plugin#load_on_map(pack, map, modes, ...)
  let g:load_plugin_callbacks[a:pack] = a:0 > 0 ? a:1 : function('s:dummy')
  for mode in split(a:modes, '\zs')
    execute printf(
      \ '%snoremap <silent> %s %s:<C-U>call g:load_plugin_callbacks[%s]() <Bar> call <SID>exe_map(%s, %s, %s)<CR>',
      \ mode, a:map, mode=='i'?'<C-O>':'', string(a:pack), string(a:pack), string(substitute(a:map, '<', '\<lt>', 'g')), string(mode))
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
