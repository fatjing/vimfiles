Make sure vim finds the vimrc file by either symlinking it: ln -s ~/.vim/vimrc ~/.vimrc
or by sourcing it from your own ~/.vimrc: source ~/.vim/vimrc

.vimrc                    " runtime configuration
.vim/bundle               " bundle directory of plugin manager pathogen
.vim/bundle/install.sh    " shell script to install plugins

to use install.sh:
cd ~/.vim/bundle && \
bash install.sh

as for pathogen, to install a plugin:
cd ~/.vim/bundle && \
git clone git://github.com/username/repository.git

to install a Vimball plugin:
:e name.vba
:!mkdir ~/.vim/bundle/name
:UseVimball ~/.vim/bundle/name
