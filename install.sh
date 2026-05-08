#!/bin/sh
# install.sh - download and install gameforlinux binaries

set -e

ORG="ttasc"
PREFIX="${PREFIX:-/usr/local}"
BINDIR="${PREFIX}/bin"
CACHEDIR="${HOME}/.gameforlinux"
GAMES_FILE="$(dirname "$0")/games.list"

if command -v curl >/dev/null 2>&1; then
    DL="curl -fsSL -o"
elif command -v wget >/dev/null 2>&1; then
    DL="wget -qO"
else
    echo "error: curl or wget required" >&2
    exit 1
fi

os=$(uname -s | tr '[:upper:]' '[:lower:]')
case "$os" in
    linux|darwin|freebsd|openbsd|netbsd|dragonfly) ;;
    *) echo "error: unsupported os: $os" >&2; exit 1 ;;
esac

arch=$(uname -m)
case "$arch" in
    x86_64|amd64) arch="amd64" ;;
    aarch64|arm64) arch="arm64" ;;
    i*86) arch="386" ;;
    *) echo "error: unsupported arch: $arch" >&2; exit 1 ;;
esac

echo "setting up gameforlinux ($os-$arch)..."

mkdir -p "$CACHEDIR"

install_game() {
    game="$1"
    echo "downloading $game ($os-$arch)..."

    tag=$($DL - "https://api.github.com/repos/$ORG/$game/releases/latest" 2>/dev/null | grep '"tag_name"' | cut -d'"' -f4)
    [ -z "$tag" ] && tag="latest"

    url="https://github.com/$ORG/$game/releases/download/$tag/$game-$os-$arch"

    if $DL "$CACHEDIR/$game" "$url"; then
        chmod +x "$CACHEDIR/$game"
        if [ -w "$BINDIR" ]; then
            ln -sf "$CACHEDIR/$game" "$BINDIR/$game"
        else
            sudo ln -sf "$CACHEDIR/$game" "$BINDIR/$game"
        fi
        echo "installed $game"
    else
        echo "error: failed to download $game" >&2
        return 1
    fi
}

if [ $# -gt 0 ]; then
    for game in "$@"; do
        install_game "$game"
    done
else
    if [ ! -f "$GAMES_FILE" ]; then
        echo "error: $GAMES_FILE not found" >&2
        exit 1
    fi
    while IFS= read -r game || [ -n "$game" ]; do [ -z "$game" ] || [ "${game#\#}" != "$game" ] && continue
        install_game "$game"
    done < "$GAMES_FILE"
fi

echo "done."
