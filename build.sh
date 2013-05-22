#!/bin/bash

ARCH=i386

if [ -n "$1" ]; then ARCH=$1; fi

MAKEPKG="makepkg --config `pwd`/makepkg-$ARCH.conf"
PACMAN="sudo pacman --config pacman-local.conf"

PACKAGES=(
    core/filesystem
    core/pirix
    core/newlib
    core/ncurses
    core/zlib
    core/freetype2
    core/libpng
    extra/lua
    extra/ttf-dejavu
)

ROOT=/tmp/pirix-root

sudo rm -rf $ROOT
mkdir -p $ROOT/var/lib/pacman

export PATH=$ROOT/usr/bin/:$PATH
export LIBRARY_PATH=$ROOT/usr/lib/
export CPATH=$ROOT/usr/include/
export CFLAGS=-I$CPATH
export LDFLAGS=-L$LIBRARY_PATH

for PACKAGE in ${PACKAGES[@]}; do
    REPO=$(echo $PACKAGE | cut -f1 -d "/")
    NAME=$(echo $PACKAGE | cut -f2 -d "/")

    pushd $PACKAGE > /dev/null
       echo makepkg $PACKAGE
       $MAKEPKG -A
    popd > /dev/null

    DEST=/tmp/pirix-repo/$ARCH/$REPO
    FILE=$(ls $PACKAGE/ | grep -E "($ARCH|any).pkg" | head -n 1)

    mkdir -p $DEST
    cp $PACKAGE/$FILE $DEST
    repo-add $DEST/$REPO.db.tar.gz $DEST/$FILE &> /dev/null

    echo install $PACKAGE
    $PACMAN -Sy
    (yes | $PACMAN -S $NAME)
done
