#!/bin/bash

PACK_DIR=~/.config/vim/pack

set_dir()
{
    path=$PACK_DIR/$1
    mkdir -p $path
    cd $path || exit
}

package_install()
{
    url="https://github.com/$1.git"
    repo="${1#*/}"
    branch="${2:-master}"
    directory="${3:-$repo}"
    buffer=$( {
        if [ -d "$directory" ]; then
            cd "$directory" || exit
            [ -d ".git" ] || exit
            until git fetch --depth 1 --force --prune origin "$branch" &&
                  git reset --hard FETCH_HEAD && git clean -df; do
                sleep 1;
            done
        else
            until git clone --depth 1 --branch "$branch" --single-branch "$url" "$directory"; do
                sleep 1; [ -d "$directory" ] && rm -rf "$directory"
            done
        fi
    } 2>&1 )
    printf "%s\n\n" "$buffer"

    # post-installation hook
    [ "$4" ] && (cd "$directory" && $4)
}
export -f package_install

set_dir "bundle/start"
packageList=(
    tpope/vim-endwise
    tpope/vim-fugitive
    tpope/vim-repeat
    tpope/vim-sleuth
    tpope/vim-surround
    tpope/vim-unimpaired

    kana/vim-textobj-user
    kana/vim-textobj-indent
    kana/vim-textobj-syntax
    rhysd/vim-textobj-anyblock
    sgur/vim-textobj-parameter
    whatyouhide/vim-textobj-xmlattr

    itchyny/lightline.vim
    romainl/vim-cool
    romainl/vim-redir
    justinmk/vim-dirvish
    justinmk/vim-sneak
    Yggdroot/LeaderF
)
printf "%s\n" "${packageList[@]}" | xargs -P8 -I{} bash -c "package_install {}"

set_dir "bundle/opt"
packageList=(
    honza/vim-snippets
    junegunn/vim-easy-align
    luochen1990/rainbow
    mbbill/fencview
    mtth/scratch.vim
    skywind3000/asyncrun.vim
    skywind3000/asynctasks.vim
    skywind3000/vim-terminal-help
    "neoclide/coc.nvim release"
)
printf "%s\n" "${packageList[@]}" | xargs -P8 -I{} bash -c "package_install {}"

set_dir "colors/start"
packageList=(
    skywind3000/vim-color-patch
    romainl/Apprentice
    cocopon/iceberg.vim
    gkeep/iceberg-dark
    w0ng/vim-hybrid
    wesQ3/wombat.vim
    cideM/yui
    cormacrelf/vim-colors-github
    kamwitsta/flatwhite-vim
    NLKNguyen/papercolor-theme
    "yorickpeterse/vim-paper main"
    "nordtheme/vim main nordtheme-vim"
)
printf "%s\n" "${packageList[@]}" | xargs -P8 -I{} bash -c "package_install {}"

# rm -rf $PACK_DIR/*/*/*/.git
printf "Done\n"
