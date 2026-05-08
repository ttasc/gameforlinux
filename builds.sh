#!/bin/sh
# build-games.sh - compile games from source

set -e

ORG="ttasc"
BUILD_DIR="${PWD}/build"
TEMP_DIR="${TMPDIR:-/tmp}/gameforlinux-build"
GAMES_FILE="$(dirname "$0")/games.list"

# Kiểm tra dependencies
if ! command -v go >/dev/null 2>&1; then
    echo "error: go is not installed" >&2
    exit 1
fi
if ! command -v git >/dev/null 2>&1; then
    echo "error: git is not installed" >&2
    exit 1
fi

mkdir -p "$BUILD_DIR"
mkdir -p "$TEMP_DIR"

# Hàm build 1 tựa game
build_game() {
    game="$1"
    echo "building $game..."

    if [ -d "$TEMP_DIR/$game" ]; then
        # Cập nhật repo nếu đã clone
        (cd "$TEMP_DIR/$game" && git pull -q origin main >/dev/null 2>&1 || git pull -q origin master >/dev/null 2>&1)
    else
        # Clone mới
        git clone -q "https://github.com/$ORG/$game.git" "$TEMP_DIR/$game"
    fi

    # Compile
    (cd "$TEMP_DIR/$game" && go build -o "$BUILD_DIR/$game")
    echo "built $game"
}

# Nếu có tham số, chỉ build các game đó
if [ $# -gt 0 ]; then
    for game in "$@"; do
        build_game "$game"
    done
# Nếu không, đọc games.list và build toàn bộ
else
    if [ ! -f "$GAMES_FILE" ]; then
        echo "error: $GAMES_FILE not found" >&2
        exit 1
    fi
    while IFS= read -r game || [ -n "$game" ]; do [ -z "$game" ] || [ "${game#\#}" != "$game" ] && continue
        build_game "$game"
    done < "$GAMES_FILE"
fi

echo "cleaning up..."
rm -rf "$TEMP_DIR"
echo "build complete. binaries are in $BUILD_DIR"
