#!/bin/sh

installPackage()
{
    directory=${1##*/}
    sucess=1
    while [ $sucess -ne 0 ]; do
        if [ -d $directory ]; then
            rm -rf $directory
        fi
        echo
        git clone --depth 1 https://github.com/$1.git
        sucess=$?
    done
}

installPackage jpalardy/vim-slime
installPackage justinmk/vim-dirvish
installPackage luochen1990/rainbow
installPackage majutsushi/tagbar
installPackage mbbill/fencview
installPackage mtth/scratch.vim
installPackage scrooloose/syntastic
installPackage honza/vim-snippets
installPackage sirver/ultisnips
installPackage tpope/vim-abolish
installPackage tpope/vim-commentary
installPackage tpope/vim-dispatch
installPackage tpope/vim-fugitive
installPackage tpope/vim-pathogen
installPackage tpope/vim-repeat
installPackage tpope/vim-sleuth
installPackage tpope/vim-surround
installPackage tpope/vim-unimpaired
installPackage Valloric/ListToggle
# installPackage maxbrunsfeld/vim-yankstack

installPackage Shougo/unite.vim
installPackage Shougo/neomru.vim
installPackage Shougo/neoyank.vim
installPackage Shougo/vimproc.vim
cd vimproc.vim
# make
mingw32-make -f make_mingw32.mak
cd ..

installPackage rstacruz/sparkup
cd sparkup
# make vim-pathogen
mingw32-make vim-pathogen
rm -f ftplugin
rm -rf vim/doc
mv vim/ftplugin ./
cd ..

# installPackage Valloric/YouCompleteMe
# cd YouCompleteMe
# git submodule update --init --recursive
# cd ..

# installPackage chriskempson/base16-vim
installPackage dsolstad/vim-wombat256i
installPackage w0ng/vim-hybrid
installPackage hdima/python-syntax

rm -rf */.git
echo
echo Finished
