#!/bin/env bash

set -e
set -x


## packages

__apt_packages = (bat fastfetch kitty lsd nvim vim tmux zsh git)



echo "installing dotfiles..."


#check if root

if [ ! $UID -eq 0 ]; then
  echo "You need to run this script as root"
  echo "aborting..."
fi


apt update -y &&

for package in "$packages[@]"; do
  apt install "$package"
done
