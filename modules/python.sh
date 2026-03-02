#!/usr/bin/env bash
# DESC: Python via uv (Astral)

install_python() {
	info "-- python (uv) --"

	if command_exists uv; then
		ok "uv already installed - $(uv --version)"
	else
		curl -LsSf https://astral.sh/uv/install.sh | sh
		export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
	fi

	uv python install
	ok "Python to $(uv run python --version 2>&1)"
}

verify_python() { uv --version 2>&1; }
