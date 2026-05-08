#!/bin/bash

# GameForLinux Uninstallation Script
# Clean removal of all games and related files

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
GAMES=("sudokute" "termines" "gotermoku")
INSTALL_DIR="${HOME}/.gameforlinux"
BIN_DIR="/usr/local/bin"

# ============== UTILITY FUNCTIONS ==============

log_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

log_success() {
    echo -e "${GREEN}✓${NC} $1"
}

log_error() {
    echo -e "${RED}✗${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

log_header() {
    echo ""
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════════${NC}"
}

# ============== UNINSTALL FUNCTIONS ==============

confirm_uninstall() {
    echo -e "\n${YELLOW}This will uninstall all GameForLinux games${NC}"
    read -p "Are you sure? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Uninstall cancelled"
        exit 0
    fi
}

remove_symlinks() {
    log_info "Removing system shortcuts..."
    
    for game in "${GAMES[@]}"; do
        if [ -L "${BIN_DIR}/${game}" ]; then
            sudo rm -f "${BIN_DIR}/${game}" 2>/dev/null && \
            log_success "Removed ${game}"
        fi
    done
}

remove_binaries() {
    log_info "Removing game binaries..."
    
    if [ -d "$INSTALL_DIR" ]; then
        rm -rf "$INSTALL_DIR"
        log_success "Cleaned installation directory"
    fi
}

# ============== MAIN EXECUTION ==============

main() {
    log_header "🗑️  GameForLinux Uninstaller"
    
    confirm_uninstall
    
    log_header "Removing Games"
    
    remove_symlinks
    remove_binaries
    
    echo ""
    log_success "All games have been uninstalled"
    log_info "Thank you for playing! 🎮"
    echo ""
}

# Run main function
main "$@"
