" transparent background for terminal
if !has('gui_running')
  set termguicolors
  hi Normal guibg=NONE ctermbg=NONE
  hi NonText guibg=NONE ctermbg=NONE
  hi LineNr guibg=NONE ctermbg=NONE
  hi VertSplit guibg=NONE ctermbg=NONE
endif
