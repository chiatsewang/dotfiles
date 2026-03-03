#!/usr/bin/env bash
# DESC: AWS CLI v2 (user-local install)

install_aws() {
	info "-- aws cli --"

	if command_exists aws; then
		ok "AWS CLI already installed - $(aws --version 2>&1 | awk '{print $1}')"
		return
	fi

	local tmp_dir
	tmp_dir="$(mktemp -d)"
	cd "$tmp_dir" || return

	info "Downloading AWS CLI v2..."
	curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip

	info "Extracting AWS CLI..."
	unzip -q awscliv2.zip

	info "Installing AWS CLI to $PREFIX..."
	./aws/install --install-dir "$PREFIX/aws-cli" --bin-dir "$PREFIX/bin" --update

	rm -rf "$tmp_dir"
	ok "AWS CLI installed - $(aws --version 2>&1 | awk '{print $1}')"
}

verify_aws() { aws --version 2>&1 | awk '{print $1}'; }
