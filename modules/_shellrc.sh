#!/usr/bin/env bash
# modules/_shellrc.sh — Append managed PATH block to shell rc files

configure_shell_rc() {
	info "── shell rc ──"

	local MARKER="# ── dotfiles managed block"
	local BLOCK
	read -r -d '' BLOCK <<'RCEOF' || true
# ── dotfiles managed block ───────────────────────────────────────────────
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.npm-global/bin:$HOME/.claude/bin:$PATH"
export LD_LIBRARY_PATH="$HOME/.local/lib:${LD_LIBRARY_PATH:-}"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

# ssh-agent (reuse or start)
if [ -z "${SSH_AUTH_SOCK:-}" ]; then
    eval "$(ssh-agent -s)" >/dev/null 2>&1
fi
# ── end dotfiles ─────────────────────────────────────────────────────────
RCEOF

	for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
		touch "$rc"
		if grep -qF "$MARKER" "$rc"; then
			ok "$(basename "$rc") already configured"
		else
			printf "\n%s\n" "$BLOCK" >>"$rc"
			ok "Appended dotfiles block to $(basename "$rc")"
		fi
	done
}
