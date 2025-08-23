#!/usr/bin/env bash

# Source dependencies
source "$(dirname "${BASH_SOURCE[0]}")/utils.sh"

# Function to install SDDM theme
install_sddm_theme() {
    command_exists sddm || { print_warning "SDDM is not installed, skipping theme installation"; return 0; }
    
    print_status "Installing SDDM theme..."
    local temp_file=$(mktemp) temp_dir=$(mktemp -d)
    
    curl -L "$SDDM_THEME_URL" -o "$temp_file" || {
        print_error "Failed to download SDDM theme"; rm -f "$temp_file"; rm -rf "$temp_dir"; return 1;
    }
    
    unzip -q "$temp_file" -d "$temp_dir" || {
        print_error "Failed to extract SDDM theme"; rm -f "$temp_file"; rm -rf "$temp_dir"; return 1;
    }
    
    sudo mkdir -p "$SDDM_THEME_DIR"
    sudo mv -v "$temp_dir"/* "$SDDM_THEME_DIR/" || {
        print_error "Failed to move SDDM theme"; rm -f "$temp_file"; rm -rf "$temp_dir"; return 1;
    }
    
    rm -f "$temp_file"; rm -rf "$temp_dir"
    print_success "SDDM theme installed successfully"
}
