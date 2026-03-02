#!/usr/bin/env bash
# DESC: Oh My Zsh + plugins + theme

install_ohmyzsh() {
	info "-- oh-my-zsh --"
	local omz_dir="${ZSH:-$HOME/.oh-my-zsh}"

	if [[ -d "$omz_dir" ]]; then
		ok "Oh My Zsh already installed"
	else
		info "Installing Oh My Zsh ..."
		RUNZSH=no KEEP_ZSHRC=yes \
			sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
		ok "Oh My Zsh installed to $omz_dir"
	fi

	local custom="${ZSH_CUSTOM:-$omz_dir/custom}"

	# -- Plugins --
	declare -A plugins=(
		["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions.git"
		["zsh-syntax-highlighting"]="https://github.com/zsh-users/zsh-syntax-highlighting.git"
		["zsh-completions"]="https://github.com/zsh-users/zsh-completions.git"
	)

	for name in "${!plugins[@]}"; do
		local dest="$custom/plugins/$name"
		if [[ -d "$dest" ]]; then
			ok "Plugin $name already installed"
		else
			info "Installing plugin: $name..."
			git clone --depth=1 "${plugins[$name]}" "$dest"
			ok "Plugin $name installed"
		fi
	done

	# -- Theme: powerlevel10k --
	local p10k_dir="$custom/themes/powerlevel10k"
	if [[ -d "$p10k_dir" ]]; then
		ok "powerlevel10k already installed"
	else
		info "Installing powerlevel10k theme..."
		git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$p10k_dir"
		ok "powerlevel10k installed"
	fi
}

verify_ohmyzsh() {
	[[ -d "${ZSH:-$HOME/.oh-my-zsh}" ]] && echo "installed" || echo "missing"
}
