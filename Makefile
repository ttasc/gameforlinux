# gameforlinux Makefile

.POSIX:

help:
	@echo "usage: make [target]"
	@echo ""
	@echo "targets:"
	@echo "  install       - install all games in games.list"
	@echo "  install-<g>   - install specific game (e.g. make install-sudokute)"
	@echo "  uninstall     - uninstall all games"
	@echo "  uninstall-<g> - uninstall specific game"
	@echo "  build         - build all games from source"
	@echo "  build-<g>     - build specific game"
	@echo "  test          - verify installations"
	@echo "  test-<g>      - verify specific game"
	@echo "  clean         - remove build artifacts"

install:
	./install.sh

install-%:
	./install.sh $*

uninstall:
	./uninstall.sh

uninstall-%:
	./uninstall.sh $*

build:
	./builds.sh

build-%:
	./builds.sh $*

test:
	./test.sh

test-%:
	./test.sh $*

clean:
	rm -rf build/ ~/.gameforlinux/
	@echo "clean complete."

.PHONY: help install uninstall build test clean
