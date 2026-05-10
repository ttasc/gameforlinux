#!/bin/sh
# install.sh - download and install gameforunix binaries

set -e

DEFAULT_ORG="ttasc"
PREFIX="${PREFIX:-/usr/local}"
BINDIR="${PREFIX}/bin"
CACHEDIR="${HOME}/.gameforlinux"
GAMES_FILE="$(dirname "$0")/games.list"

# Check for required download tools
if command -v curl >/dev/null 2>&1; then
    DL="curl -fsSL -o"
elif command -v wget >/dev/null 2>&1; then
    DL="wget -qO"
else
    echo "error: curl or wget required" >&2
    exit 1
fi

# Detect operating system
os=$(uname -s | tr '[:upper:]' '[:lower:]')
case "$os" in
    linux|darwin|freebsd|openbsd|netbsd|dragonfly) ;;
    *) echo "error: unsupported os: $os" >&2; exit 1 ;;
esac

# Detect architecture
arch=$(uname -m)
case "$arch" in
    x86_64|amd64) arch="amd64" ;;
    aarch64|arm64) arch="arm64" ;;
    i*86) arch="386" ;;
    *) echo "error: unsupported arch: $arch" >&2; exit 1 ;;
esac

echo "setting up gameforlinux ($os-$arch)..."

mkdir -p "$CACHEDIR"

# Function to process and install a single game
install_game() {
    entry="$1"

    # Parse owner and repo from entry (e.g., "author/repo" or "repo")
    owner="${entry%/*}"
    repo="${entry##*/}"
    [ "$owner" = "$entry" ] && owner="$DEFAULT_ORG"

    echo "downloading $owner/$repo ($os-$arch)..."

    # Fetch latest release tag via GitHub API
    tag=$($DL - "https://api.github.com/repos/$owner/$repo/releases/latest" 2>/dev/null | grep '"tag_name"' | cut -d'"' -f4)
    [ -z "$tag" ] && tag="latest"

    url="https://github.com/$owner/$repo/releases/download/$tag/$repo-$os-$arch"

    # Download binary to cache directory
    if $DL "$CACHEDIR/$repo" "$url"; then
        chmod +x "$CACHEDIR/$repo"

        # Create symlink in the binary directory
        if [ -w "$BINDIR" ]; then
            ln -sf "$CACHEDIR/$repo" "$BINDIR/$repo"
        else
            sudo ln -sf "$CACHEDIR/$repo" "$BINDIR/$repo"
        fi
        echo "installed $repo"
    else
        echo "error: failed to download $repo" >&2
        return 1
    fi
}

# Install provided arguments or fallback to games.list
if [ $# -gt 0 ]; then
    for game in "$@"; do
        install_game "$game"
    done
else
    if [ ! -f "$GAMES_FILE" ]; then
        echo "error: $GAMES_FILE not found" >&2
        exit 1
    fi
    while IFS= read -r line || [ -n "$line" ]; do
        # Skip empty lines and comments
        [ -z "$line" ] || [ "${line#\#}" != "$line" ] && continue
        install_game "$line"
    done < "$GAMES_FILE"
fi

echo "done."
