# 🤝 Contributing to GameForLinux

Thank you for considering contributing to GameForLinux! This document provides guidelines and instructions for adding your Terminal UI games.

---

## 📋 Before You Start

### Requirements for Your Game

1. **Language:** Go (to maintain consistency)
2. **TUI Library:** Built on or compatible with [ttbox](https://github.com/ttasc/ttbox)
3. **Platform:** Linux-first (other platforms optional)
4. **Build:** Must compile to a single, static binary
5. **License:** MIT or compatible open-source license

### Game Characteristics

- **Terminal-native:** Designed for terminal environments
- **Minimalist:** Simple, clean, no bloat
- **Performant:** Blazing fast, minimal resource usage
- **Self-contained:** No external dependencies

---

## 🚀 How to Contribute a New Game

### Step 1: Prepare Your Game Repository

Ensure your game:
- Has clear `README.md`
- Uses semantic versioning (tags like `v1.0.0`)
- Builds with `go build`
- Includes a binary name (e.g., `sudokute`)

### Step 2: Fork & Clone

```bash
git clone https://github.com/ttasc/gameforlinux.git
cd gameforlinux
git checkout -b add-mygame
```

### Step 3: Add Your Game Metadata

Create `games/mygame/README.md`:

```markdown
# 🎮 MyGame

**Description:** Short description of your game

**Repository:** [Link to game repo]
**Author:** Your name/GitHub
**License:** MIT

### How to Play

Explain basic controls and gameplay.

### Features

- Feature 1
- Feature 2
- Feature 3
```

### Step 4: Update Installation Scripts

#### Update `install.sh`:

```bash
# Add to GAMES array
GAMES=("sudokute" "termines" "gotermoku" "mygame")

# Add to the case statement in download_game_by_arch()
case "$game" in
  mygame)
    echo "Downloading MyGame..."
    download_from_release "your-username" "mygame-repo" "mygame"
    ;;
  # ... other games
esac
```

#### Update `uninstall.sh`:

```bash
# Add to GAMES array
GAMES=("sudokute" "termines" "gotermoku" "mygame")
```

### Step 5: Update Makefile

Add targets to `Makefile`:

```makefile
.PHONY: install-mygame
install-mygame: download-mygame
	@echo "✓ MyGame installed successfully!"

.PHONY: uninstall-mygame
uninstall-mygame:
	@rm -f /usr/local/bin/mygame
	@echo "✓ MyGame removed."
```

### Step 6: Update Main README

Add your game to the games table in `README.md`:

```markdown
| **🎮 MyGame** | Category | Description | `mygame` |
```

### Step 7: Test

```bash
# Verify installation script
make verify

# Test install
make install-mygame

# Test game runs
mygame

# Test uninstall
make uninstall-mygame
```

### Step 8: Submit Pull Request

1. **Commit your changes:**
   ```bash
   git add games/ install.sh uninstall.sh Makefile README.md
   git commit -m "Add MyGame to GameForLinux collection"
   ```

2. **Push to your fork:**
   ```bash
   git push origin add-mygame
   ```

3. **Create Pull Request** with:
   - Clear title: "Add MyGame to collection"
   - Detailed description
   - Link to game repository
   - Any special installation requirements

---

## 📝 Commit Message Guidelines

```
<type>: <subject>

<body>

<footer>
```

**Types:** `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

**Example:**
```
feat: add MyGame to GameForLinux

Add MyGame, a minimal terminal-based puzzle game built with ttbox.

Closes #123
```

---

## 🎨 Code Style Guidelines

### Bash Scripts

- Use `#!/bin/bash` shebang
- Quote all variables: `"$var"`
- Use functions for reusable code
- Include error handling: `|| exit 1`
- Add descriptive comments

### Makefile

- Use `.PHONY` for targets
- Add help comments with `##`
- Use consistent indentation (tabs)
- Keep targets focused and single-purpose

---

## 🔄 Review Process

PRs will be reviewed for:

1. ✅ Game meets requirements
2. ✅ Scripts work correctly
3. ✅ Documentation is clear
4. ✅ No breaking changes
5. ✅ License compatibility

---

## ❓ Questions?

- Check [GitHub Issues](https://github.com/ttasc/gameforlinux/issues)
- Ask in [GitHub Discussions](https://github.com/ttasc/gameforlinux/discussions)
- Email or DM maintainers

---

**Thank you for contributing!** 🎉
