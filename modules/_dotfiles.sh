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
	# Files starting with _ are treated as templates - copied, not linked.

	for dir in "$configs_dir"/*/; do
		local category="$(basename "$dir")"

		for src in "$dir".* "$dir"*; do
			[[ -f "$src" ]] || continue

			local filename="$(basename "$src")"
			local target

			# Determine target path
			case "$category" in
			ssh) target="$HOME/.ssh/$filename" ;;
			*) target="$HOME/$filename" ;;
			esac

			# Skip if target is already correct symlink
			if [[ -L "$target" && "$(readlink -f "$target")" == "$(readlink -f "$src")" ]]; then
				ok "$filename already linked"
				continue
			fi

			# Backup existing file
			if [[ -e "$target" && ! -L "$target" ]]; then
				local backup="${target}.backup.$(date +%s)"
				warn "Backing up existing $filename to $backup"
				mv "$target" "$backup"
			fi

			ensure_dir "$(dirname "$target")"
			ln -sf "$(readlink -f "$src")" "$target"
			ok "$filename to $target"
		done
	done
}
