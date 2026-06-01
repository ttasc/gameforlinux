# 🎮 GameForLinux

> **Play awesome Terminal UI games on Linux - No compilation, no hassle, just pure fun!**

[![GitHub Release](https://img.shields.io/github/v/release/ttasc/gameforlinux?style=for-the-badge&color=00d4ff)](https://github.com/ttasc/gameforlinux/releases)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](LICENSE)
[![Linux](https://img.shields.io/badge/Platform-Linux-FCC624?style=for-the-badge&logo=linux)](https://www.linux.org)

---

## ⚡ Quick Start

**Install all games with one command:**

```bash
curl -fsSL https://raw.githubusercontent.com/ttasc/gameforlinux/main/scripts/install.sh | sh
```

Your games are now ready to play! 🎉

---

## 🎯 Available Games

<!-- GAMES_START -->
| Game | Description | Link |
|------|-------------|------|
| **gotermoku** | A minimal, terminal-based Gomoku game written in Go. | [ttasc/gotermoku](https://github.com/ttasc/gotermoku) |
| **typense** | A minimalist, real-time typing survival game for the terminal. | [ttasc/typense](https://github.com/ttasc/typense) |
| **termdash** | A minimalist geometry dash clone on the terminal. | [ttasc/termdash](https://github.com/ttasc/termdash) |
| **termtron** | Real-time Tron lightcycle duel for the terminal. | [ttasc/termtron](https://github.com/ttasc/termtron) |
| **termines** | A minimalist, terminal-first Minesweeper clone written in Go. | [ttasc/termines](https://github.com/ttasc/termines) |
| **sudokute** | A minimalist, terminal-native Sudoku implementation written in Go. | [ttasc/sudokute](https://github.com/ttasc/sudokute) |
| **termpac** | A minimalist, terminal-first Pacman clone written in Go. | [ttasc/termpac](https://github.com/ttasc/termpac) |
| **2048** | A minimal, terminal-based 2048 game. | [ttasc/2048](https://github.com/ttasc/2048) |
<!-- GAMES_END -->

> *Built on the blazing-fast [ttbox](https://github.com/ttasc/ttbox) TUI library.*

---

## 📦 Usage & Installation Methods

### Method 1: Using Make (Recommended for developers)
```bash
git clone https://github.com/ttasc/gameforlinux.git
cd gameforlinux

# Install all games
make install

# Or install a specific game
make install-sudokute
```

### Method 2: Manual Download
Download the binary files directly from **GitHub Releases** on each *game's repository*. Then:
```bash
# Example for one game
chmod +x <game-name>
sudo mv <game-name> /usr/local/bin/
```

### 🎮 How to play
Just type the name of the installed game in your terminal:
```bash
sudokute
```

### 🧹 Management
```bash
make test             # Verify installations
make uninstall        # Remove all games
make uninstall-termines # Remove specific game
make build            # Build all games from source
```

---

## 💻 System Requirements
- **OS:** Linux, macOS (Darwin), FreeBSD, OpenBSD, NetBSD, DragonFly
- **Architecture:** x86_64 (amd64), ARM64 (Apple Silicon), x86 (386)
- **Terminal:** Any POSIX-compliant terminal
- **Dependencies:** None! (Static binaries)

---

## 📁 Project Structure
This repository uses a zero-bloat, centralized configuration:
```text
gameforlinux/
├── CONTRIBUTING.md     # How to add a new game
├── games.list          # Single Source of Truth for all games
├── Makefile            # Dynamic task delegator
├── README.md           # Project documentation
├── scripts
│   ├── builds.sh       # Compile games from source
│   ├── install.sh      # Smart POSIX installer
│   ├── readme.sh       # Auto-generate games table for README.md
│   ├── test.sh         # Verify installations
│   ├── uninstall.sh    # Clean uninstaller
│   └── web.sh          # Auto-generate index.html from template.html
└── template.html       # A website template
```

---

## 🤝 Contributing

Adding your game is incredibly easy! See [CONTRIBUTING.md](CONTRIBUTING.md) for details.
**TL;DR:** Just add your game's repository name to the `games.list` file and submit a PR!

---

## 📄 License
MIT License - See [LICENSE](LICENSE) file for details.

---

<div align="center">

Made with ❤️ by [ttasc](https://github.com/ttasc)

</div>
