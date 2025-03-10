#!/usr/bin/sh
#TODO
# install not everything with root in the users home dir xD.
#zsh plugin, nvim plugin
# Abort at error
set -e
# Set global variables
os=""
setupFor=""
installer=""
dependencies=("git")
installSoftware_emerge=("bat" "btop" "wget" "curl" "kitty" "thefuck" "lsd" "neofetch" "neovim" "vim" "zsh" "ranger" "tmux")
installSoftware_apt=("bat" "btop" "wget" "curl" "kitty" "thefuck" "lsd" "neofetch" "neovim" "vim" "zsh" "ranger" "tmux")
# installHyprlandSoftware=("mpv" "pulse" "swaync" "waybar" "wofi" "cava")
# installHyprland=false
# Get the OS 
_identify_os() {
	
	echo "Lets start with the installation!"
	echo "Checking OS-Type"

    # Check for Gentoo
    if [ -f /etc/gentoo-release ]; then
        os="gentoo"
        installer="emerge"
        echo "Found $os as OS and $installer as packagemanger"
        return
    elif grep -qi gentoo /etc/os-release &> /dev/null ; then
        os="gentoo"
        installer="emerge"
        echo "Found $os as OS and $installer as packagemanger"
        return
    fi

    # Check for Arch
    if [ -f /etc/arch-release ]; then
        os="arch"
        installer="pacman"
        echo "Found $os as OS and $installer as packagemanger"
        return
    elif grep -qi arch /etc/os-release &> /dev/null ; then
        os="arch"
        installer="pacman"
        echo "Found $os as OS and $installer as packagemanger"
        return 
    fi

    # Check for Ubuntu 
    if [ -f /etc/ubuntu-release ]; then
        os="ubuntu"
        installer="apt"
        echo "Found $os as OS and $installer as packagemanger"
        return

    elif grep -qi ubuntu /etc/os-release &> /dev/null ; then
        os="ubuntu"
        installer="apt"
        echo "Found $os as OS and $installer as packagemanger"
        return
    fi

    # Check for Debian 
    if [ -f /etc/debian-release ]; then
        os="debian"
        installer="apt"
        echo "Found $os as OS and $installer as packagemanger"
        return
    elif grep -qi debian /etc/os-release &> /dev/null ; then
        os="debian"
        installer="apt"
        echo "Found $os as OS and $installer as packagemanger"
        return
    fi

    if [ -z "$os" ]; then  # If 'os' is empty, it means no OS was found
        echo "Unable to find OS type, aborting the script!!!"
        exit 1  # Exit with a non-zero status code to indicate failure
    fi
}

#install software and dependencies
_installsoftware(){
    if [ "$os" = "gentoo" ]; then
	   
	      sudo emaint --yes sync --all &> /dev/null
		    echo "Updating portage repository" 
	        for i in "${installSoftware[@]}"; do
	            sudo emerge "$i"
	        done 
	fi

    if [ "$os" = "debian" ] || [ "$os" = "ubuntu" ]; then
      echo "Updating apt repositories"
	   sudo apt update -y &> /dev/null
	        for i in "${installSoftware[@]}"; do
	            sudo apt install -y "$i"
	        done 
    fi

    echo "Installing starship..."
    sleep 3
    sudo curl -sS https://starship.rs/install.sh | sudo sh
}

_pullGitrepository(){
    echo "Backuping up .config direcotry"
    if [ ! -d "$HOME/.config.backup" ]; then
      mkdir $HOME/.config.backup
    fi
    
    if [ -d "$HOME/dotfiles" ]; then
      mv $HOME/dotfiles $HOME/dotfiles.backup
    fi

    sleep 3
    echo "Pulling down the git repository"
    git clone https://github.com/laugenbrezel1004/dotfiles.git
    echo "Installing new config files"

  if [ -d "$HOME/.config/dotfiles/bat" ]; then
    mv -f "$HOME/.config/dotfiles/bat" "$HOME/.config.backup"
  fi

  if [ -d "$HOME/.config/dotfiles/btop" ]; then
      mv -f "$HOME/.config/dotfiles/btop" "$HOME/.config.backup"
  fi

  if [ -d "$HOME/.config/dotfiles/kitty" ]; then
      mv -f "$HOME/.config/dotfiles/kitty" "$HOME/.config.backup"
  fi

  if [ -d "$HOME/.config/dotfiles/lsd" ]; then
      mv -f "$HOME/.config/dotfiles/lsd" "$HOME/.config.backup"
  fi

  if [ -d "$HOME/.config/dotfiles/neofetch" ]; then
      mv -f "$HOME/.config/dotfiles/neofetch" "$HOME/.config.backup"
  fi

  if [ -d "$HOME/.config/dotfiles/nvim" ]; then
      mv -f "$HOME/.config/dotfiles/nvim" "$HOME/.config.backup"
  fi

  if [ -d "$HOME/.config/dotfiles/ranger" ]; then
      mv -f "$HOME/.config/dotfiles/ranger" "$HOME/.config.backup"
  fi

  if [ -d "$HOME/.config/dotfiles/qimgv" ]; then
      mv -f "$HOME/.config/dotfiles/qimgv" "$HOME/.config.backup"
  fi

  if [ -d "$HOME/.config/dotfiles/starship" ]; then
      mv -f "$HOME/.config/dotfiles/starship" "$HOME/.config.backup"
  fi

  if [ -d "$HOME/.config/dotfiles/thefuck" ]; then
      mv -f "$HOME/.config/dotfiles/thefuck" "$HOME/.config.backup"
  fi

  if [ -d "$HOME/.config/dotfiles/tmux" ]; then
      mv -f "$HOME/.config/dotfiles/tmux" "$HOME/.config.backup"
  fi

  if [ -d "$HOME/.config/dotfiles/zsh" ]; then
      mv -f "$HOME/.config/dotfiles/zsh" "$HOME/.config.backup"
  fi
    if [ -d "$HOME/.aliases" ]; then
      sudo mv "$HOME/.aliases"  "$HOME/.config.backup/"
    fi
    if [ -d "$HOME/.tmux.conf" ]; then
      sudo mv "$HOME/.tmux.conf" "$HOME/.config.backup/"
    fi
    if [ -d "$HOME/.vimrc" ]; then
      sudo mv "$HOME/.vimrc" "$HOME/.config.backup/"
    fi
    if [ -d "$HOME/.zshrc" ]; then
      sudo mv "$HOME/.zshrc" "$HOME/.config.backup/"
    fi

    source ~/.zshrc
    echo "You are all set!!!"
    neofetch
    exit 0
}


_checkFundamentalSoftware(){
    if ! which git &> /dev/null ; then
        echo "Please install git"
        exit 1
    fi
}
main() {
#    currentUser=$(whoami)
#    if [ "$currentUser" != "root" ]; then
#
    cd $HOME
    _checkFundamentalSoftware # check if Fundamental are one the system 
    _identify_os  # Call the function to identify OS
    _pullGitrepository # download the git repo
    _installsoftware # install the needed software 
}

main  # Call main function
