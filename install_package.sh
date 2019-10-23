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
        until git fetch --depth 1 --force && git reset --hard origin/master \
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

YouCompleteMePostInstallation()
{
    cd YouCompleteMe
    git submodule update --init --recursive --depth 1
}
export -f YouCompleteMePostInstallation

set_dir "bundle/start"
packageList=(
    tpope/vim-abolish
    tpope/vim-commentary
    tpope/vim-endwise
    tpope/vim-fugitive
    tpope/vim-repeat
    tpope/vim-sleuth
    tpope/vim-surround
    tpope/vim-unimpaired

    kana/vim-textobj-user
    kana/vim-textobj-function
    kana/vim-textobj-indent
    kana/vim-textobj-syntax
    sgur/vim-textobj-parameter

    justinmk/vim-dirvish
    rstacruz/vim-closer
    Valloric/ListToggle
    Yggdroot/LeaderF

    ludovicchabant/vim-gutentags
    skywind3000/gutentags_plus
    w0rp/ale

    sheerun/vim-polyglot
)
printf "%s\n" "${packageList[@]}" | xargs -P4 -n2 -I{} bash -c "package_install {}"

set_dir "bundle/opt"
packageList=(
    jpalardy/vim-slime
    junegunn/vim-easy-align
    luochen1990/rainbow
    mbbill/fencview
    mtth/scratch.vim
    skywind3000/asyncrun.vim
    vim-voom/VOoM

    sirver/ultisnips
    honza/vim-snippets
    # "Valloric/YouCompleteMe YouCompleteMePostInstallation"
)
printf "%s\n" "${packageList[@]}" | xargs -P4 -n2 -I{} bash -c "package_install {}"

set_dir "colors/opt"
packageList=(
    chriskempson/base16-vim
    dsolstad/vim-wombat256i
    w0ng/vim-hybrid
)
printf "%s\n" "${packageList[@]}" | xargs -P4 -n2 -I{} bash -c "package_install {}"

# rm -rf $PACK_DIR/*/*/*/.git
printf "\nFinished\n"
