#!/usr/bin/env bash
#TODO
#zsh plugin, nvim plugin
# Abort at error
set -e

# Set global variables
os=""
installer=""
installSoftware=("bat" "btop" "foot" "kitty" "lsd" "neofetch" "nvim" "ranger" "tmux" "zsh" "starship" "cava")
installHyprlandSoftware=("mpv" "pulse" "swaync" "waybar" "wofi")
installHyprland=false
# Get the OS 
_identify_os() {
    # Check for Gentoo
    if [ -f /etc/gentoo-release ]; then
        os="gentoo"
        installer="emerge"
        echo "Found $os as OS and $installer as packagemanager"

    elif grep -qi gentoo /etc/os-release; then
        os="gentoo"
        installer="emerge"
        echo "Found $os as OS and $installer as packagemanager"
    fi

    # Check for Arch
    if [ -f /etc/arch-release ]; then
        os="arch"
        installer="pacman"
        echo "Found $os as OS and $installer as packagemanager"
    elif grep -qi arch /etc/os-release; then
        os="arch"
        installer="pacman"
         echo "Found $os as OS and $installer as packagemanager"
    fi

    # Check for Ubuntu 
    if [ -f /etc/ubuntu-release ]; then
        os="ubuntu"
        installer="apt"
        echo "Found $os as OS and $installer as packagemanager"
    elif grep -qi ubuntu /etc/os-release; then
        os="ubuntu"
        installer="apt"
        echo "Found $os as OS and $installer as packagemanager"
    fi

    # Check for Debian 
    if [ -f /etc/debian-release ]; then
        os="debian"
        installer="apt"
        echo "Found $os as OS and $installer as packagemanager"
    elif grep -qi debian /etc/os-release; then
        os="debian"
        installer="apt"
        echo "Found $os as OS and $installer as packagemanager"
    fi
}

#install software and dependencies
_installsoftware(){
    echo "Installing software and dependencies..."
    sleep 5
    if [ "$os" = "gentoo" ]; then
        echo "Updating Gentoo-Repository"
        sleep 3
        emerge --sync
        for i in "$installSoftware[@]"; do
            emerge $i
        done 
    fi
}
main() {
    currentUser=$(whoami)
    if [ "$currentUser" != "root" ]; then
        echo "You are not root, please execute the script as root"
        echo "Abording!!!"
        exit 1
    fi
    echo "Starting the installer..."
    sleep 5
    echo "Identifying OS..."

    while true; do
        read -p "Do you also want to install hyprland? (yes/no) " yn
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
    # Check if OS was found by evaluating the variable 'os'
    if [ -z "$os" ]; then  # If 'os' is empty, it means no OS was found
        echo "Unable to find OS type, aborting the script!!!"
        exit 1  # Exit with a non-zero status code to indicate failure
    fi
    
}

main  # Call main function

