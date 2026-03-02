#!/usr/bin/env bash
# DESC: Claude Code (native binary)

install_claude() {
	info "── claude code ──"

	if command_exists claude; then
		ok "Claude Code already installed — $(claude --version 2>/dev/null || echo 'present')"
		return
	fi

	curl -fsSL https://claude.ai/install.sh | bash
	export PATH="$HOME/.claude/bin:$HOME/.local/bin:$PATH"

	command_exists claude && ok "Claude Code installed" || warn "Restart shell to use claude"
}

verify_claude() { claude --version 2>/dev/null || echo "installed"; }
