#!/bin/sh
# test.sh - verify game installations

GAMES_FILE="$(dirname "$0")/games.list"
errors=0

# Hàm verify 1 game
verify_game() {
    game="$1"
    # Lệnh command -v kiểm tra xem file có trong PATH và có quyền thực thi không
    if ! command -v "$game" >/dev/null 2>&1; then
        echo "FAIL: $game is not in PATH or not executable" >&2
        errors=$((errors + 1))
    else
        echo "OK: $game"
    fi
}

echo "verifying installations..."

# Chạy test theo đối số hoặc theo danh sách list
if [ $# -gt 0 ]; then
    for game in "$@"; do
        verify_game "$game"
    done
else
    if [ ! -f "$GAMES_FILE" ]; then
        echo "error: $GAMES_FILE not found" >&2
        exit 1
    fi
    while IFS= read -r game ||[ -n "$game" ]; do
        [ -z "$game" ] ||[ "${game#\#}" != "$game" ] && continue
        verify_game "$game"
    done < "$GAMES_FILE"
fi

# Trả về kết quả
if [ "$errors" -gt 0 ]; then
    echo "verification failed with $errors error(s)." >&2
    exit 1
fi

echo "all checked games verified successfully."
