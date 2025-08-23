#!/usr/bin/env bash
# utils.sh

# Source config
source "$(dirname "${BASH_SOURCE[0]}")/config.sh"

# Function to print colored output
print_status() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Function to check if command exists
command_exists() { command -v "$1" >/dev/null 2>&1; }

# Function to validate we're in the dotfiles directory
validate_environment() {
    if [[ ! -d "$CONFIG_DIR" ]]; then
        print_error "Please run this script from your dotfiles directory"
        exit 1
    fi
    
    cd "$CONFIG_DIR" || {
        print_error "Failed to change to dotfiles directory"
        exit 1
    }
}
