# 🎮 GameForLinux

> **Play awesome Terminal UI games on Linux - No compilation, no hassle, just pure fun!**

[![GitHub Release](https://img.shields.io/github/v/release/ttasc/gameforlinux?style=for-the-badge&color=00d4ff)](https://github.com/ttasc/gameforlinux/releases)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](LICENSE)
[![Linux](https://img.shields.io/badge/Platform-Linux-FCC624?style=for-the-badge&logo=linux)](https://www.linux.org)

---

## ⚡ Quick Start

**Install all games with one command:**

```bash
curl -fsSL https://raw.githubusercontent.com/ttasc/gameforlinux/main/install.sh | sh
```

Your games are now ready to play! 🎉

---

## 🎯 Available Games

| Game | Type | Description | Link |
|------|------|-------------|------|
| **🧩 Sudokute** | Puzzle | A minimalist, terminal-native Sudoku implementation | [ttasc/sudokute](https://github.com/ttasc/sudokute) |
| **💣 Termines** | Strategy | A minimalist, terminal-first Minesweeper clone | [ttasc/termines](https://github.com/ttasc/termines) |
| **⭕ Gotermoku** | Strategy | A minimal, terminal-based Gomoku game | [ttasc/gotermoku](https://github.com/ttasc/gotermoku) |

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
Download binaries directly from [GitHub Releases](https://github.com/ttasc/gameforlinux/releases):
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
- **OS:** Linux (any distribution)
- **Architecture:** x86_64 (amd64), ARM64
- **Terminal:** Any POSIX-compliant terminal
- **Dependencies:** None! (Static binaries)

---

## 📁 Project Structure (Suckless Architecture)
This repository uses a zero-bloat, centralized configuration:
```text
gameforlinux/
├── builds.sh        # Compile games from source
├── CONTRIBUTING.md  # How to add a new game
├── games.list       # Single Source of Truth for all games
├── install.sh       # Smart POSIX installer
├── Makefile         # Dynamic task delegator
├── README.md        # Project documentation
├── test.sh          # Verify installations
└── uninstall.sh     # Clean uninstaller
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
