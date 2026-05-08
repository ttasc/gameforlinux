#!/bin/bash

# GameForLinux Game Downloader
# Downloads game binaries for specific architecture

set -e

# Configuration
GITHUB_ORG="ttasc"
GAMES=("sudokute" "termines" "gotermoku")

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

# ============== DETECTION ==============

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
            return 1
            ;;
    esac
}

# ============== DOWNLOAD ==============

download_file() {
    local url="$1"
    local output="$2"
    
    if command -v curl &> /dev/null; then
        curl -fsSL -o "$output" "$url" || return 1
    elif command -v wget &> /dev/null; then
        wget -q -O "$output" "$url" || return 1
    else
        log_error "Neither curl nor wget found"
        return 1
    fi
}

get_latest_release() {
    local repo="$1"
    curl -fsSL "https://api.github.com/repos/${GITHUB_ORG}/${repo}/releases/latest" 2>/dev/null | 
    grep '"tag_name"' | head -1 | sed 's/.*"v\?\([^"]*\)".*/\1/' || echo "latest"
}

download_game() {
    local game="$1"
    local arch="$2"
    local dest="$3"
    
    log_info "Downloading $game for $arch..."
    
    local release_tag=$(get_latest_release "$game")
    local download_url="https://github.com/${GITHUB_ORG}/${game}/releases/download/v${release_tag}/${game}-${arch}"
    
    if download_file "$download_url" "${dest}/${game}"; then
        chmod +x "${dest}/${game}"
        log_success "Downloaded $game"
        return 0
    else
        log_error "Failed to download $game"
        return 1
    fi
}

download_all_games() {
    local arch="$1"
    local dest="$2"
    local failed=()
    
    mkdir -p "$dest"
    
    for game in "${GAMES[@]}"; do
        if ! download_game "$game" "$arch" "$dest"; then
            failed+=("$game")
        fi
    done
    
    if [ ${#failed[@]} -gt 0 ]; then
        log_error "Failed to download: ${failed[*]}"
        return 1
    fi
    
    return 0
}

# ============== MAIN ==============

if [ $# -lt 1 ]; then
    log_error "Usage: $0 <game-name|all> [destination]"
    log_error "Example: $0 sudokute ~/.gameforlinux/"
    exit 1
fi

GAME="$1"
DEST="${2:-.}"
ARCH=$(detect_architecture)

if [ "$GAME" = "all" ]; then
    download_all_games "$ARCH" "$DEST"
else
    download_game "$GAME" "$ARCH" "$DEST"
fi
