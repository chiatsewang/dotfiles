#!/usr/bin/env bash
# DESC: Zsh shell (compiled from source to ~/.local)

install_zsh() {
	info "-- zsh --"
	local ver="${ZSH_VERSION_TAG:-5.9.1}"

	if command_exists zsh; then
		ok "Zsh already available - $(zsh --version 2>&1 | head -1)"
		return
	fi

	info "Compiling Zsh $ver from source to $PREFIX ..."
	local src_dir="$PREFIX/src/zsh-$ver"
	ensure_dir "$src_dir"
	cd "$src_dir" || return

	local tarball="zsh-${ver}.tar.xz"
	if [[ ! -f "$tarball" ]]; then
		# Try official zsh.org mirror first, fallback to SourceForge
		curl -fSL -o "$tarball" "https://www.zsh.org/pub/zsh-${ver}.tar.xz" ||
			curl -fSL -o "$tarball" "https://downloads.sourceforge.net/project/zsh/zsh/${ver}/${tarball}"
	fi

	tar xf "$tarball" --strip-components=1 2>/dev/null || tar xf "$tarball"

	# Use system ncurses - don't build local version to avoid conflicts
	./configure --prefix="$PREFIX" --enable-multibyte

	if ! make -j"$(nproc)"; then
		fail "Zsh build failed. You may need to install ncurses-devel:
  On RHEL/CentOS: sudo yum install ncurses-devel
  On Debian/Ubuntu: sudo apt install libncurses-dev
  On macOS: brew install ncurses"
	fi

	make install
	ok "Zsh installed to $PREFIX/bin/zsh"
}

verify_zsh() { zsh --version 2>&1 | head -1; }
