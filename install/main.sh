#!/usr/bin/env bash
# main.sh

###############################################################################
# Dotfiles Installation Script
#
# This script automates the installation of dotfiles and related tools.
# It provides:
# - Interactive selection of tools to install
# - Support for multiple package managers (apt/yay)
# - Backup of existing dotfiles
# - Customizable installation options
###############################################################################

# Source all modules
source "$(dirname "${BASH_SOURCE[0]}")/config.sh"
source "$(dirname "${BASH_SOURCE[0]}")/utils.sh"
source "$(dirname "${BASH_SOURCE[0]}")/package_manager.sh"
source "$(dirname "${BASH_SOURCE[0]}")/tools.sh"
source "$(dirname "${BASH_SOURCE[0]}")/dotfiles.sh"
source "$(dirname "${BASH_SOURCE[0]}")/sddm.sh"

# Handle script interruption
cleanup() { print_error "Script interrupted"; exit 1; }
trap cleanup INT TERM

# Main function
main() {
    print_status "Starting dotfiles installation..."
    
    parse_arguments "$@"
    validate_environment
    setup_package_manager
    
    local tool_selection=$(select_tools) || exit 1
    
    [[ "$PACKAGE_MANAGER_COMMAND" == "yay" ]] && install_yay
    install_selected_packages "$tool_selection"
    
    [[ $tool_selection == *"sddm"* ]] && install_sddm_theme
    
    backup_dotfiles
    select_dotfiles
    
    print_success "Installation completed!"
    print_status "Backup created at: $BACKUP_DIR"
    print_status "You may need to restart your session for changes to take effect"
}

# Run main function
main "$@"
