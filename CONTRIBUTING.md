# 🤝 Contributing to GameForLinux

Thank you for considering contributing to GameForLinux! We use a highly optimized, "Suckless" architecture. Adding a new game requires **zero scripting**. Everything is handled dynamically based on a single source of truth.

---

## 📋 Requirements for Your Game

1. **Language:** Go (to maintain consistency and ease of cross-compilation).
2. **TUI Library:** Built on or compatible with [ttbox](https://github.com/ttasc/ttbox) (or any minimal terminal UI library).
3. **Platform:** Linux-first (POSIX-compliant).
4. **Build:** Must compile to a single, static binary.
5. **Releases:** Your repository must have GitHub Releases with assets formatted as `<repo-name>-<os>-<arch>` (e.g., `mygame-linux-amd64`).

---

## 🚀 How to Add Your Game

### Step 1: Fork & Clone
```bash
git clone https://github.com/yourusername/gameforlinux.git
cd gameforlinux
git checkout -b add-mygame
```

### Step 2: Update the Core List
Open the `games.list` file in the root directory and add your game using the `username/repo` format on a new line:

```text
ttasc/sudokute
ttasc/termines
...
yourusername/mygame
```

### Step 3: Auto-Generate the README
**Do not manually edit the `README.md` table.** We have a built-in script that automatically fetches your repository's description! Just run:

```bash
make readme
```
*This command reads `games.list`, fetches the description directly from your repository's README, and updates the "Available Games" table in our `README.md` automatically.*

### Step 4: Test Your Addition
Verify that the automation scripts recognize your game dynamically (replace `mygame` with your repository name):
```bash
make install-mygame
make test-mygame
make uninstall-mygame
```

### Step 5: Submit a Pull Request
Commit the two changed files (`games.list` and `README.md`) and push to your fork!

```bash
git add games.list README.md
git commit -m "feat: add mygame to collection"
git push origin add-mygame
```

---

**That's it!** You don't need to touch `install.sh`, `Makefile`, `builds.sh`, or create any document folders. The architecture handles everything automatically.
