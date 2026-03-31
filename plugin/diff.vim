" https://gist.github.com/romainl/7198a63faffdadd741e4ae81ae6dd9e6
" usage: `:Diff`, `:Diff <git revision>`
command! -nargs=? Diff call <SID>Diff(<q-args>)

function! s:Diff(spec)
  vertical new
  setlocal bufhidden=wipe buftype=nofile nobuflisted noswapfile
  if len(a:spec)
    let cmd = "!git -C #:p:h:S show "..a:spec..":./#:t:S"
  else
    let cmd = "++edit #"
  endif
  execute "read "..cmd
  silent 0d_
  diffthis
  wincmd p
  diffthis
endfunction

" usage: `:DiffAlgorithm <algorithm>`
command! -nargs=1 -complete=custom,s:DiffAlgComplete DiffAlgorithm
      \ set diffopt-=algorithm:myers |
      \ set diffopt-=algorithm:minimal |
      \ set diffopt-=algorithm:patience |
      \ set diffopt-=algorithm:histogram |
      \ set diffopt+=algorithm:<args> |
      \ diffupdate

function! s:DiffAlgComplete(A, L, P)
  return "myers\nminimal\npatience\nhistogram"
endf
