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
    [ "$2" ] && branch="$2" || branch="master"
    if [ -d "$directory" ]; then
        cd "$directory" || exit
        [ -d ".git" ] &&
        until git fetch --depth 1 --force && git reset --hard origin/"$branch" && git clean -df
            do sleep 1; done
        cd ..
    else
        until git clone --depth 1 "$repo_url"; do
            sleep 1; [ -d "$directory" ] && rm -rf "$directory"
        done
    fi

    # post-installation hook
    [ "$3" ] && ($3)
}
export -f package_install

set_dir "bundle/start"
packageList=(
    tpope/vim-endwise
    tpope/vim-fugitive
    tpope/vim-repeat
    tpope/vim-surround
    tpope/vim-unimpaired

    kana/vim-textobj-user
    kana/vim-textobj-indent
    kana/vim-textobj-syntax
    adriaanzon/vim-textobj-matchit
    sgur/vim-textobj-parameter
    whatyouhide/vim-textobj-xmlattr

    easymotion/vim-easymotion
    justinmk/vim-dirvish
    Yggdroot/LeaderF
    ludovicchabant/vim-gutentags
    skywind3000/gutentags_plus
    sheerun/vim-polyglot
)
printf "%s\n" "${packageList[@]}" | xargs -P8 -I{} bash -c "package_install {}"

set_dir "bundle/opt"
packageList=(
    Valloric/ListToggle
    tpope/vim-commentary
    tpope/vim-sleuth
    honza/vim-snippets
    junegunn/vim-easy-align
    luochen1990/rainbow
    mbbill/fencview
    mtth/scratch.vim
    "neoclide/coc.nvim release"
    rbong/vim-flog
    skywind3000/asyncrun.vim
    skywind3000/asynctasks.vim
    vim-voom/VOoM
)
printf "%s\n" "${packageList[@]}" | xargs -P8 -I{} bash -c "package_install {}"

set_dir "colors/opt"
packageList=(
    chriskempson/base16-vim
    cocopon/iceberg.vim
    dsolstad/vim-wombat256i
    w0ng/vim-hybrid
)
printf "%s\n" "${packageList[@]}" | xargs -P8 -I{} bash -c "package_install {}"

# rm -rf $PACK_DIR/*/*/*/.git
printf "\nDone\n"
