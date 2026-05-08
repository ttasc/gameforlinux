#!/bin/sh
# install.sh - download and install gameforlinux binaries

set -e

ORG="ttasc"
PREFIX="${PREFIX:-/usr/local}"
BINDIR="${PREFIX}/bin"
CACHEDIR="${HOME}/.gameforlinux"
GAMES_FILE="$(dirname "$0")/games.list"

# Kiểm tra công cụ tải xuống
if command -v curl >/dev/null 2>&1; then
    DL="curl -fsSL -o"
elif command -v wget >/dev/null 2>&1; then
    DL="wget -qO"
else
    echo "error: curl or wget required" >&2
    exit 1
fi

# Nhận diện kiến trúc
arch=$(uname -m)
case "$arch" in
    x86_64|amd64) arch="linux-amd64" ;;
    aarch64|arm64) arch="linux-arm64" ;;
    i*86) arch="linux-386" ;;
    *) echo "error: unsupported arch: $arch" >&2; exit 1 ;;
esac

mkdir -p "$CACHEDIR"

# Hàm xử lý cài đặt 1 tựa game
install_game() {
    game="$1"
    echo "downloading $game ($arch)..."

    # Lấy tag mới nhất từ GitHub API (nếu lỗi sẽ dự phòng là 'latest')
    tag=$($DL - "https://api.github.com/repos/$ORG/$game/releases/latest" 2>/dev/null | grep '"tag_name"' | cut -d'"' -f4)
    [ -z "$tag" ] && tag="latest"

    url="https://github.com/$ORG/$game/releases/download/$tag/$game-$arch"

    if $DL "$CACHEDIR/$game" "$url"; then
        chmod +x "$CACHEDIR/$game"
        # Chỉ gọi sudo nếu người dùng không có quyền ghi vào BINDIR
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

# Nếu có tham số (ví dụ: ./install.sh sudokute), chỉ cài game đó
if [ $# -gt 0 ]; then
    for game in "$@"; do
        install_game "$game"
    done
# Nếu không có tham số, đọc từ file games.list để cài tất cả
else
    if [ ! -f "$GAMES_FILE" ]; then
        echo "error: $GAMES_FILE not found" >&2
        exit 1
    fi
    while IFS= read -r game || [ -n "$game" ]; do
        # Bỏ qua dòng trống hoặc dòng comment
        [ -z "$game" ] ||[ "${game#\#}" != "$game" ] && continue
        install_game "$game"
    done < "$GAMES_FILE"
fi

echo "done."
