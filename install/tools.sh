#!/usr/bin/env bash

# Source dependencies
source "$(dirname "${BASH_SOURCE[0]}")/utils.sh"
source "$(dirname "${BASH_SOURCE[0]}")/package_manager.sh"

# Function to show tool selection dialog
select_tools() {
    local tools=(
        "core" "Core utilities (fzf, fd, ripgrep, etc.)" on
        "neovim" "Neovim text editor" on
        "shell" "Shell tools (starship, zsh, tmux)" on
        "hyprland" "Hyprland compositor tools" off
        "sddm" "SDDM display manager theme" off
        "gui" "GUI applications (wofi, waybar)" off
    )
    
    local selected=$(dialog --stdout --checklist \
        "Select tools to install:" 20 60 10 "${tools[@]}" 2>&1)
    
    [[ $? -ne 0 ]] && { print_warning "Tool selection cancelled"; return 1; }
    echo "$selected"
}

# Function to install selected packages
install_selected_packages() {
    local selection="$1"
    local packages=()
    
    [[ -n "$selection" ]] && packages+=("fzf" "fd" "ripgrep" "ncdu" "lsd" "tldr" "bat" "unzip" "dialog")
    [[ $selection == *"neovim"* ]] && packages+=("neovim")
    [[ $selection == *"shell"* ]] && packages+=("starship" "zsh" "tmux")
    [[ $selection == *"hyprland"* ]] && packages+=("hyprpaper" "hyprlock" "hypridle" "hyprshot" "hyprsunset")
    [[ $selection == *"gui"* ]] && packages+=("wofi" "waybar")
    [[ $selection == *"sddm"* ]] && packages+=("qt6-svg" "qt6-declarative" "qt5-quickcontrols2")
    
    if [[ ${#packages[@]} -gt 0 ]]; then
        print_status "Installing selected packages..."
        
        if [[ "$PACKAGE_MANAGER_COMMAND" == "yay" ]]; then
            yay -S --needed --noconfirm "${packages[@]}" || {
                print_error "Failed to install some packages"; return 1;
            }
        elif [[ "$PACKAGE_MANAGER_COMMAND" == "apt" ]]; then
            sudo apt update
            sudo apt install -y "${packages[@]}" || {
                print_error "Failed to install some packages"; return 1;
            }
        fi
        
        print_success "Packages installed successfully"
    else
        print_warning "No packages selected for installation"
    fi
}
