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
