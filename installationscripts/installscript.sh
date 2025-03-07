#!/usr/bin/env bash
#TODO
# install not everything with root in the users home dir xD.
#zsh plugin, nvim plugin
# Abort at error
set -e
# Set global variables
os=""
setupFor=""
installer=""
dependencies=("git" "dialog")
installSoftware=("bat" "btop" "wget" "curl" "kitty" "thefuck" "lsd" "neofetch" "neovim" "vim" "zsh" "ranger" "tmux")
# installHyprlandSoftware=("mpv" "pulse" "swaync" "waybar" "wofi" "cava")
# installHyprland=false
# Get the OS 
_identify_os() {
	
	dialog --title 'Installation Wizard' --msgbox 'Lets start with the installation!' 6 40 
	
	
	for i in $(seq 1 100); do
	  echo $i
	  sleep 0.01
	done | dialog --gauge "Checking OS type..." 10 70 0
	

    # Check for Gentoo
    if [ -f /etc/gentoo-release ]; then
        os="gentoo"
        installer="emerge"
        dialog --title 'OS' --msgbox "Found $os as OS and $installer as packagemanager" 6 40 
        return
    elif grep -qi gentoo /etc/os-release &> /dev/null ; then
        os="gentoo"
        installer="emerge"
        dialog --title 'OS' --msgbox "Found $os as OS and $installer as packagemanger" 6 40
        return
    fi

    # Check for Arch
    if [ -f /etc/arch-release ]; then
        os="arch"
        installer="pacman"
        dialog --title 'OS' --msgbox "Found $os as OS and $installer as packagemanger" 6 40
        return
    elif grep -qi arch /etc/os-release &> /dev/null ; then
        os="arch"
        installer="pacman"
        dialog --title 'OS' --msgbox "Found $os as OS and $installer as packagemanger" 6 40
        return 
    fi

    # Check for Ubuntu 
    if [ -f /etc/ubuntu-release ]; then
        os="ubuntu"
        installer="apt"
        dialog --title 'OS' --msgbox "Found $os as OS and $installer as packagemanger" 6 40
        return

    elif grep -qi ubuntu /etc/os-release &> /dev/null ; then
        os="ubuntu"
        installer="apt"
        dialog --title 'OS' --msgbox "Found $os as OS and $installer as packagemanger" 6 40
        return
    fi

    # Check for Debian 
    if [ -f /etc/debian-release ]; then
        os="debian"
        installer="apt"
        dialog --title 'OS' --msgbox "Found $os as OS and $installer as packagemanger" 6 40
        return
    elif grep -qi debian /etc/os-release &> /dev/null ; then
        os="debian"
        installer="apt"
        dialog --title 'OS' --msgbox "Found $os as OS and $installer as packagemanger" 6 40
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
        for i in $(seq 1 100); do
		    echo $i
		    sleep 0.2
		    done | dialog --gauge "Updating portage repository" 10 70 0
	        for i in "${installSoftware[@]}"; do
	            sudo emerge "$i"
	        done 
	fi

    if [ "$os" = "debian" ] || [ "$os" = "ubuntu" ]; then

	   sudo apt update -y &> /dev/null
       for i in $(seq 1 100); do
		    echo $i
		    sleep 0.2
       done | dialog --gauge "Updating apt repository" 10 70 0
	        for i in "${installSoftware[@]}"; do
	            sudo apt install -y "$i"
	        done 
    fi

    echo "Installing starship..."
    sleep 3
    sudo curl -sS https://starship.rs/install.sh | sudo sh
}

_pullGitrepository(){
    echo "Pulling down the git repository"
    cd /tmp
    if [ -d dotfiles ]; then
        sudo rm -rf dotfiles
    fi

    git clone https://github.com/laugenbrezel1004/dotfiles.git
    echo "Overwriting existing configfiles"
    if [ "$USER" = "root" ]; then
	  rm -rf /$USER/.config/{bat,btop,cava,foot,kitty,lsd,neofetch,nvim,vim,ranger}
		rm -rf /$USER/{.aliases,.tmux.conf,.vimrc,.zshrc}
		mv -f dotfiles/{bat,btop,cava,foot,kitty,lsd,neofetch,ranger,nvim} /$USER/.config/
		mv -f dotfiles/{.aliases,.tmux.conf,.vimrc,.zshrc} /$USER/
	else    
	  sudo  rm -rf /home/$USER/.config/{bat,btop,cava,foot,kitty,lsd,neofetch,nvim,vim,ranger}
		sudo  rm -rf /home/$USER/{.aliases,.tmux.conf,.vimrc,.zshrc}
		sudo  mv -f dotfiles/{bat,btop,cava,foot,kitty,lsd,neofetch,ranger,nvim} /home/$USER/.config/
		sudo  mv -f dotfiles/{.aliases,.tmux.conf,.vimrc,.zshrc} /home/$USER/
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
        fi

        if ! which dialog &> /dev/null ; then
            echo "Please install dialog"
        fi
        exit 1
}
main() {
#    currentUser=$(whoami)
#    if [ "$currentUser" != "root" ]; then
#
    _checkFundamentalSoftware # check if Fundamental are one the system 
    _identify_os  # Call the function to identify OS
    _installsoftware # install the needed software 
    _pullGitrepository # download the git repo
}

main  # Call main function
