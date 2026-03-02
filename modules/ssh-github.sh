#!/usr/bin/env bash
# DESC: GitHub SSH key (Ed25519)

install_ssh_github() {
	info "-- ssh-github --"

	# Prompt for GitHub account name
	read -rp "GitHub account name (e.g., personal, work): " account_name
	if [[ -z "$account_name" ]]; then
		warn "Account name is required"
		return 1
	fi

	local key="$HOME/.ssh/github_${account_name}_sshkey"

	ensure_dir "$HOME/.ssh"
	chmod 700 "$HOME/.ssh"

	if [[ -f "$key" ]]; then
		ok "SSH key already exists at $key"
	else
		info "Generating SSH key..."
		local default_email
		default_email="$(whoami)@$(hostname)"
		read -rp "Email for key [$default_email]: " email
		email="${email:-$default_email}"
		ssh-keygen -t ed25519 -C "$email" -f "$key" -N ""
		ok "SSH key generated at $key"
	fi

	# ssh-agent
	info "Adding key to ssh-agent..."
	if ! ssh-add -l &>/dev/null 2>&1; then
		eval "$(ssh-agent -s)" >/dev/null
	fi
	ssh-add "$key" 2>/dev/null || true

	# ~/.ssh/config
	info "Configuring SSH config..."
	local cfg="$HOME/.ssh/config"
	local host_alias="github.com-${account_name}"

	if ! grep -q "Host ${host_alias}" "$cfg" 2>/dev/null; then
		cat >>"$cfg" <<EOF

Host ${host_alias}
    HostName github.com
    User git
    IdentityFile $key
    IdentitiesOnly yes
    AddKeysToAgent yes
EOF
		chmod 600 "$cfg"
		ok "SSH config entry ${host_alias} added"
	else
		ok "SSH config entry ${host_alias} already exists"
		# If config exists, assume key is already set up
		return
	fi

	echo ""
	echo "  ┌──────────────────────────────────────────────────────────┐"
	echo "  │ Add this key to GitHub: https://github.com/settings/ssh/new"
	echo "  └──────────────────────────────────────────────────────────┘"
	cat "${key}.pub"
	echo ""
	echo "  Usage: git clone git@${host_alias}:username/repo.git"
	echo ""
	read -rp "  Press Enter after adding to GitHub (or 's' to skip) ..." choice
	if [[ "${choice,,}" != "s" ]]; then
		ssh -T "git@${host_alias}" 2>&1 | head -3 || true
	fi
}

verify_ssh_github() {
	# Check if any github_*_sshkey files exist
	local keys
	# shellcheck disable=SC2206
	keys=($HOME/.ssh/github_*_sshkey)
	[[ -f "${keys[0]}" ]] && echo "key(s) present" || echo "missing"
}
