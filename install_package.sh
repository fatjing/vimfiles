#!/bin/bash

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

# DIR=${0%/*}
DIR=$PWD

cd $DIR/pack/bundle/start

installPackage tpope/vim-abolish
installPackage tpope/vim-commentary
installPackage tpope/vim-dispatch
installPackage tpope/vim-endwise
installPackage tpope/vim-fugitive
installPackage tpope/vim-repeat
installPackage tpope/vim-sleuth
installPackage tpope/vim-surround
installPackage tpope/vim-unimpaired

installPackage justinmk/vim-dirvish
installPackage luochen1990/rainbow
installPackage mbbill/fencview
installPackage mtth/scratch.vim
installPackage jpalardy/vim-slime
installPackage Valloric/ListToggle
installPackage vim-voom/VOoM

installPackage rstacruz/vim-closer
installPackage sirver/ultisnips
installPackage honza/vim-snippets
installPackage ludovicchabant/vim-gutentags
installPackage w0rp/ale

installPackage Shougo/denite.nvim
installPackage Shougo/neomru.vim
installPackage Shougo/neoyank.vim
# installPackage Shougo/echodoc.vim

# installPackage Valloric/YouCompleteMe
# cd YouCompleteMe
# git submodule update --init --recursive
# cd ..

installPackage sheerun/vim-polyglot

cd $DIR/pack/colors/opt

installPackage chriskempson/base16-vim
installPackage dsolstad/vim-wombat256i
installPackage w0ng/vim-hybrid

rm -rf $DIR/pack/*/*/*/.git
echo
echo Finished
