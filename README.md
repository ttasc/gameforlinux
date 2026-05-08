# 🎮 GameForLinux

> **Play awesome Terminal UI games on Linux - No compilation, no hassle, just pure fun!**

[![GitHub Release](https://img.shields.io/github/v/release/ttasc/gameforlinux?style=for-the-badge&color=00d4ff)](https://github.com/ttasc/gameforlinux/releases)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](LICENSE)
[![Linux](https://img.shields.io/badge/Platform-Linux-FCC624?style=for-the-badge&logo=linux)](https://www.linux.org)

---

## ⚡ Quick Start

### Install all games with one command:

```bash
curl -fsSL https://raw.githubusercontent.com/ttasc/gameforlinux/main/install.sh | bash
```

**That's it!** Your games are ready to play. 🎉

---

## 🎯 Available Games

| Game | Type | Description | Play |
|------|------|-------------|------|
| **🧩 Sudokute** | Puzzle | A minimalist, terminal-native Sudoku implementation | `sudokute` |
| **💣 Termines** | Strategy | A minimalist, terminal-first Minesweeper clone | `termines` |
| **⚫ Gotermoku** | Strategy | A minimal, terminal-based Gomoku game | `gotermoku` |

> **More games coming soon!** Built on the blazing-fast `ttbox` TUI library.

---

## 📦 Installation Methods

### Method 1: Automated Script (Recommended) ⭐

```bash
curl -fsSL https://raw.githubusercontent.com/ttasc/gameforlinux/main/install.sh | bash
```

✅ Auto-detects your Linux architecture
✅ Downloads the correct binaries
✅ One command, all done

### Method 2: Manual Download

Download binaries directly from [GitHub Releases](https://github.com/ttasc/gameforlinux/releases):

```bash
# Make executable
chmod +x sudokute termines gotermoku

# Optional: Move to PATH
sudo mv sudokute termines gotermoku /usr/local/bin/
```

### Method 3: Using Make

```bash
# Clone the repository
git clone https://github.com/ttasc/gameforlinux.git
cd gameforlinux

# Install all games
make install

# Or install specific games
make install-sudokute
make install-termines
make install-gotermoku
```

---

## 🎮 Usage

### Play a game:

```bash
sudokute      # Start Sudoku game
termines      # Start Minesweeper game
gotermoku     # Start Gomoku game
```

### Manage installations:

```bash
# Check installation status
make verify

# Update to latest versions
make update

# Uninstall all games
./uninstall.sh

# Uninstall specific game
make uninstall-sudokute
```

---

## 💻 System Requirements

- **OS:** Linux (any distribution)
- **Architecture:** x86_64 (Intel/AMD), ARM64, x86 (32-bit)
- **Terminal:** Any POSIX-compliant terminal (bash, zsh, etc.)
- **Dependencies:** None! (Static binaries, zero external dependencies)

---

## 🔧 Build from Source

If you want to build games from source:

```bash
# Clone repository
git clone https://github.com/ttasc/gameforlinux.git
cd gameforlinux

# Build all games
make build-all

# Build specific game
make build-sudokute

# Install from local builds
make install-local
```

**Requirements:**
- Go 1.20 or higher
- Git

---

## 📁 Project Structure

This repository is designed for easy expansion. Adding new games is simple:

```
gameforlinux/
├── games/
│   ├── sudokute/
│   ├── termines/
│   ├── gotermoku/
│   └── [your-new-game]/     # Add your game here!
├── scripts/
│   ├── install-game.sh
│   ├── download-games.sh
│   └── ...
├── Makefile
├── install.sh
└── uninstall.sh
```

---

## 🤝 Contributing

### Want to add your game?

We'd love to have your Terminal UI games! See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed instructions.

### Quick steps:

1. **Fork** this repository
2. **Add your game** to the `games/` directory
3. **Update scripts** to include your game
4. **Submit a Pull Request**

---

## 📊 Project Stats

- **Games:** 3 (and counting! 📈)
- **Downloads:** Tracking soon!
- **Contributors:** Open for contributions
- **License:** MIT (Use freely, even commercially!)

---

## 🏗️ Built With

- **Language:** Go (100%)
- **TUI Library:** [ttbox](https://github.com/ttasc/ttbox) - A hyper-minimalist, POSIX-only Go library for Terminal User Interfaces
- **Package Manager Integration:** Support for Linux package managers

---

## 📄 License

MIT License - See [LICENSE](LICENSE) file for details.

---

## 🤝 Support & Community

- **Issues:** Found a bug? [Report it here](https://github.com/ttasc/gameforlinux/issues)
- **Discussions:** Join the conversation in [Discussions](https://github.com/ttasc/gameforlinux/discussions)
- **Contributing:** New game ideas? See [CONTRIBUTING.md](CONTRIBUTING.md)

---

## 🎯 Roadmap

- [x] Sudokute - Sudoku game
- [x] Termines - Minesweeper game
- [x] Gotermoku - Gomoku game
- [ ] More classic games
- [ ] Game leaderboards
- [ ] Configuration system
- [ ] Theme support

---

<div align="center">

### Made with ❤️ by [ttasc](https://github.com/ttasc)

**[⬆ Back to top](#-gameforlinux)**

</div>
