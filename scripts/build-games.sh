#!/bin/bash

# GameForLinux Build Script
# Build games from source repositories

set -e

# Configuration
GITHUB_ORG="ttasc"
GAMES=("sudokute" "termines" "gotermoku")
BUILD_DIR="${PWD}/build"
TEMP_DIR="${TMPDIR:-/tmp}/gameforlinux-build"

# ============== UTILITY FUNCTIONS ==============

log_info() {
    echo "[INFO] $1"
}

log_error() {
    echo "[ERROR] $1" >&2
}

log_success() {
    echo "[SUCCESS] $1"
}

# ============== CHECKS ==============

check_go_installed() {
    if ! command -v go &> /dev/null; then
        log_error "Go is not installed. Please install Go 1.20 or higher."
        exit 1
    fi
    
    local go_version=$(go version | awk '{print $3}' | sed 's/go//')
    log_info "Found Go version: $go_version"
}

check_git_installed() {
    if ! command -v git &> /dev/null; then
        log_error "Git is not installed. Please install Git."
        exit 1
    fi
}

# ============== BUILD ==============

build_game() {
    local game="$1"
    local repo="${GITHUB_ORG}/${game}"
    local game_dir="${TEMP_DIR}/${game}"
    
    log_info "Building $game..."
    
    # Clone or update repository
    if [ -d "$game_dir" ]; then
        log_info "Updating $game repository..."
        (cd "$game_dir" && git pull origin main 2>/dev/null || git pull origin master)
    else
        log_info "Cloning $game repository..."
        git clone "https://github.com/${repo}.git" "$game_dir"
    fi
    
    # Build the binary
    log_info "Compiling $game..."
    (cd "$game_dir" && go build -o "${BUILD_DIR}/${game}")
    
    log_success "Built $game"
}

build_all_games() {
    local failed=()
    
    mkdir -p "$BUILD_DIR"
    mkdir -p "$TEMP_DIR"
    
    for game in "${GAMES[@]}"; do
        if ! build_game "$game"; then
            failed+=("$game")
        fi
    done
    
    if [ ${#failed[@]} -gt 0 ]; then
        log_error "Failed to build: ${failed[*]}"
        return 1
    fi
    
    return 0
}

# ============== CLEANUP ==============

cleanup() {
    log_info "Cleaning up temporary files..."
    rm -rf "$TEMP_DIR"
    log_success "Cleanup complete"
}

# ============== MAIN ==============

main() {
    log_info "GameForLinux Build Script"
    log_info "=========================="
    
    check_go_installed
    check_git_installed
    
    if [ $# -eq 0 ]; then
        log_info "Building all games..."
        build_all_games
    else
        for game in "$@"; do
            if [[ " ${GAMES[@]} " =~ " ${game} " ]]; then
                build_game "$game"
            else
                log_error "Unknown game: $game"
                exit 1
            fi
        done
    fi
    
    log_success "Build complete! Binaries are in: $BUILD_DIR"
    cleanup
}

main "$@"
