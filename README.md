Clone the repo:
`git clone https://github.com/fatjing/vimfiles.git ~/.config/vim`

Make sure vim finds the vimrc file by either symlinking it:
`ln -s ~/.config/vim/vimrc ~/.vimrc`
or by sourcing it from ~/.vimrc:
`source ~/.config/vim/vimrc`

Notes:
* install_package.sh - script to install plugins, utilizing vim's built-in package system
  * post-installation: run `:helptags ALL` to generate help tags files if needed
* autoload/load_plugin.vim - defined functions to lazyload plugins
