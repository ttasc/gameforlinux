#!/bin/sh
# uninstall.sh - remove gameforunix games

set -e

PREFIX="${PREFIX:-/usr/local}"
BINDIR="${PREFIX}/bin"
CACHEDIR="${HOME}/.gameforlinux"
GAMES_FILE="$(dirname "$0")/games.list"

# Function to uninstall a single game
uninstall_game() {
    entry="$1"

    # Parse repo name from entry (e.g., "author/repo" -> "repo")
    repo="${entry##*/}"

    # Remove symlink from binary directory
    if [ -L "$BINDIR/$repo" ] || [ -f "$BINDIR/$repo" ]; then
        if [ -w "$BINDIR" ]; then
            rm -f "$BINDIR/$repo"
        else
            sudo rm -f "$BINDIR/$repo"
        fi
        echo "removed symlink $BINDIR/$repo"
    fi

    # Remove binary from cache directory
    if [ -f "$CACHEDIR/$repo" ]; then
        rm -f "$CACHEDIR/$repo"
        echo "removed binary $CACHEDIR/$repo"
    fi
}

# Uninstall provided arguments or fallback to games.list
if [ $# -gt 0 ]; then
    for game in "$@"; do
        uninstall_game "$game"
    done
else
    if [ ! -f "$GAMES_FILE" ]; then
        echo "error: $GAMES_FILE not found" >&2
        exit 1
    fi

    while IFS= read -r line || [ -n "$line" ]; do
        # Skip empty lines and comments
        [ -z "$line" ] || [ "${line#\#}" != "$line" ] && continue
        uninstall_game "$line"
    done < "$GAMES_FILE"

    # Clean up cache directory if uninstalling all
    if [ -d "$CACHEDIR" ]; then
        rm -rf "$CACHEDIR"
        echo "removed directory $CACHEDIR"
    fi
fi

echo "uninstallation complete."
