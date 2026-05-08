#!/bin/bash

# GameForLinux Installation Script
# A collection of Terminal UI games for Linux
# Script: Automated installer with architecture detection

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
GITHUB_ORG="ttasc"
RELEASE_BASE="https://github.com"

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

# ============== SYSTEM DETECTION ==============

detect_architecture() {
    local arch=$(uname -m)
    case "$arch" in
        x86_64|amd64)
            echo "linux-amd64"
            ;;
        aarch64|arm64)
            echo "linux-arm64"
            ;;
        i386|i686)
            echo "linux-386"
            ;;
        *)
            log_error "Unsupported architecture: $arch"
            exit 1
            ;;
    esac
}

detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    else
        log_error "This script only supports Linux"
        exit 1
    fi
}

# ============== DOWNLOAD FUNCTIONS ==============

download_file() {
    local url="$1"
    local output="$2"
    
    if command -v curl &> /dev/null; then
        curl -fsSL -o "$output" "$url" || return 1
    elif command -v wget &> /dev/null; then
        wget -q -O "$output" "$url" || return 1
    else
        log_error "Neither curl nor wget found. Please install one of them."
        return 1
    fi
}

get_latest_release() {
    local repo="$1"
    # Get latest release tag
    curl -fsSL "https://api.github.com/repos/${GITHUB_ORG}/${repo}/releases/latest" 2>/dev/null | 
    grep '"tag_name"' | head -1 | sed 's/.*"v\?\([^"]*\)".*/\1/' || echo "latest"
}

download_game() {
    local game="$1"
    local arch="$2"
    local dest="$3"
    
    log_info "Downloading $game ($arch)..."
    
    # Construct download URL
    local release_tag=$(get_latest_release "$game")
    local download_url="${RELEASE_BASE}/${GITHUB_ORG}/${game}/releases/download/v${release_tag}/${game}-${arch}"
    
    if download_file "$download_url" "${dest}/${game}"; then
        chmod +x "${dest}/${game}"
        log_success "$game downloaded successfully"
        return 0
    else
        log_error "Failed to download $game"
        return 1
    fi
}

# ============== INSTALLATION FUNCTIONS ==============

setup_directories() {
    log_info "Setting up directories..."
    mkdir -p "$INSTALL_DIR"
    log_success "Installation directory ready: $INSTALL_DIR"
}

install_games() {
    local arch=$(detect_architecture)
    local failed_games=()
    
    log_header "📥 Installing Games"
    
    for game in "${GAMES[@]}"; do
        if ! download_game "$game" "$arch" "$INSTALL_DIR"; then
            failed_games+=("$game")
        fi
    done
    
    if [ ${#failed_games[@]} -gt 0 ]; then
        log_warning "Failed to install: ${failed_games[*]}"
        return 1
    fi
    
    return 0
}

create_symlinks() {
    log_info "Creating system shortcuts..."
    
    # Check if we have sudo privileges
    if ! sudo -n true 2>/dev/null; then
        log_warning "This step requires sudo privileges"
        log_info "Please enter your password to create system shortcuts:"
    fi
    
    for game in "${GAMES[@]}"; do
        if [ -f "${INSTALL_DIR}/${game}" ]; then
            sudo ln -sf "${INSTALL_DIR}/${game}" "${BIN_DIR}/${game}" 2>/dev/null || \
            log_warning "Could not create symlink for $game (may need manual setup)"
        fi
    done
    
    log_success "Shortcuts created"
}

verify_installation() {
    log_header "🔍 Verifying Installation"
    
    local all_ok=true
    for game in "${GAMES[@]}"; do
        if command -v "$game" &> /dev/null; then
            log_success "$game is ready to play"
        else
            log_warning "$game path not in PATH (but binary exists in $INSTALL_DIR)"
            all_ok=false
        fi
    done
    
    return 0
}

show_summary() {
    log_header "✨ Installation Complete!"
    
    echo ""
    echo -e "${GREEN}🎮 You can now play:${NC}"
    for game in "${GAMES[@]}"; do
        echo -e "   ${BLUE}•${NC} $game"
    done
    
    echo ""
    echo -e "${GREEN}Example:${NC}"
    echo -e "   ${BLUE}$ sudokute${NC}"
    echo ""
    echo -e "${GREEN}To update games:${NC}"
    echo -e "   ${BLUE}$ make update${NC}"
    echo ""
    echo -e "${GREEN}To uninstall:${NC}"
    echo -e "   ${BLUE}$ bash uninstall.sh${NC}"
    echo ""
    echo -e "${GREEN}More info:${NC}"
    echo -e "   ${BLUE}https://github.com/ttasc/gameforlinux${NC}"
    echo ""
}

# ============== MAIN EXECUTION ==============

main() {
    clear
    
    echo -e "${BLUE}"
    echo "  ██████╗  █████╗ ███╗   ███╗███████╗███████╗ ██████╗ ██████╗ ██╗     ██╗███╗   ██╗██╗   ██╗██╗  ██╗"
    echo " ██╔════╝ ██╔══██╗████╗ ████║██╔════╝██╔════╝██╔═══██╗██╔══██╗██║     ██║████╗  ██║██║   ██║╚██╗██╔╝"
    echo " ██║  ███╗███████║██╔████╔██║█████╗  █████╗  ██║   ██║██████╔╝██║     ██║██╔██╗ ██║██║   ██║ ╚███╔╝ "
    echo " ██║   ██║██╔══██║██║╚██╔╝██║██╔══╝  ██╔══╝  ██║   ██║██╔══██╗██║     ██║██║╚██╗██║██║   ██║ ██╔██╗ "
    echo " ╚██████╔╝██║  ██║██║ ╚═╝ ██║███████╗███████╗╚██████╔╝██║  ██║███████╗██║██║ ╚████║╚██████╔╝██╔╝ ██╗"
    echo "  ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝"
    echo -e "${NC}"
    
    log_header "🎮 GameForLinux Installer"
    
    # Verify system
    log_info "Checking system..."
    detect_os > /dev/null
    local arch=$(detect_architecture)
    log_success "System: Linux ($arch)"
    
    # Setup and install
    setup_directories
    
    if install_games; then
        create_symlinks
        verify_installation
        show_summary
        exit 0
    else
        log_error "Installation failed. Please check your internet connection and try again."
        exit 1
    fi
}

# Run main function
main "$@"
