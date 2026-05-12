#!/bin/sh

ORG="ttasc"
HUB_REPO="gameforlinux"
BASE_RAW_URL="https://raw.githubusercontent.com"

TEMPLATE="template.html"
OUTPUT="index.html"
GAMES_FILE="$(dirname "$0")/../games.list"

if [ ! -f "$TEMPLATE" ] || [ ! -f "$GAMES_FILE" ]; then
    echo "[ERROR] $TEMPLATE or $GAMES_FILE not found!"
    exit 1
fi

TMP_CARDS=$(mktemp)

echo "=> [1/3] Reading game list..."

grep -v '^#' "$GAMES_FILE" | grep -v '^[[:space:]]*$' | while IFS= read -r entry; do

    if echo "$entry" | grep -q "/"; then
        OWNER=$(echo "$entry" | cut -d'/' -f1)
        REPO=$(echo "$entry" | cut -d'/' -f2)
    else
        OWNER="$ORG"
        REPO="$entry"
    fi

    echo "   -> Fetching $OWNER/$REPO..."

    README_URL="$BASE_RAW_URL/$OWNER/$REPO/main/README.md"
    HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$README_URL")

    if [ "$HTTP_STATUS" != "200" ]; then
        README_URL="$BASE_RAW_URL/$OWNER/$REPO/master/README.md"
    fi

    TMP_README=$(mktemp)
    curl -sL "$README_URL" > "$TMP_README"

    TITLE="$REPO"
    DESC="A minimal terminal application."
    FEATURES_HTML=""
    FEATURES_SEARCH=""

    if [ -s "$TMP_README" ]; then
        PARSED_TITLE=$(grep -m 1 '^# ' "$TMP_README" | sed 's/^# //; s/^[[:space:]]*//; s/[[:space:]]*$//')
        [ -n "$PARSED_TITLE" ] && TITLE="$PARSED_TITLE"

        PARSED_DESC=$(awk '/^#/ || /^!/ || /^\[/ { next } NF > 0 { print; exit }' "$TMP_README" | sed 's/"/\&quot;/g; s/</\&lt;/g; s/>/\&gt;/g')
        [ -n "$PARSED_DESC" ] && DESC="$PARSED_DESC"

        FEATURES=$(awk '/^## Features/{flag=1; next} /^## /{flag=0} flag {print}' "$TMP_README" | grep -o '\*\*[^*]*\*\*' | sed 's/\*\*//g' | sed 's/://g')

        echo "$FEATURES" | while IFS= read -r f; do
            if [ -n "$f" ]; then
                SAFE_F=$(echo "$f" | sed 's/"/\&quot;/g; s/</\&lt;/g; s/>/\&gt;/g')
                FEATURES_HTML="$FEATURES_HTML<span class=\"tag\">$SAFE_F</span>"
                FEATURES_SEARCH="$FEATURES_SEARCH $SAFE_F"
            fi
        done

        if [ -n "$FEATURES" ]; then
            FEATURES_HTML=$(echo "$FEATURES" | awk 'NF' | while read -r f; do echo "<span class=\"tag\">$f</span>"; done | tr -d '\n')
            FEATURES_HTML="<div class=\"tags\">$FEATURES_HTML</div>"

            FEATURES_SEARCH=$(echo "$FEATURES" | tr '\n' ' ')
        fi
    fi
    rm -f "$TMP_README"

    DEMO_URL="$BASE_RAW_URL/$OWNER/$REPO/refs/heads/master/demo.gif"
    SEARCH_STRING=$(echo "$TITLE $DESC $FEATURES_SEARCH" | tr '[:upper:]' '[:lower:]' | sed 's/"/\&quot;/g')

    cat <<EOF >> "$TMP_CARDS"
            <article class="game-card" data-search="${SEARCH_STRING}">
                <div class="game-desc">
                    <h3 class="game-title">
                        <span>${TITLE}</span>
                        <a href="https://github.com/${OWNER}/${REPO}" target="_blank" rel="noopener noreferrer" aria-label="View source code for ${TITLE}">View Source ↗</a>
                    </h3>
                    <p>${DESC}</p>
                    ${FEATURES_HTML}
                </div>
                <div class="game-footer">
                    <p class="text-comment font-sm" style="margin-bottom: 0.5rem;">// Install standalone:</p>
                    <div class="cmd" aria-label="Copy install command for ${TITLE}">curl -fsSL ${BASE_RAW_URL}/${ORG}/${HUB_REPO}/main/scripts/install.sh | sh -s -- ${REPO}</div>
                    <button class="btn btn-demo" data-demo-url="${DEMO_URL}" aria-label="Watch gameplay demo for ${TITLE}">Watch Demo</button>
                </div>
            </article>
EOF
done

echo "=> [2/3] Data compilation successful."

GAME_COUNT=$(grep -c 'class="game-card"' "$TMP_CARDS")

echo "=> [3/3] Rendering HTML..."

awk -v cards_file="$TMP_CARDS" -v count="$GAME_COUNT" '
    /id="available-games-title"/ {
        sub("Available Games", "Available Games (" count ")")
    }
    /\{\{GAMES_LIST\}\}/ {
        while ((getline line < cards_file) > 0)
            print line
        next
    }
    {print}
' "$TEMPLATE" > "$OUTPUT"

rm -f "$TMP_CARDS"

echo
echo "Done."
