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

	# Local ncurses if system one missing
	if ! pkg-config --exists ncursesw 2>/dev/null && [[ ! -d "$PREFIX/include/ncursesw" ]]; then
		warn "Building local ncurses ..."
		local nc_dir="$PREFIX/src/ncurses-6.5"
		ensure_dir "$nc_dir" && cd "$nc_dir" || return
		curl -fSL -o nc.tar.gz "https://ftp.gnu.org/pub/gnu/ncurses/ncurses-6.5.tar.gz"
		tar xzf nc.tar.gz --strip-components=1
		./configure --prefix="$PREFIX" --with-shared --enable-widec --without-debug
		make -j"$(nproc)" && make install
		cd "$src_dir" || return
	fi

	export CFLAGS="-I$PREFIX/include" LDFLAGS="-L$PREFIX/lib"
	export PKG_CONFIG_PATH="$PREFIX/lib/pkgconfig:${PKG_CONFIG_PATH:-}"
	./configure --prefix="$PREFIX" --enable-multibyte
	make -j"$(nproc)" && make install

	ok "Zsh to $PREFIX/bin/zsh"
}

verify_zsh() { zsh --version 2>&1 | head -1; }
