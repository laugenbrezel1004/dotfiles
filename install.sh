#!/usr/bin/env bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
CONFIG_DIR="$HOME/dotfiles"
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
SDDM_THEME_URL="https://github.com/catppuccin/sddm/releases/download/v1.1.2/catppuccin-macchiato-blue-sddm.zip"
SDDM_THEME_DIR="/usr/share/sddm/themes"

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install yay if not present
install_yay() {
    if ! command_exists yay; then
        print_status "Installing yay..."
        sudo pacman -S --needed git base-devel || {
            print_error "Failed to install prerequisites for yay"
            return 1
        }
        
        local temp_dir=$(mktemp -d)
        git clone https://aur.archlinux.org/yay.git "$temp_dir" || {
            print_error "Failed to clone yay repository"
            rm -rf "$temp_dir"
            return 1
        }
        
        cd "$temp_dir" || return 1
        makepkg -si --noconfirm || {
            print_error "Failed to build and install yay"
            cd - >/dev/null
            rm -rf "$temp_dir"
            return 1
        }
        
        cd - >/dev/null
        rm -rf "$temp_dir"
        print_success "yay installed successfully"
    else
        print_status "yay is already installed"
    fi
}

# Function to install packages
install_packages() {
    local packages=(
        "fzf" "neovim" "fd" "ripgrep" "ncdu" "lsd" "tldr" "bat"
        "starship" "hyprpaper" "wofi" "tmux" "zsh" "waybar" "stow"
        "hyprlock" "hypridle" "hyprshot" "hyprsunset" "unzip"
        "qt6-svg" "qt6-declarative" "qt5-quickcontrols2"
    )
    
    print_status "Installing packages..."
    yay -S --needed --noconfirm "${packages[@]}" || {
        print_error "Failed to install some packages"
        return 1
    }
    print_success "Packages installed successfully"
}

# Function to install SDDM theme
install_sddm_theme() {
    if ! command_exists sddm; then
        print_warning "SDDM is not installed, skipping theme installation"
        return 0
    fi
    
    print_status "Installing SDDM theme..."
    
    local temp_file=$(mktemp)
    local temp_dir=$(mktemp -d)
    
    curl -L "$SDDM_THEME_URL" -o "$temp_file" || {
        print_error "Failed to download SDDM theme"
        rm -f "$temp_file"
        rm -rf "$temp_dir"
        return 1
    }
    
    unzip -q "$temp_file" -d "$temp_dir" || {
        print_error "Failed to extract SDDM theme"
        rm -f "$temp_file"
        rm -rf "$temp_dir"
        return 1
    }
    
    sudo mkdir -p "$SDDM_THEME_DIR"
    sudo mv -v "$temp_dir"/* "$SDDM_THEME_DIR/" || {
        print_error "Failed to move SDDM theme to system directory"
        rm -f "$temp_file"
        rm -rf "$temp_dir"
        return 1
    }
    
    rm -f "$temp_file"
    rm -rf "$temp_dir"
    print_success "SDDM theme installed successfully"
}

# Function to backup existing dotfiles
backup_dotfiles() {
    print_status "Creating backup of existing dotfiles..."
    mkdir -p "$BACKUP_DIR"
    
    for dir in */; do
        if [[ -d "$dir" ]]; then
            local config_name=$(basename "$dir")
            for file in $(find "$dir" -type f | sed "s|^$dir||"); do
                local target_file="$HOME/$file"
                if [[ -f "$target_file" || -L "$target_file" ]]; then
                    mkdir -p "$BACKUP_DIR/$(dirname "$file")"
                    mv -v "$target_file" "$BACKUP_DIR/$file"
                fi
            done
        fi
    done
    print_success "Backup created at: $BACKUP_DIR"
}

# Function to show interactive menu for stow selection
select_dotfiles() {
    if ! command_exists dialog; then
        print_warning "dialog not installed, using simple selection method"
        select_dotfiles_simple
        return
    fi
    
    local dotfiles=()
    local selected=()
    
    # Find all directories that could be stowed
    for dir in */; do
        if [[ -d "$dir" ]]; then
            local dir_name=$(basename "$dir")
            dotfiles+=("$dir_name" "$dir_name" "off")
        fi
    done
    
    if [[ ${#dotfiles[@]} -eq 0 ]]; then
        print_error "No dotfile directories found!"
        return 1
    fi
    
    # Show dialog menu
    selected=$(dialog --stdout --checklist \
        "Select dotfiles to install:" \
        20 60 15 \
        "${dotfiles[@]}" \
        2>&1)
    
    if [[ $? -ne 0 ]]; then
        print_warning "Dotfile selection cancelled"
        return 0
    fi
    
    # Stow selected directories
    for choice in $selected; do
        choice=$(echo "$choice" | tr -d '"')
        print_status "Stowing $choice..."
        stow --target="$HOME" "$choice" || {
            print_error "Failed to stow $choice"
        }
    done
}

# Simple selection method without dialog
select_dotfiles_simple() {
    local dotfiles=()
    local i=1
    
    print_status "Available dotfile directories:"
    for dir in */; do
        if [[ -d "$dir" ]]; then
            local dir_name=$(basename "$dir")
            dotfiles[i]="$dir_name"
            echo "$i) $dir_name"
            ((i++))
        fi
    done
    
    if [[ ${#dotfiles[@]} -eq 0 ]]; then
        print_error "No dotfile directories found!"
        return 1
    fi
    
    echo -n "Enter numbers to install (space separated, all for everything): "
    read -r choices
    
    if [[ "$choices" == "all" ]]; then
        for dir in "${dotfiles[@]}"; do
            [[ -n "$dir" ]] && stow --target="$HOME" "$dir"
        done
    else
        for choice in $choices; do
            if [[ "$choice" =~ ^[0-9]+$ ]] && [[ -n "${dotfiles[choice]}" ]]; then
                stow --target="$HOME" "${dotfiles[choice]}"
            fi
        done
    fi
}

# Main function
main() {
    print_status "Starting dotfiles installation..."
    
    # Check if we're in the dotfiles directory
    if [[ ! -d "$CONFIG_DIR" ]]; then
        print_error "Please run this script from your dotfiles directory"
        exit 1
    fi
    
    cd "$CONFIG_DIR" || {
        print_error "Failed to change to dotfiles directory"
        exit 1
    }
    
    # Installation steps
    install_yay || exit 1
    install_packages || exit 1
    install_sddm_theme
    
    # Backup and stow
    backup_dotfiles
    select_dotfiles
    
    print_success "Installation completed!"
    print_status "Backup created at: $BACKUP_DIR"
    print_status "You may need to restart your session for changes to take effect"
}

# Handle script interruption
cleanup() {
    print_error "Script interrupted"
    exit 1
}

trap cleanup INT TERM

# Run main function
main "$@"
