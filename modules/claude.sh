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

	if command_exists claude; then
		ok "Claude Code installed"
	else
		warn "Restart shell to use claude"
	fi
}

verify_claude() { claude --version 2>/dev/null || echo "installed"; }
