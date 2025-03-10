#!/usr/bin/sh
#TODO
# install not everything with root in the users home dir xD.
#zsh plugin, nvim plugin
# Abort at error
set -e
bash -x
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
    sleep 3
    mv .config .config.bac
    echo "Pulling down the git repository"


    git clone https://github.com/laugenbrezel1004/dotfiles.git
    echo "Overwriting existing configfiles"
    if [  "$USER" = "root" ]; then
      sudo mkdir $USER/.config.backup
      sudo mv -f $USER/.config/{bat,btop,kitty,lsd,neofetch,ranger,nvim} $USER/.config.backup
		  sudo mv -f dotfiles/{bat, btop, kitty, lsd, neofetch, nvim, ranger, qimgv, ranger, starship, thefuck, tmux, zsh} $USER/.config/
	else    
		  # rm -rf /home/$USER/{.aliases,.tmux.conf,.vimrc,.zshrc}
      mkdir $USER/.config.backup
      mv -f $USER/.config/{bat,btop,kitty,lsd,neofetch,ranger,nvim} $USER/.config.backup
		  mv -f dotfiles/{bat, btop, kitty, lsd, neofetch, nvim, ranger, qimgv, ranger, starship, thefuck, tmux, zsh} $USER/.config/
	fi

    echo 
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
    _checkFundamentalSoftware # check if Fundamental are one the system 
    _identify_os  # Call the function to identify OS
    _pullGitrepository # download the git repo
    _installsoftware # install the needed software 
}

main  # Call main function
