#!/bin/sh
# builds.sh - compile games from source

set -e

DEFAULT_ORG="ttasc"
BUILD_DIR="${PWD}/build"
TEMP_DIR="${TMPDIR:-/tmp}/gameforlinux-build"
GAMES_FILE="$(dirname "$0")/../games.list"

# Check for required build tools
if ! command -v go >/dev/null 2>&1; then echo "error: go is not installed" >&2; exit 1; fi
if ! command -v git >/dev/null 2>&1; then echo "error: git is not installed" >&2; exit 1; fi

mkdir -p "$BUILD_DIR"
mkdir -p "$TEMP_DIR"

# Function to fetch and build a single game
build_game() {
    entry="$1"

    # Parse owner and repo from entry (e.g., "author/repo" or "repo")
    owner="${entry%/*}"
    repo="${entry##*/}"
    [ "$owner" = "$entry" ] && owner="$DEFAULT_ORG"

    echo "fetching $owner/$repo..."

    # Clone or update the repository
    if [ -d "$TEMP_DIR/$repo" ]; then
        (cd "$TEMP_DIR/$repo" && git pull -q origin main >/dev/null 2>&1 || git pull -q origin master >/dev/null 2>&1)
    else
        git clone -q "https://github.com/$owner/$repo.git" "$TEMP_DIR/$repo"
    fi

    # Force update ttbox to ensure cross-platform compatibility
    (cd "$TEMP_DIR/$repo" && go get -u github.com/ttasc/ttbox >/dev/null 2>&1 && go mod tidy >/dev/null 2>&1 || true)

    # Cross-compile for supported targets if RELEASE mode is enabled
    if [ "$RELEASE" = "1" ]; then
        TARGETS="linux/amd64 linux/arm64 linux/386 darwin/amd64 darwin/arm64 freebsd/amd64 openbsd/amd64 netbsd/amd64 dragonfly/amd64"
        for target in $TARGETS; do
            os="${target%/*}"
            arch="${target#*/}"

            echo "building $repo ($os-$arch)..."
            (cd "$TEMP_DIR/$repo" && GOOS=$os GOARCH=$arch go build -ldflags="-s -w" -o "$BUILD_DIR/$repo-$os-$arch")
        done
    else
        # Build natively for the current system
        echo "building $repo (native)..."
        (cd "$TEMP_DIR/$repo" && go build -ldflags="-s -w" -o "$BUILD_DIR/$repo")
    fi
}

# Build provided arguments or fallback to games.list
if [ $# -gt 0 ]; then
    for game in "$@"; do build_game "$game"; done
else
    if [ ! -f "$GAMES_FILE" ]; then echo "error: $GAMES_FILE not found" >&2; exit 1; fi
    while IFS= read -r line || [ -n "$line" ]; do
        # Skip empty lines and comments
        [ -z "$line" ] ||[ "${line#\#}" != "$line" ] && continue
        build_game "$line"
    done < "$GAMES_FILE"
fi

echo "cleaning up..."
rm -rf "$TEMP_DIR"
echo "build complete. binaries are in $BUILD_DIR/"
