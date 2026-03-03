#!/usr/bin/env bash
# modules/_dotfiles.sh — Symlink config templates from configs to $HOME

link_dotfiles() {
	info "-- dotfiles --"
	local configs_dir="$DOTFILES_DIR/configs"
	[[ -d "$configs_dir" ]] || {
		warn "No configs/ directory found - skipping"
		return
	}

	# Each subdir in configs/ maps to a target:
	#   configs/zsh/.zshrc       to ~/.zshrc
	#   configs/git/.gitconfig   to ~/.gitconfig
	#   configs/ssh/config       to ~/.ssh/config
	#
	# All config files are copied as templates to allow local modifications
	# without affecting the git repo.

	for dir in "$configs_dir"/*/; do
		local category
		category="$(basename "$dir")"

		for src in "$dir".* "$dir"*; do
			[[ -f "$src" ]] || continue

			local filename
			filename="$(basename "$src")"
			local target

			# Determine target path
			case "$category" in
			ssh) target="$HOME/.ssh/$filename" ;;
			*) target="$HOME/$filename" ;;
			esac

			# Copy config files as templates
			if [[ -f "$target" ]] && cmp -s "$src" "$target"; then
				ok "$filename already up to date"
				continue
			fi

			# Backup existing file
			if [[ -e "$target" ]]; then
				local backup
				backup="${target}.backup.$(date +%s)"
				warn "Backing up existing $filename to $backup"
				cp "$target" "$backup"
			fi

			ensure_dir "$(dirname "$target")"
			cp "$src" "$target"
			ok "$filename copied to $target"
		done
	done
}
