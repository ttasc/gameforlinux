#!/bin/sh
# test.sh - verify game installations

GAMES_FILE="$(dirname "$0")/games.list"
errors=0

# Function to verify a single game installation
verify_game() {
    entry="$1"

    # Parse repo name from entry (e.g., "author/repo" -> "repo")
    repo="${entry##*/}"

    if ! command -v "$repo" >/dev/null 2>&1; then
        echo "FAIL: $repo is not in PATH or not executable" >&2
        errors=$((errors + 1))
    else
        echo "OK: $repo"
    fi
}

echo "verifying installations..."

# Verify provided arguments or fallback to games.list
if [ $# -gt 0 ]; then
    for game in "$@"; do
        verify_game "$game"
    done
else
    if [ ! -f "$GAMES_FILE" ]; then
        echo "error: $GAMES_FILE not found" >&2
        exit 1
    fi
    while IFS= read -r line || [ -n "$line" ]; do
        # Skip empty lines and comments
        [ -z "$line" ] ||[ "${line#\#}" != "$line" ] && continue
        verify_game "$line"
    done < "$GAMES_FILE"
fi

if [ "$errors" -gt 0 ]; then
    echo "verification failed with $errors error(s)." >&2
    exit 1
fi

echo "all checked games verified successfully."
