#!/usr/bin/env bash
# DESC: Python via uv (Astral)

install_python() {
	info "-- python (uv) --"

	if command_exists uv; then
		ok "uv already installed - $(uv --version)"
	else
		info "Installing uv package manager..."
		curl -LsSf https://astral.sh/uv/install.sh | sh
		export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
		ok "uv installed"
	fi

	info "Installing Python via uv..."
	uv python install
	ok "Python installed - $(uv run python --version 2>&1)"
}

verify_python() { uv --version 2>&1; }
