# gameforlinux Makefile

.POSIX:

help:
	@echo "usage: make [target]"
	@echo ""
	@echo "targets:"
	@echo "  install       - install all games"
	@echo "  install-<g>   - install specific game"
	@echo "  uninstall     - uninstall all games"
	@echo "  uninstall-<g> - uninstall specific game"
	@echo "  build         - build all games locally"
	@echo "  build-<g>     - build specific game locally"
	@echo "  release       - cross-compile all games for release (Linux, macOS, BSD)"
	@echo "  release-<g>   - cross-compile specific game for release"
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

release:
	RELEASE=1 ./builds.sh

release-%:
	RELEASE=1 ./builds.sh $*

test:
	./test.sh

test-%:
	./test.sh $*

clean:
	rm -rf build/ ~/.gameforlinux/
	@echo "clean complete."

readme:
	./readme.sh

.PHONY: help install uninstall build release test clean readme
