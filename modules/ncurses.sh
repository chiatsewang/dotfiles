#!/usr/bin/env bash
# DESC: ncurses library (compiled from source to ~/.local)

install_ncurses() {
	info "-- ncurses --"
	local ver="${NCURSES_VERSION:-6.4}"

	# Check if ncurses is already built
	if [[ -f "$PREFIX/lib/libncursesw.so" ]] || [[ -f "$PREFIX/lib/libncursesw.a" ]]; then
		ok "ncurses already installed in $PREFIX"
		return
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

	if ! ./configure --prefix="$PREFIX" \
		--with-shared \
		--with-normal \
		--without-debug \
		--without-ada \
		--enable-widec \
		--enable-pc-files \
		--with-pkg-config-libdir="$PREFIX/lib/pkgconfig" >/dev/null 2>&1; then
		warn "ncurses configuration failed"
		return 1
	fi

	if ! make -j"$(nproc)" >/dev/null 2>&1; then
		warn "ncurses build failed"
		return 1
	fi

	make install >/dev/null 2>&1
	ok "ncurses installed to $PREFIX"
}

verify_ncurses() {
	[[ -f "$PREFIX/lib/libncursesw.so" ]] || [[ -f "$PREFIX/lib/libncursesw.a" ]] && echo "ncurses installed"
}
