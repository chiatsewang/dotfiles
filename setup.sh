#!/usr/bin/env bash
# ============================================================================
# setup.sh — Modular dev environment bootstrap (no sudo)
#
# Usage:
#   bash <(curl -fsSL https://raw.githubusercontent.com/chiatsewang/dotfiles/main/setup.sh)
#
#   # Or after cloning:
#   bash setup.sh                    # install everything
#   bash setup.sh ssh zsh python     # install specific modules
#   bash setup.sh --list             # show available modules
#   bash setup.sh --version          # show version
# ============================================================================
set -euo pipefail

VERSION="1.0.0"

# ── Resolve repo root (works both via curl pipe and local clone) ─────────
if [[ -f "$(dirname "${BASH_SOURCE[0]:-}")/modules/ssh-github.sh" ]]; then
	DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
else
	# Running via curl — clone first
	DOTFILES_DIR="$HOME/.dotfiles"
	if [[ -d "$DOTFILES_DIR/.git" ]]; then
		git -C "$DOTFILES_DIR" pull --ff-only 2>/dev/null || true
	else
		echo "[INFO]  Cloning dotfiles to $DOTFILES_DIR ..."
		git clone "https://github.com/chiatsewang/dotfiles.git" "$DOTFILES_DIR" 2>/dev/null ||
			git clone "git@github.com:chiatsewang/dotfiles.git" "$DOTFILES_DIR"
	fi
	exec bash "$DOTFILES_DIR/setup.sh" "$@"
fi

# ── Helpers ──────────────────────────────────────────────────────────────────
source "$DOTFILES_DIR/modules/_common.sh"

# ── Config ───────────────────────────────────────────────────────────────────
CONFIG_FILE="$DOTFILES_DIR/config.sh"
# shellcheck disable=SC1090
[[ -f "$CONFIG_FILE" ]] && source "$CONFIG_FILE"

# ── Module discovery ─────────────────────────────────────────────────────────
ALL_MODULES=()
for f in "$DOTFILES_DIR/modules/"*.sh; do
	name="$(basename "$f" .sh)"
	[[ "$name" == _* ]] && continue # skip _common.sh etc
	ALL_MODULES+=("$name")
done

# Default install order (dependencies matter)
# Note: ssh-github is interactive, so it's not in the default list
# Run manually: bash setup.sh ssh-github
DEFAULT_ORDER=(ncurses zsh ohmyzsh python node claude aws kubectl)

list_modules() {
	echo ""
	echo "Available modules:"
	for mod in "${ALL_MODULES[@]}"; do
		local desc=""
		desc=$(grep '^# DESC:' "$DOTFILES_DIR/modules/${mod}.sh" 2>/dev/null | sed 's/^# DESC: //')
		printf "  %-12s %s\n" "$mod" "$desc"
	done
	echo ""
	echo "Usage: bash setup.sh [module ...]"
	echo "       bash setup.sh              # install all defaults"
}

# ── Parse args ───────────────────────────────────────────────────────────────
if [[ "${1:-}" == "--version" || "${1:-}" == "-v" ]]; then
	echo "dotfiles v$VERSION"
	exit 0
fi

if [[ "${1:-}" == "--list" || "${1:-}" == "-l" ]]; then
	list_modules
	exit 0
fi

if [[ $# -gt 0 ]]; then
	MODULES=("$@")
else
	MODULES=("${DEFAULT_ORDER[@]}")
fi

# ── Banner ───────────────────────────────────────────────────────────────────
echo ""
echo "  ╔═══════════════════════════════════════════╗"
echo "  ║  dotfiles - dev environment setup         ║"
echo "  ║  No sudo required                         ║"
echo "  ╚═══════════════════════════════════════════╝"
echo ""
info "Modules to install: ${MODULES[*]}"
echo ""

# ── Run modules ──────────────────────────────────────────────────────────────
for mod in "${MODULES[@]}"; do
	mod_file="$DOTFILES_DIR/modules/${mod}.sh"
	if [[ ! -f "$mod_file" ]]; then
		warn "Module '$mod' not found — skipping"
		continue
	fi
	# shellcheck disable=SC1090
	source "$mod_file"
	# Replace hyphens with underscores for function names
	mod_func="${mod//-/_}"
	"install_${mod_func}"
done

# ── Dotfiles / configs ──────────────────────────────────────────────────────
source "$DOTFILES_DIR/modules/_dotfiles.sh"
link_dotfiles

# ── Shell RC ─────────────────────────────────────────────────────────────────
source "$DOTFILES_DIR/modules/_shellrc.sh"
configure_shell_rc

# ── Summary ──────────────────────────────────────────────────────────────────
echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║               dotfiles setup complete                        ║"
echo "╠══════════════════════════════════════════════════════════════╣"

for mod in "${MODULES[@]}"; do
	# Replace hyphens with underscores for function names
	mod_func="${mod//-/_}"
	verify_fn="verify_${mod_func}"
	if declare -f "$verify_fn" &>/dev/null; then
		local_result=$($verify_fn 2>&1 || echo "-")
		printf "║  %-12s - %-44s ║\n" "$mod" "$local_result"
	fi
done

echo "╠══════════════════════════════════════════════════════════════╣"
echo "║  source ~/.zshrc  (or restart shell)                         ║"
echo "║  claude            (to authenticate)                         ║"
echo "╚══════════════════════════════════════════════════════════════╝"
