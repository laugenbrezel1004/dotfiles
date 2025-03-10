#!/usr/bin/sh
#TODO
# make script more robust for config and dotfiles local backup
# make use of more variables in the script



set -e

# Set global variables
#
_os=""
_setupFor=""
_installer=""
_installSoftware_emerge=("bat" "btop" "kitty" "thefuck" "lsd" "curl" "neofetch" "neovim" "vim" "zsh" "ranger" "tmux")
_installSoftware_apt=("bat" "btop" "lua5.4" "kitty" "curl" "thefuck" "lsd" "neofetch" "neovim" "vim" "zsh" "ranger" "tmux")
_moveSoftware=("bat" "btop" "kitty" "thefuck" "lsd" "neofetch" "nvim" "zsh" "ranger" "tmux")


# Get the OS 
_identify_os() {
	
	echo "Lets start with the installation!"
	echo "Checking OS-Type"

    # Check for Gentoo
    if [ -f /etc/gentoo-release ]; then
        _os="gentoo"
        _installer="emerge"
        echo "Found $_os as OS and $_installer as packagemanger"
        return
    elif grep -qi gentoo /etc/os-release &> /dev/null ; then
        _os="gentoo"
        _installer="emerge"
        echo "Found $_os as OS and $_installer as packagemanger"
        return
    fi

    # Check for Arch
    if [ -f /etc/arch-release ]; then
        _os="arch"
        _installer="pacman"
        echo "Found $_os as OS and $_installer as packagemanger"
        return
    elif grep -qi arch /etc/os-release &> /dev/null ; then
        _os="arch"
        _installer="pacman"
        echo "Found $_os as OS and $_installer as packagemanger"
        return 
    fi

    # Check for Ubuntu 
    if [ -f /etc/ubuntu-release ]; then
        _os="ubuntu"
        _installer="apt"
        echo "Found $_os as OS and $_installer as packagemanger"
        return

    elif grep -qi ubuntu /etc/os-release &> /dev/null ; then
        _os="ubuntu"
        _installer="apt"
        echo "Found $_os as OS and $_installer as packagemanger"
        return
    fi

    # Check for Debian 
    if [ -f /etc/debian-release ]; then
        _os="debian"
        _installer="apt"
        echo "Found $_os as OS and $_installer as packagemanger"
        return
    elif grep -qi debian /etc/os-release &> /dev/null ; then
        _os="debian"
        _installer="apt"
        echo "Found $_os as OS and $_installer as packagemanger"
        return
    fi

    if [ -z "$_os" ]; then  # If '_os' is empty, it means no OS was found
        echo "Unable to find OS type, aborting the script!!!"
        exit 1  # Exit with a non-zero status code to indicate failure
    fi
}

#install software and dependencies
_installsoftware(){
    if [ "$_os" = "gentoo" ]; then
	   
	      sudo emaint --yes sync --all &> /dev/null
		    echo "Updating portage repository" 
	        for i in "${_installSoftware_emerge[@]}"; do
	            sudo emerge "$i"
	        done 
	fi

    if [ "$_os" = "debian" ] || [ "$_os" = "ubuntu" ]; then
      echo "Updating apt repositories"
	   sudo apt update -y &> /dev/null
	        for i in "${_installSoftware_apt[@]}"; do
	            sudo apt install -y "$i"
	        done 
    fi

    echo "Installing starship..."
    sleep 3
    sudo curl -sS https://starship.rs/install.sh | sudo sh
}

_pullGitrepository(){

    echo "Backuping up .config direcotry to .config.backup"
    if [ ! -d "$HOME/.config.backup" ]; then
      mkdir $HOME/.config.backup
    fi
     
    #backup old config
    if [ -d "$HOME/.config/bat" ]; then
      mv -f "$HOME/.config/bat" "$HOME/.config.backup"
    fi

    if [ -d "$HOME/.config/btop" ]; then
        mv -f "$HOME/.config/btop" "$HOME/.config.backup"
    fi

    if [ -d "$HOME/.config/kitty" ]; then
        mv -f "$HOME/.config/kitty" "$HOME/.config.backup"
    fi

    if [ -d "$HOME/.config/lsd" ]; then
        mv -f "$HOME/.config/lsd" "$HOME/.config.backup"
    fi

    if [ -d "$HOME/.config/neofetch" ]; then
        mv -f "$HOME/.config/neofetch" "$HOME/.config.backup"
    fi

    if [ -d "$HOME/.config/nvim" ]; then
        mv -f "$HOME/.config/nvim" "$HOME/.config.backup"
    fi

    if [ -d "$HOME/.config/ranger" ]; then
        mv -f "$HOME/.config/ranger" "$HOME/.config.backup"
    fi

    if [ -d "$HOME/.config/qimgv" ]; then
        mv -f "$HOME/.config/qimgv" "$HOME/.config.backup"
    fi

    if [ -d "$HOME/.config/starship" ]; then
        mv -f "$HOME/.config/starship" "$HOME/.config.backup"
    fi

    if [ -d "$HOME/.config/thefuck" ]; then
        mv -f "$HOME/.config/thefuck" "$HOME/.config.backup"
    fi

    if [ -d "$HOME/.config/tmux" ]; then
        mv -f "$HOME/.config/tmux" "$HOME/.config.backup"
    fi

    if [ -d "$HOME/.config/zsh" ]; then
        mv -f "$HOME/.config/zsh" "$HOME/.config.backup"
    fi
    if [ -f "$HOME/.aliases" ]; then
      sudo mv "$HOME/.aliases"  "$HOME/.config.backup/"
    fi
    if [ -f "$HOME/.tmux.conf" ]; then
      sudo mv "$HOME/.tmux.conf" "$HOME/.config.backup/"
    fi
    if [ -f "$HOME/.vimrc" ]; then
      sudo mv "$HOME/.vimrc" "$HOME/.config.backup/"
    fi
    if [ -f "$HOME/.zshrc" ]; then
      sudo mv "$HOME/.zshrc" "$HOME/.config.backup/"
    fi

    if [ -d "$HOME/dotfiles" ]; then
      mv $HOME/dotfiles $HOME/dotfiles.backup
    fi

    sleep 3
    echo "Pulling down the git repository"
    git clone https://github.com/laugenbrezel1004/dotfiles.git

    echo "Installing new config files"

    #mv dotfiles to config
    for software in "${_moveSoftware[@]}"; do
      mv "dotfiles/$software" "$HOME/.config/"
    done

    # and create sym links for fiels
    ln -s $HOME/.config/zsh/.zshrc $HOME/.zshrc
    
    echo "You are all set!!!"
    zsh
    exit 0
}

# implement check for wget 
_checkFundamentalSoftware(){
    if ! which git &> /dev/null ; then
        echo "Please install git"
        exit 1
    fi
}
main() {
#    currentUser=$(whoami)
#    if [ "$currentUser" != "root" ]; then
    # change working direcotry
    cd $HOME
    _checkFundamentalSoftware # check if Fundamental are one the system 
    _identify_os  # Call the function to identify OS
    _pullGitrepository # download the git repo
    _installsoftware # install the needed software 
}

main  # Call main function
