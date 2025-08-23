#!/usr/bin/env bash

# Source dependencies
source "$(dirname "${BASH_SOURCE[0]}")/utils.sh"

# Function to backup existing dotfiles
backup_dotfiles() {
    print_status "Creating backup of existing dotfiles..."
    mkdir -p "$BACKUP_DIR"
    
    for dir in */; do
        [[ -d "$dir" ]] || continue
        local config_name=$(basename "$dir")
        for file in $(find "$dir" -type f | sed "s|^$dir||"); do
            local target_file="$HOME/$file"
            if [[ -f "$target_file" || -L "$target_file" ]]; then
                mkdir -p "$BACKUP_DIR/$(dirname "$file")"
                mv -v "$target_file" "$BACKUP_DIR/$file"
            fi
        done
    done
    print_success "Backup created at: $BACKUP_DIR"
}

# Function to select dotfiles with dialog
select_dotfiles() {
    if ! command_exists dialog; then
        select_dotfiles_simple
        return
    fi
    
    local dotfiles=()
    for dir in */; do
        [[ -d "$dir" ]] && dotfiles+=("$(basename "$dir")" "$(basename "$dir")" "off")
    done
    
    [[ ${#dotfiles[@]} -eq 0 ]] && { print_error "No dotfile directories found!"; return 1; }
    
    local selected=$(dialog --stdout --checklist "Select dotfiles to install:" 20 60 15 "${dotfiles[@]}" 2>&1)
    [[ $? -ne 0 ]] && { print_warning "Dotfile selection cancelled"; return 0; }
    
    for choice in $selected; do
        choice=$(echo "$choice" | tr -d '"')
        print_status "Stowing $choice..."
        stow --target="$HOME" "$choice" || print_error "Failed to stow $choice"
    done
}

# Simple selection method without dialog
select_dotfiles_simple() {
    local dotfiles=() i=1
    print_status "Available dotfile directories:"
    
    for dir in */; do
        if [[ -d "$dir" ]]; then
            dotfiles[i]=$(basename "$dir")
            echo "$i) ${dotfiles[i]}"
            ((i++))
        fi
    done
    
    [[ ${#dotfiles[@]} -eq 0 ]] && { print_error "No dotfile directories found!"; return 1; }
    
    echo -n "Enter numbers to install (space separated, all for everything): "
    read -r choices
    
    if [[ "$choices" == "all" ]]; then
        for dir in "${dotfiles[@]}"; do [[ -n "$dir" ]] && stow --target="$HOME" "$dir"; done
    else
        for choice in $choices; do
            [[ "$choice" =~ ^[0-9]+$ && -n "${dotfiles[choice]}" ]] && stow --target="$HOME" "${dotfiles[choice]}"
        done
    fi
}
