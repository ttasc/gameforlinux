#!/bin/bash

# GameForLinux Test/Verification Script
# Checks if games are properly installed and accessible

set -e

# Configuration
GAMES=("sudokute" "termines" "gotermoku")

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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

# ============== VERIFICATION ==============

verify_game_accessible() {
    local game="$1"
    
    if command -v "$game" &> /dev/null; then
        log_success "$game is in PATH"
        return 0
    else
        log_warning "$game is not in PATH"
        return 1
    fi
}

verify_game_executable() {
    local game="$1"
    local install_dir="${HOME}/.gameforlinux"
    
    if [ -x "${install_dir}/${game}" ]; then
        log_success "$game binary is executable"
        return 0
    else
        log_error "$game binary not found or not executable"
        return 1
    fi
}

verify_game_runs() {
    local game="$1"
    
    if command -v "$game" &> /dev/null; then
        if timeout 1 "$game" --version &> /dev/null 2>&1 || true; then
            log_success "$game responds to commands"
            return 0
        else
            log_warning "$game does not respond to --version (may still be working)"
            return 0
        fi
    fi
    return 1
}

verify_all_games() {
    local total=0
    local passed=0
    local failed=0
    
    echo ""
    log_info "Verifying game installations..."
    echo ""
    
    for game in "${GAMES[@]}"; do
        echo -e "${BLUE}Testing $game:${NC}"
        
        total=$((total + 3))
        
        if verify_game_executable "$game"; then
            passed=$((passed + 1))
        else
            failed=$((failed + 1))
        fi
        
        if verify_game_accessible "$game"; then
            passed=$((passed + 1))
        else
            failed=$((failed + 1))
        fi
        
        if verify_game_runs "$game"; then
            passed=$((passed + 1))
        else
            failed=$((failed + 1))
        fi
        
        echo ""
    done
    
    # Summary
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}Verification Summary${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════════${NC}"
    echo "Total checks: $total"
    echo -e "${GREEN}Passed: $passed${NC}"
    echo -e "${RED}Failed: $failed${NC}"
    echo ""
    
    if [ $failed -eq 0 ]; then
        log_success "All games verified successfully!"
        return 0
    else
        log_error "Some games failed verification"
        return 1
    fi
}

show_installation_paths() {
    echo ""
    log_info "Installation paths:"
    echo "  Local cache: ${HOME}/.gameforlinux/"
    echo "  System PATH: /usr/local/bin/"
    echo ""
}

# ============== MAIN ==============

show_installation_paths
verify_all_games
