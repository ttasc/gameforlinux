# 🤝 Contributing to GameForLinux

Thank you for considering contributing to GameForLinux! We use a highly optimized, "Suckless" architecture. Adding a new game requires **zero scripting**.

---

## 📋 Requirements for Your Game

1. **Language:** Go (to maintain consistency)
2. **TUI Library:** Built on or compatible with [ttbox](https://github.com/ttasc/ttbox)
3. **Platform:** Linux-first
4. **Build:** Must compile to a single, static binary
5. **Releases:** Your repository must have GitHub Releases with assets formatted as `<game-name>-<os>-<arch>` (e.g., `mygame-linux-amd64`).

---

## 🚀 How to Add Your Game

### Step 1: Fork & Clone
```bash
git clone https://github.com/ttasc/gameforlinux.git
cd gameforlinux
git checkout -b add-mygame
```

### Step 2: Update the Core List
Open the `games.list` file in the root directory and add your game's repository name on a new line:

```text
sudokute
termines
gotermoku
mygame
```

### Step 3: Update the README
Add your game to the "🎯 Available Games" table in `README.md`:

```markdown
| **🎮 MyGame** | Category | Short description of your game | [author/mygame](https://github.com/author/mygame) |
```

### Step 4: Test Your Addition
Verify that the automation scripts recognize your game dynamically:
```bash
make install-mygame
make test-mygame
make uninstall-mygame
```

### Step 5: Submit a Pull Request
Commit your two changed files (`games.list` and `README.md`) and push!

```bash
git add games.list README.md
git commit -m "feat: add MyGame to collection"
git push origin add-mygame
```

---

**That's it!** You don't need to touch `install.sh`, `Makefile`, or create any document folders. The architecture handles everything automatically.
