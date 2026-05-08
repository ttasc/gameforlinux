#!/bin/sh
# uninstall.sh - remove gameforlinux games

set -e

PREFIX="${PREFIX:-/usr/local}"
BINDIR="${PREFIX}/bin"
CACHEDIR="${HOME}/.gameforlinux"
GAMES_FILE="$(dirname "$0")/games.list"

uninstall_game() {
    game="$1"

    if [ -L "$BINDIR/$game" ] || [ -f "$BINDIR/$game" ]; then
        if [ -w "$BINDIR" ]; then
            rm -f "$BINDIR/$game"
        else
            sudo rm -f "$BINDIR/$game"
        fi
        echo "removed symlink $BINDIR/$game"
    fi

    if [ -f "$CACHEDIR/$game" ]; then
        rm -f "$CACHEDIR/$game"
        echo "removed binary $CACHEDIR/$game"
    fi
}

if [ $# -gt 0 ]; then
    for game in "$@"; do
        uninstall_game "$game"
    done
else
    if [ ! -f "$GAMES_FILE" ]; then
        echo "error: $GAMES_FILE not found" >&2
        exit 1
    fi

    while IFS= read -r game ||[ -n "$game" ]; do
        [ -z "$game" ] ||[ "${game#\#}" != "$game" ] && continue
        uninstall_game "$game"
    done < "$GAMES_FILE"

    if [ -d "$CACHEDIR" ]; then
        rm -rf "$CACHEDIR"
        echo "removed directory $CACHEDIR"
    fi
fi

echo "uninstallation complete."
