#!/bin/sh
# uninstall.sh - remove gameforlinux games

set -e

PREFIX="${PREFIX:-/usr/local}"
BINDIR="${PREFIX}/bin"
CACHEDIR="${HOME}/.gameforlinux"
GAMES_FILE="$(dirname "$0")/games.list"

# Hàm xử lý gỡ cài đặt 1 tựa game
uninstall_game() {
    game="$1"

    # Xóa symlink ở /usr/local/bin
    if [ -L "$BINDIR/$game" ] || [ -f "$BINDIR/$game" ]; then
        if [ -w "$BINDIR" ]; then
            rm -f "$BINDIR/$game"
        else
            sudo rm -f "$BINDIR/$game"
        fi
        echo "removed symlink $BINDIR/$game"
    fi

    # Xóa file nhị phân trong thư mục cache
    if [ -f "$CACHEDIR/$game" ]; then
        rm -f "$CACHEDIR/$game"
        echo "removed binary $CACHEDIR/$game"
    fi
}

# Nếu có tham số (ví dụ: ./uninstall.sh sudokute), chỉ xóa game đó
if [ $# -gt 0 ]; then
    for game in "$@"; do
        uninstall_game "$game"
    done
# Nếu không có tham số, đọc từ file games.list để xóa tất cả
else
    if [ ! -f "$GAMES_FILE" ]; then
        echo "error: $GAMES_FILE not found" >&2
        exit 1
    fi

    while IFS= read -r game ||[ -n "$game" ]; do
        [ -z "$game" ] ||[ "${game#\#}" != "$game" ] && continue
        uninstall_game "$game"
    done < "$GAMES_FILE"

    # Xóa luôn thư mục cache vì đang gỡ cài đặt toàn bộ
    if [ -d "$CACHEDIR" ]; then
        rm -rf "$CACHEDIR"
        echo "removed directory $CACHEDIR"
    fi
fi

echo "uninstallation complete."
