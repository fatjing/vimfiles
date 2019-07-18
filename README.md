Clone the repo:  
`git clone https://github.com/fatjing/vimfiles.git ~/.vim`

Make sure vim finds the vimrc file by either symlinking it:  
`ln -s ~/.vim/vimrc ~/.vimrc`  
or by sourcing it from ~/.vimrc:  
`source ~/.vim/vimrc`

File descriptions:
* .vim/install_package.sh - script to install plugins, note the directory structure
    * post-installation: run `:helptags ALL` in vim to generate help tags files if needed
* .vim/vimrc - runtime configuration

