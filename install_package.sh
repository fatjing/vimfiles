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
        cd "$directory" || exit
        [ -d ".git" ] &&
        until git fetch --depth 1 --force && git reset --hard origin/master && git clean -df
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

set_dir "bundle/start"
packageList=(
    tpope/vim-commentary
    tpope/vim-endwise
    tpope/vim-fugitive
    tpope/vim-repeat
    tpope/vim-sleuth
    tpope/vim-surround
    tpope/vim-unimpaired

    kana/vim-textobj-user
    kana/vim-textobj-indent
    kana/vim-textobj-syntax
    sgur/vim-textobj-parameter
    whatyouhide/vim-textobj-xmlattr

    justinmk/vim-dirvish
    zhou13/vim-easyescape
    Valloric/ListToggle
    Yggdroot/LeaderF
    ludovicchabant/vim-gutentags
    skywind3000/gutentags_plus
    honza/vim-snippets
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
)
printf "%s\n" "${packageList[@]}" | xargs -P4 -n2 -I{} bash -c "package_install {}"

set_dir "colors/opt"
packageList=(
    chriskempson/base16-vim
    cocopon/iceberg.vim
    dsolstad/vim-wombat256i
    w0ng/vim-hybrid
)
printf "%s\n" "${packageList[@]}" | xargs -P4 -n2 -I{} bash -c "package_install {}"

# coc.nvim
set_dir "bundle/opt"
rm -rf coc.nvim-release/
curl --fail -L https://github.com/neoclide/coc.nvim/archive/release.tar.gz | tar xzf -

# rm -rf $PACK_DIR/*/*/*/.git
printf "\nFinished\n"
