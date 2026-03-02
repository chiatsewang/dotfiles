#!/usr/bin/env bash
# DESC: Node.js + npm via nvm

install_node() {
	info "── node (nvm) ──"
	export NVM_DIR="$HOME/.nvm"
	local nvm_ver="${NVM_VERSION:-v0.40.1}"
	local node_ver="${NODE_VERSION:---lts}"

	if [[ -s "$NVM_DIR/nvm.sh" ]]; then
		ok "nvm already installed"
	else
		curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${nvm_ver}/install.sh" | bash
	fi

	# shellcheck disable=SC1091
	source "$NVM_DIR/nvm.sh"

	if command_exists node; then
		ok "Node already installed — $(node --version)"
	else
		nvm install $node_ver
		nvm alias default node
	fi

	ok "Node $(node --version) / npm $(npm --version)"

	# User-local global prefix
	local npm_global="$HOME/.npm-global"
	ensure_dir "$npm_global"
	npm config set prefix "$npm_global"
	export PATH="$npm_global/bin:$PATH"
}

verify_node() { node --version 2>&1; }
