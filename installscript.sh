#!/usr/bin/env bash
#TODO
#zsh plugin, nvim plugin
# Abort at error
set -e

# Set global variables
os=""
setupFor=""
installer=""
installSoftware=("bat" "btop" "foot" "kitty" "lsd" "neofetch" "git" "vim" "ranger" "tmux" "zsh" "cava")
installHyprlandSoftware=("mpv" "pulse" "swaync" "waybar" "wofi")
installHyprland=false
# Get the OS 
_identify_os() {
    # Check for Gentoo
    if [ -f /etc/gentoo-release ]; then
        os="gentoo"
        installer="emerge"
        echo "Found $os as OS and $installer as packagemanager"
        return
    elif grep -qi gentoo /etc/os-release; then
        os="gentoo"
        installer="emerge"
        echo "Found $os as OS and $installer as packagemanager"
        return
    fi

    # Check for Arch
    if [ -f /etc/arch-release ]; then
        os="arch"
        installer="pacman"
        echo "Found $os as OS and $installer as packagemanager"
        return
    elif grep -qi arch /etc/os-release; then
        os="arch"
        installer="pacman"
        echo "Found $os as OS and $installer as packagemanager"
        return 
    fi

    # Check for Ubuntu 
    if [ -f /etc/ubuntu-release ]; then
        os="ubuntu"
        installer="apt"
        echo "Found $os as OS and $installer as packagemanager"
        return
    elif grep -qi ubuntu /etc/os-release; then
        os="ubuntu"
        installer="apt"
        echo "Found $os as OS and $installer as packagemanager"
        return
    fi

    # Check for Debian 
    if [ -f /etc/debian-release ]; then
        os="debian"
        installer="apt"
        echo "Found $os as OS and $installer as packagemanager"
        return
    elif grep -qi debian /etc/os-release; then
        os="debian"
        installer="apt"
        echo "Found $os as OS and $installer as packagemanager"
        return
    fi
}

#install software and dependencies
_installsoftware(){
    echo "Installing software and dependencies..."
    sleep 5
    if [ "$os" = "gentoo" ]; then
        echo "Updating portage repository"
        sleep 3
        emerge --sync
        for i in "${installSoftware[@]}"; do
            emerge "$i"
        done 
    fi

    if [ "$os" = "debian" ] || [ "$os" = "ubuntu" ]; then
        echo "Updating apt repository"
        sleep 3
        apt update -y
        for i in "${installSoftware[@]}"; do
            apt install -y "$i"
        done
        echo "Finished installing software"
    fi

    echo "Installing starship..."
    sleep 3
    curl -sS https://starship.rs/install.sh | sh
}

_pullGitrepository(){
    echo "Pulling down the git repository"
    cd /tmp
    git clone https://github.com/laugenbrezel1004/dotfiles.git
    echo "Overwriting existing configfiles"
    rm -rf "/home/$setupFor/.config/{bat,btop,cava,foot,kitty,lsd,neofetch,vim,ranger}" 
    rm -rf "/home/$setupFor/{.aliases,.tmux.conf,.vimrc,.zshrc}"
    mv -f dotfiles/{bat,btop,cava,foot,kitty,lsd,neofetch,vim,ranger} "/home/$setupFor/.config/"
    mv -f dotfiles/{.aliases,.tmux.conf,.vimrc,.zshrc} "/home/$setupFor/"
}

main() {
    currentUser=$(whoami)
    if [ "$currentUser" != "root" ]; then
        echo "You are not root, please execute the script as root"
        echo "Aborting!!!"
        exit 1
    fi

    echo "Starting the installer..."
    sleep 5
    echo "Identifying OS..."
    echo "Please enter the name of the user who should receive the configfiles"
    read -r setupFor
    while true; do
        read -rp "Do you also want to install hyprland? (yes/no) " yn
        case $yn in
            [Yy]* ) 
                echo "You answered yes. Proceeding..."
                installHyprland=true
                break
                ;;
            [Nn]* ) 
                echo "You answered no. Proceeding..."
                break
                ;;
            * ) 
                echo "Please answer yes or no."
                ;;
        esac
    done

    _identify_os  # Call the function to identify OS
    _installsoftware #install the needed software 
    _pullGitrepository # download the git repo
    # Check if OS was found by evaluating the variable 'os'
    if [ -z "$os" ]; then  # If 'os' is empty, it means no OS was found
        echo "Unable to find OS type, aborting the script!!!"
        exit 1  # Exit with a non-zero status code to indicate failure
    fi
}

main  # Call main function
