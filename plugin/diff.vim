" https://gist.github.com/romainl/7198a63faffdadd741e4ae81ae6dd9e6

function! s:Diff(spec)
  vertical new
  setlocal bufhidden=wipe buftype=nofile nobuflisted noswapfile
  if len(a:spec)
    let cmd = "!git -C #:p:h:S show " . a:spec . ":./#:t:S"
  else
    let cmd = "++edit #"
  endif
  execute "read " . cmd
  silent 0d_
  diffthis
  wincmd p
  diffthis
endfunction

command! -nargs=? Diff call <SID>Diff(<q-args>)
