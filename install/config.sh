#!/usr/bin/env bash
# config.sh

# Colors for output formatting
RED='\033[0;31m'      # Error messages
GREEN='\033[0;32m'    # Success messages
YELLOW='\033[1;33m'   # Warning messages
BLUE='\033[0;34m'     # Informational messages
NC='\033[0m'          # No Color (reset)

# Configuration variables
CONFIG_DIR="$HOME/dotfiles"  # Default dotfiles directory
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"  # Backup directory with timestamp
SDDM_THEME_URL="https://github.com/catppuccin/sddm/releases/download/v1.1.2/catppuccin-macchiato-blue-sddm.zip"
SDDM_THEME_DIR="/usr/share/sddm/themes"  # SDDM themes directory

# Package manager variables
PACKAGE_MANAGER=""           # Will store user's package manager choice
PACKAGE_MANAGER_COMMAND=""   # Will store the actual command to use
