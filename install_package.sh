#!/bin/bash

# PACK_DIR=${0%/*}/pack
PACK_DIR=~/.vim/pack

set_dir()
{
    path=$PACK_DIR/$1
    mkdir -p $path
    cd $path || exit
}

package_install()
{
    directory="${1##*/}"
    repo_url="https://github.com/$1.git"
    if [ -d "$directory" ]; then
        cd "$directory"
        until git fetch --depth 1 --force "$repo_url" \
              && git reset --hard origin/master \
              && git clean -df
        do sleep 1; done
        cd ..
    else
        until git clone --depth 1 "$repo_url"; do
            sleep 1; [ -d "$directory" ] && rm -rf "$directory"
        done
    fi

    [ ! -z $2 ] && ($2)
}
export -f package_install

YouCompleteMePostInstallation() {
    cd YouCompleteMe
    git submodule update --init --recursive --depth 1
}
export -f YouCompleteMePostInstallation

packageList=(
    tpope/vim-abolish
    tpope/vim-commentary
    tpope/vim-dispatch
    tpope/vim-endwise
    tpope/vim-fugitive
    tpope/vim-repeat
    tpope/vim-sleuth
    tpope/vim-surround
    tpope/vim-unimpaired

    justinmk/vim-dirvish
    luochen1990/rainbow
    mbbill/fencview
    mtth/scratch.vim
    jpalardy/vim-slime
    Valloric/ListToggle
    vim-voom/VOoM

    rstacruz/vim-closer
    sirver/ultisnips
    honza/vim-snippets
    ludovicchabant/vim-gutentags
    w0rp/ale

    Shougo/denite.nvim
    Shougo/neomru.vim
    Shougo/neoyank.vim
    # Shougo/echodoc.vim

    # "Valloric/YouCompleteMe YouCompleteMePostInstallation"

    sheerun/vim-polyglot
)
set_dir "bundle/start"
printf "%s\n" "${packageList[@]}" | xargs -P4 -n2 -I{} bash -c "package_install {}"

packageList=(
    chriskempson/base16-vim
    dsolstad/vim-wombat256i
    w0ng/vim-hybrid
)
set_dir "colors/opt"
printf "%s\n" "${packageList[@]}" | xargs -P4 -n2 -I{} bash -c "package_install {}"

# rm -rf $PACK_DIR/*/*/*/.git
printf "\nFinished\n"
