#!/bin/env bash

# check if yay is installed
if ! command -v yay >/dev/null 2>&1; then
  (
    sudo pacman -S --needed git base-devel
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
  )
fi


# update system
yay -Syu


# installed deps

yay -S fzf neovim fd ripgrep ncdu lsd tldr batcat starship hyprpaper wofi tmux zsh waybar stow

for dir in */; do
  if [[ ! -f "${dir}" ]]; then
    stow "${dir}"
  fi
done


echo "All done :)"
