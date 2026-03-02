#!/usr/bin/env bash
# DESC: ncurses library (compiled from source to ~/.local)

install_ncurses() {
	info "-- ncurses --"
	local ver="${NCURSES_VERSION:-6.4}"

	# Always export environment variables for subsequent builds
	export PATH="$PREFIX/bin:$PATH"
	export LD_LIBRARY_PATH="$PREFIX/lib:${LD_LIBRARY_PATH:-}"
	export PKG_CONFIG_PATH="$PREFIX/lib/pkgconfig:${PKG_CONFIG_PATH:-}"
	export CPPFLAGS="-I$PREFIX/include"
	export LDFLAGS="-L$PREFIX/lib"

	# Check if ncurses is already properly installed
	if [[ -f "$PREFIX/lib/libncursesw.so" ]] || [[ -f "$PREFIX/lib/libncursesw.a" ]]; then
		if [[ -f "$PREFIX/lib/pkgconfig/ncursesw.pc" ]] && pkg-config --exists ncursesw 2>/dev/null; then
			ok "ncurses already installed in $PREFIX"
			return
		else
			warn "ncurses files found but incomplete, reinstalling..."
		fi
	fi

	info "Compiling ncurses $ver from source to $PREFIX ..."
	local src_dir="$PREFIX/src/ncurses-$ver"
	ensure_dir "$src_dir"
	cd "$src_dir" || return

	local tarball="ncurses-${ver}.tar.gz"
	if [[ ! -f "$tarball" ]]; then
		curl -fSL -o "$tarball" "https://ftp.gnu.org/gnu/ncurses/ncurses-${ver}.tar.gz"
	fi

	tar xf "$tarball" --strip-components=1 2>/dev/null || tar xf "$tarball"

	info "Configuring ncurses..."
	if ! ./configure --prefix="$PREFIX" \
		--with-shared \
		--with-normal \
		--without-debug \
		--without-ada \
		--enable-widec \
		--enable-pc-files \
		--with-pkg-config-libdir="$PREFIX/lib/pkgconfig"; then
		warn "ncurses configuration failed"
		return 1
	fi

	info "Building ncurses (this may take a few minutes)..."
	if ! make -j"$(nproc)"; then
		warn "ncurses build failed"
		return 1
	fi

	info "Installing ncurses..."
	make install
	ok "ncurses installed to $PREFIX"
}

verify_ncurses() {
	# Check if library files exist
	if [[ ! -f "$PREFIX/lib/libncursesw.so" ]] && [[ ! -f "$PREFIX/lib/libncursesw.a" ]]; then
		echo "ncurses library files not found"
		return 1
	fi

	# Check if header files exist
	if [[ ! -f "$PREFIX/include/ncurses.h" ]] && [[ ! -f "$PREFIX/include/ncursesw/ncurses.h" ]]; then
		echo "ncurses header files not found"
		return 1
	fi

	# Check if pkg-config file exists
	if [[ ! -f "$PREFIX/lib/pkgconfig/ncursesw.pc" ]]; then
		echo "ncurses pkg-config file not found"
		return 1
	fi

	# Export PKG_CONFIG_PATH and verify pkg-config can find it
	export PKG_CONFIG_PATH="$PREFIX/lib/pkgconfig:${PKG_CONFIG_PATH:-}"
	if ! pkg-config --exists ncursesw 2>/dev/null; then
		echo "ncurses not detectable via pkg-config"
		return 1
	fi

	echo "ncurses $(pkg-config --modversion ncursesw) installed and verified"
}
