# 🤝 Contributing to GameForLinux

Thank you for considering contributing to GameForLinux! We use a highly optimized, "Suckless" architecture. Adding a new game requires **zero scripting**. Everything is handled dynamically based on a single source of truth.

---

## 📋 Requirements for Your Game

To be included in the collection, your repository must meet the following criteria:

### 🛠 Technical Requirements
1. **Language:** Go (to maintain consistency and ease of cross-compilation).
2. **TUI Library:** Built on [ttbox](https://github.com/ttasc/ttbox) or any minimal terminal UI library.
3. **Platform:** POSIX-compliant (Linux, macOS, BSD).
4. **Build:** Must compile to a single, static binary with no external dependencies.
5. **Releases (Crucial):** Your repository must use GitHub Releases. Release assets **must** follow the `<repo-name>-<os>-<arch>` format (e.g., `mygame-linux-amd64`, `mygame-darwin-arm64`).

### 🎨 Display Requirements (For Website & README)
Our automated scripts scrape your repository to build the [GameForLinux Website](https://ttasc.github.io/gameforlinux/) and update this repo's README. Please format your game's repository as follows:
1. **Description:** Ensure your repository's `README.md` starts with an `H1` title (`# Your Game Name`), immediately followed by a short description sentence.
2. **Features:** Include a `## Features` section with bullet points. These will be converted into tags on our website.
3. **Demo:** Place a `demo.gif` in the root directory of your `main` or `master` branch. The website will automatically use this for the "Watch Demo" button.

---

## 🚀 How to Add Your Game

### Step 1: Fork & Clone
Fork this repository to your GitHub account, then clone it locally:
```bash
git clone https://github.com/yourusername/gameforlinux.git
cd gameforlinux
git checkout -b add-mygame
```

### Step 2: Update the Core List
Open the `games.list` file in the root directory and add your game using the `username/repo` format on a new line at the bottom:

```text
ttasc/sudokute
ttasc/termines
...
yourusername/mygame
```

### Step 3: Test Your Addition Locally
Verify that the automation scripts recognize your game dynamically (replace `mygame` with your repository name):
```bash
make install-mygame
make test-mygame
make uninstall-mygame
```

### Step 4: Commit & Submit a Pull Request
> ⚠️ **IMPORTANT:** **Do NOT run `make readme`, `make web`, or manually edit `README.md` / `index.html`.**
> Our GitHub Actions CI/CD pipeline will automatically fetch your descriptions and rebuild the README and Website once your PR is merged.

You only need to commit the `games.list` file:

```bash
git add games.list
git commit -m "feat: add mygame to collection"
git push origin add-mygame
```

Head over to the original repository and open a Pull Request. **That's it!** The system architecture handles everything else for you.
