#!/bin/sh
# readme.sh - Auto-generate games table for README.md

set -e

GAMES_FILE="$(dirname "$0")/games.list"
README_FILE="$(dirname "$0")/README.md"
TABLE_TMP="/tmp/gameforlinux_table.tmp"

echo "generating table..."

echo "| Game | Description | Link |" > "$TABLE_TMP"
echo "|------|-------------|------|" >> "$TABLE_TMP"

while IFS= read -r line || [ -n "$line" ]; do
    [ -z "$line" ] ||[ "${line#\#}" != "$line" ] && continue

    owner="${line%/*}"
    repo="${line##*/}"
    [ "$owner" = "$line" ] && owner="ttasc"

    echo "  -> fetching $owner/$repo"

    readme=$(curl -sL "https://raw.githubusercontent.com/$owner/$repo/main/README.md")
    if echo "$readme" | grep -q "404: Not Found"; then
        readme=$(curl -sL "https://raw.githubusercontent.com/$owner/$repo/master/README.md")
    fi

    desc=$(echo "$readme" | awk '/^# /{flag=1; next} flag && NF {print; exit}')
    [ -z "$desc" ] && desc="A minimal terminal game."

    echo "| **$repo** | $desc | [$owner/$repo](https://github.com/$owner/$repo) |" >> "$TABLE_TMP"
done < "$GAMES_FILE"

sed -n '1,/<!-- GAMES_START -->/p' "$README_FILE" > "${README_FILE}.new"
cat "$TABLE_TMP" >> "${README_FILE}.new"
sed -n '/<!-- GAMES_END -->/,$p' "$README_FILE" >> "${README_FILE}.new"

mv "${README_FILE}.new" "$README_FILE"
rm -f "$TABLE_TMP"

echo "README.md updated successfully!"
