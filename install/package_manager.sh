#!/usr/bin/env bash

# Source dependencies
source "$(dirname "${BASH_SOURCE[0]}")/utils.sh"

# Function to parse command line arguments
parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -p|--package-manager)
                PACKAGE_MANAGER="$2"
                shift 2
                ;;
            -h|--help)
                echo "Usage: $0 [OPTIONS]"
                echo "Options:"
                echo "  -p, --package-manager [apt|yay]  Specify package manager to use"
                echo "  -h, --help                       Show this help message"
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                exit 1
                ;;
        esac
    done
}

# Function to setup package manager
setup_package_manager() {
    if [[ -n "$PACKAGE_MANAGER" ]]; then
        case "$PACKAGE_MANAGER" in
            apt|yay)
                if command_exists "$PACKAGE_MANAGER"; then
                    PACKAGE_MANAGER_COMMAND="$PACKAGE_MANAGER"
                    print_status "Using package manager: $PACKAGE_MANAGER"
                else
                    print_error "Specified package manager $PACKAGE_MANAGER not found"
                    exit 1
                fi
                ;;
            *)
                print_error "Unsupported package manager: $PACKAGE_MANAGER"
                exit 1
                ;;
        esac
    else
        if command_exists yay; then
            PACKAGE_MANAGER_COMMAND="yay"
            print_status "Auto-detected package manager: yay"
        elif command_exists apt; then
            PACKAGE_MANAGER_COMMAND="apt"
            print_status "Auto-detected package manager: apt"
        else
            print_error "No supported package manager found"
            exit 1
        fi
    fi
}

# Function to install yay if needed
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
    fi
}
