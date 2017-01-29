Clone the repo:
`git clone https://github.com/fatjing/vimfiles.git ~/.vim`

Install/Update plugins:
`cd ~/.vim/bundle && bash install.sh`

Make sure vim finds the vimrc file by either symlinking it:
`ln -s ~/.vim/vimrc ~/.vimrc`
or by sourcing it from your own ~/.vimrc:
`source ~/.vim/vimrc`

File descriptions:
* .vim/bundle/ - bundle directory of plugin manager pathogen
* .vim/package-install.sh - shell script to install plugins
* .vim/vimrc - runtime configuration

as for pathogen, to install a plugin:
`cd ~/.vim/bundle && git clone git://github.com/username/repository.git`

to install a Vimball plugin:
```
:e name.vba
:!mkdir ~/.vim/bundle/name
:UseVimball ~/.vim/bundle/name
```
