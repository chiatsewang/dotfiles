#!/usr/bin/env bash
# DESC: Zsh shell (compiled from source to ~/.local)
# DEPENDS: ncurses

install_zsh() {
	info "-- zsh --"
	local ver="${ZSH_VERSION_TAG:-5.9}"

	if command_exists zsh; then
		ok "Zsh already available - $(zsh --version 2>&1 | head -1)"
		return
	fi

	# Check if system zsh is available
	if [[ -x /bin/zsh ]] || [[ -x /usr/bin/zsh ]]; then
		ok "System zsh found - using existing installation"
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

	# Configure with locally-built ncurses
	export CPPFLAGS="-I$PREFIX/include -I$PREFIX/include/ncursesw"
	export LDFLAGS="-L$PREFIX/lib"
	export PKG_CONFIG_PATH="$PREFIX/lib/pkgconfig:$PKG_CONFIG_PATH"

	if ! ./configure --prefix="$PREFIX" --enable-multibyte >/dev/null 2>&1; then
		warn "Zsh configuration failed - check ncurses installation"
		warn "Skipping zsh installation"
		return
	fi

	if ! make -j"$(nproc)" >/dev/null 2>&1; then
		warn "Zsh build failed - skipping installation"
		return
	fi

	make install >/dev/null 2>&1
	ok "Zsh installed to $PREFIX/bin/zsh"
}

verify_zsh() { zsh --version 2>&1 | head -1; }
