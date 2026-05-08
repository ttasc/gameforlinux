#!/bin/sh
# builds.sh - compile games from source

set -e

ORG="ttasc"
BUILD_DIR="${PWD}/build"
TEMP_DIR="${TMPDIR:-/tmp}/gameforlinux-build"
GAMES_FILE="$(dirname "$0")/games.list"

if ! command -v go >/dev/null 2>&1; then echo "error: go is not installed" >&2; exit 1; fi
if ! command -v git >/dev/null 2>&1; then echo "error: git is not installed" >&2; exit 1; fi

mkdir -p "$BUILD_DIR"
mkdir -p "$TEMP_DIR"

build_game() {
    game="$1"
    echo "fetching $game..."

    if [ -d "$TEMP_DIR/$game" ]; then
        (cd "$TEMP_DIR/$game" && git pull -q origin main >/dev/null 2>&1 || git pull -q origin master >/dev/null 2>&1)
    else
        git clone -q "https://github.com/$ORG/$game.git" "$TEMP_DIR/$game"
    fi

    if [ "$RELEASE" = "1" ]; then
        TARGETS="linux/amd64 linux/arm64 linux/386 darwin/amd64 darwin/arm64 freebsd/amd64 openbsd/amd64 netbsd/amd64 dragonfly/amd64"
        for target in $TARGETS; do
            os="${target%/*}"
            arch="${target#*/}"

            echo "building $game ($os-$arch)..."
            (cd "$TEMP_DIR/$game" && GOOS=$os GOARCH=$arch go build -ldflags="-s -w" -o "$BUILD_DIR/$game-$os-$arch")
        done
    else
        echo "building $game (native)..."
        (cd "$TEMP_DIR/$game" && go build -ldflags="-s -w" -o "$BUILD_DIR/$game")
    fi
}

if [ $# -gt 0 ]; then
    for game in "$@"; do build_game "$game"; done
else
    if [ ! -f "$GAMES_FILE" ]; then echo "error: $GAMES_FILE not found" >&2; exit 1; fi
    while IFS= read -r game || [ -n "$game" ]; do [ -z "$game" ] || [ "${game#\#}" != "$game" ] && continue
        build_game "$game"
    done < "$GAMES_FILE"
fi

echo "cleaning up..."
rm -rf "$TEMP_DIR"
echo "build complete. binaries are in $BUILD_DIR/"
