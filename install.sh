#!/bin/env bash

set -e
set -x


## packages

__apt_packages=(bat kitty lsd neovim vim tmux zsh git)



echo "installing dotfiles..."


#check if root

if [ ! $UID -eq 0 ]; then
  echo "You need to run this script as root"
  echo "aborting..."
  exit 1
fi


apt update -y 

for package in "${__apt_packages[@]}"; do
  apt install "$package" -y
done



## install dotfiles to correct dir
## backing up old dotfiles

if [ -f ./install.sh ]; then
  echo "you are in the right dir"
fi

if [ ! -f ./install.sh ]; then
  echo "wrong workingdir"
  echo "aborting..."
  exit 1
fi




