#!/usr/bin/env bash
# DESC: kubectl (user-local binary)

install_kubectl() {
	info "-- kubectl --"

	if command_exists kubectl; then
		ok "kubectl already installed - $(kubectl version --client --short 2>/dev/null || kubectl version --client 2>&1 | head -1)"
		return
	fi

	info "Fetching latest kubectl version..."
	local version
	version="$(curl -fsSL https://dl.k8s.io/release/stable.txt)"

	info "Downloading kubectl $version..."
	curl -fsSL "https://dl.k8s.io/release/${version}/bin/linux/amd64/kubectl" -o "$PREFIX/bin/kubectl"
	chmod +x "$PREFIX/bin/kubectl"

	ok "kubectl installed - $(kubectl version --client --short 2>/dev/null || kubectl version --client 2>&1 | head -1)"
}

verify_kubectl() { kubectl version --client --short 2>/dev/null || echo "installed"; }
