#!/bin/sh

installPackage()
{
    directory="${1##*/}"
    sucess=1
    while [ $sucess -ne 0 ]; do
        if [ -d "$directory" ]; then
            rm -rf "$directory"
        fi
        echo
        git clone --depth 1 "https://github.com/$1.git"
        sucess=$?
    done
}

cd ./bundle
installPackage jpalardy/vim-slime
installPackage justinmk/vim-dirvish
installPackage luochen1990/rainbow
installPackage majutsushi/tagbar
installPackage mbbill/fencview
installPackage mtth/scratch.vim
installPackage rstacruz/vim-closer
installPackage scrooloose/syntastic
installPackage sirver/ultisnips
installPackage honza/vim-snippets
installPackage Valloric/ListToggle
installPackage vim-voom/VOoM

installPackage tpope/vim-abolish
installPackage tpope/vim-commentary
installPackage tpope/vim-dispatch
installPackage tpope/vim-endwise
installPackage tpope/vim-fugitive
installPackage tpope/vim-pathogen
installPackage tpope/vim-repeat
installPackage tpope/vim-sleuth
installPackage tpope/vim-surround
installPackage tpope/vim-unimpaired

installPackage Shougo/denite.nvim
installPackage Shougo/neomru.vim
installPackage Shougo/neoyank.vim

# installPackage Valloric/YouCompleteMe
# cd YouCompleteMe
# git submodule update --init --recursive
# cd ..

# installPackage chriskempson/base16-vim
installPackage dsolstad/vim-wombat256i
installPackage w0ng/vim-hybrid

installPackage sheerun/vim-polyglot

rm -rf */.git
echo
echo Finished
