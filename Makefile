# GameForLinux Makefile
# A collection of Terminal UI games for Linux

.PHONY: help
help: ## Show this help message
	@echo "GameForLinux - Terminal UI Games for Linux"
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@echo "Installation:"
	@grep -E '^\s*\.PHONY.*install' Makefile | sed 's/.PHONY: //' | awk '{print "  make " $$1}'
	@echo ""
	@echo "Other targets:"
	@grep -E '^\s*\.PHONY' Makefile | grep -v install | sed 's/.PHONY: //' | awk '{print "  make " $$1}'

# ==================== INSTALLATION ====================

.PHONY: install
install: install-sudokute install-termines install-gotermoku verify ## Install all games
	@echo ""
	@echo "✅ All games installed successfully!"
	@echo "Type game names to play: sudokute, termines, gotermoku"

.PHONY: install-sudokute
install-sudokute: ## Install Sudokute
	@echo "📥 Installing Sudokute..."
	@mkdir -p ~/.gameforlinux
	@bash scripts/download-games.sh sudokute ~/.gameforlinux/
	@chmod +x ~/.gameforlinux/sudokute
	@if [ ! -L /usr/local/bin/sudokute ]; then sudo ln -sf ~/.gameforlinux/sudokute /usr/local/bin/sudokute; fi
	@echo "✓ Sudokute installed"

.PHONY: install-termines
install-termines: ## Install Termines
	@echo "📥 Installing Termines..."
	@mkdir -p ~/.gameforlinux
	@bash scripts/download-games.sh termines ~/.gameforlinux/
	@chmod +x ~/.gameforlinux/termines
	@if [ ! -L /usr/local/bin/termines ]; then sudo ln -sf ~/.gameforlinux/termines /usr/local/bin/termines; fi
	@echo "✓ Termines installed"

.PHONY: install-gotermoku
install-gotermoku: ## Install Gotermoku
	@echo "📥 Installing Gotermoku..."
	@mkdir -p ~/.gameforlinux
	@bash scripts/download-games.sh gotermoku ~/.gameforlinux/
	@chmod +x ~/.gameforlinux/gotermoku
	@if [ ! -L /usr/local/bin/gotermoku ]; then sudo ln -sf ~/.gameforlinux/gotermoku /usr/local/bin/gotermoku; fi
	@echo "✓ Gotermoku installed"

# ==================== UNINSTALLATION ====================

.PHONY: uninstall
uninstall: uninstall-sudokute uninstall-termines uninstall-gotermoku ## Uninstall all games
	@echo "Cleaning up..."
	@rm -rf ~/.gameforlinux
	@echo "✅ All games uninstalled"

.PHONY: uninstall-sudokute
uninstall-sudokute: ## Uninstall Sudokute
	@sudo rm -f /usr/local/bin/sudokute
	@rm -f ~/.gameforlinux/sudokute
	@echo "✓ Sudokute removed"

.PHONY: uninstall-termines
uninstall-termines: ## Uninstall Termines
	@sudo rm -f /usr/local/bin/termines
	@rm -f ~/.gameforlinux/termines
	@echo "✓ Termines removed"

.PHONY: uninstall-gotermoku
uninstall-gotermoku: ## Uninstall Gotermoku
	@sudo rm -f /usr/local/bin/gotermoku
	@rm -f ~/.gameforlinux/gotermoku
	@echo "✓ Gotermoku removed"

# ==================== MANAGEMENT ====================

.PHONY: verify
verify: ## Verify installation status
	@echo "🔍 Checking game installations..."
	@bash scripts/test.sh

.PHONY: update
update: uninstall install ## Update all games to latest versions
	@echo "✅ All games updated!"

# ==================== DEVELOPMENT ====================

.PHONY: build-all
build-all: ## Build all games from source (requires Go)
	@echo "🔨 Building games from source..."
	@bash scripts/build-games.sh

.PHONY: build-sudokute
build-sudokute: ## Build Sudokute from source
	@bash scripts/build-games.sh sudokute

.PHONY: build-termines
build-termines: ## Build Termines from source
	@bash scripts/build-games.sh termines

.PHONY: build-gotermoku
build-gotermoku: ## Build Gotermoku from source
	@bash scripts/build-games.sh gotermoku

.PHONY: install-local
install-local: build-all ## Build and install games locally
	@echo "📥 Installing from local builds..."
	@mkdir -p ~/.gameforlinux
	@cp build/sudokute ~/.gameforlinux/ 2>/dev/null || echo "⚠ Sudokute build not found"
	@cp build/termines ~/.gameforlinux/ 2>/dev/null || echo "⚠ Termines build not found"
	@cp build/gotermoku ~/.gameforlinux/ 2>/dev/null || echo "⚠ Gotermoku build not found"
	@chmod +x ~/.gameforlinux/*
	@sudo ln -sf ~/.gameforlinux/* /usr/local/bin/ 2>/dev/null
	@echo "✅ Local builds installed!"

.PHONY: clean
clean: ## Clean build artifacts and cache
	@rm -rf build/ dist/ .cache/
	@echo "✓ Cleaned"

# ==================== UTILITY ====================

.PHONY: show-paths
show-paths: ## Show where games are installed
	@echo "📍 Game Installation Paths:"
	@echo "Local cache: ~/.gameforlinux/"
	@echo "System links: /usr/local/bin/"
	@which sudokute && echo "✓ sudokute found" || echo "✗ sudokute not found"
	@which termines && echo "✓ termines found" || echo "✗ termines not found"
	@which gotermoku && echo "✓ gotermoku found" || echo "✗ gotermoku not found"

.PHONY: version
version: ## Show installed game versions
	@echo "📦 Game Versions:"
	@sudokute --version 2>/dev/null || echo "Sudokute: not installed"
	@termines --version 2>/dev/null || echo "Termines: not installed"
	@gotermoku --version 2>/dev/null || echo "Gotermoku: not installed"

# Default target
.DEFAULT_GOAL := help
