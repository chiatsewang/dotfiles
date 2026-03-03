#!/usr/bin/env bash
# modules/_shellrc.sh — Append managed PATH block to shell rc files

configure_shell_rc() {
	info "── shell rc ──"

	local MARKER="# ── dotfiles managed block"
	local BLOCK
	read -r -d '' BLOCK <<'RCEOF' || true
# ── dotfiles managed block ───────────────────────────────────────────────
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.claude/bin:$PATH"
export LD_LIBRARY_PATH="$HOME/.local/lib:${LD_LIBRARY_PATH:-}"

# nvm (temporarily unset PREFIX to avoid conflicts)
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
    _SAVED_PREFIX="$PREFIX"
    unset PREFIX
    source "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
    export PREFIX="$_SAVED_PREFIX"
fi

# ssh-agent (reuse or start)
if [ -z "${SSH_AUTH_SOCK:-}" ]; then
    eval "$(ssh-agent -s)" >/dev/null 2>&1
fi
# ── end dotfiles ─────────────────────────────────────────────────────────
RCEOF

	local BASH_ZSH_BLOCK
	read -r -d '' BASH_ZSH_BLOCK <<'BASHEOF' || true
# ── dotfiles managed block ───────────────────────────────────────────────
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.claude/bin:$PATH"
export LD_LIBRARY_PATH="$HOME/.local/lib:${LD_LIBRARY_PATH:-}"

# nvm (temporarily unset PREFIX to avoid conflicts)
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
    _SAVED_PREFIX="$PREFIX"
    unset PREFIX
    source "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
    export PREFIX="$_SAVED_PREFIX"
fi

# ssh-agent (reuse or start)
if [ -z "${SSH_AUTH_SOCK:-}" ]; then
    eval "$(ssh-agent -s)" >/dev/null 2>&1
fi

# Auto-switch to zsh if available and not already in zsh
if [ -n "$BASH_VERSION" ] && command -v zsh >/dev/null 2>&1 && [ -z "$ZSH_VERSION" ]; then
    zsh
fi
# ── end dotfiles ─────────────────────────────────────────────────────────
BASHEOF

	# Configure .bashrc
	if [ -f "$HOME/.bashrc" ]; then
		touch "$HOME/.bashrc"
		if grep -qF "$MARKER" "$HOME/.bashrc"; then
			ok ".bashrc already configured"
		else
			printf "\n%s\n" "$BASH_ZSH_BLOCK" >>"$HOME/.bashrc"
			ok "Appended dotfiles block to .bashrc (with zsh auto-switch)"
		fi
	fi

	# Configure .zshrc
	if [ -f "$HOME/.zshrc" ] || command -v zsh >/dev/null 2>&1; then
		touch "$HOME/.zshrc"
		if grep -qF "$MARKER" "$HOME/.zshrc"; then
			ok ".zshrc already configured"
		else
			printf "\n%s\n" "$BLOCK" >>"$HOME/.zshrc"
			ok "Appended dotfiles block to .zshrc"
		fi
	fi
}
