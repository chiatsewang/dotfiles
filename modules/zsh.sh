#!/usr/bin/env bash
# DESC: Zsh shell (compiled from source to ~/.local)

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

	# Try to configure - if ncurses is missing, skip gracefully
	if ! ./configure --prefix="$PREFIX" --enable-multibyte 2>&1; then
		warn "Zsh configuration failed - likely missing ncurses-devel"
		warn "Skipping zsh installation. You can:"
		warn "  1. Ask admin to install: ncurses-devel (RHEL) or libncurses-dev (Debian)"
		warn "  2. Use system zsh if available"
		warn "Continuing with remaining modules..."
		return
	fi

	if ! make -j"$(nproc)"; then
		warn "Zsh build failed - skipping installation"
		warn "Continuing with remaining modules..."
		return
	fi

	make install
	ok "Zsh installed to $PREFIX/bin/zsh"
}

verify_zsh() { zsh --version 2>&1 | head -1; }
