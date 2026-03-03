#!/usr/bin/env bash
# modules/_common.sh — Shared helpers (sourced, never run directly)

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'
info() { printf "${CYAN}[INFO]${NC}  %s\n" "$*"; }
ok() { printf "${GREEN}[ OK ]${NC}  %s\n" "$*"; }
warn() { printf "${YELLOW}[WARN]${NC}  %s\n" "$*"; }
fail() {
	printf "${RED}[FAIL]${NC}  %s\n" "$*"
	exit 1
}

command_exists() { command -v "$1" &>/dev/null; }

ensure_dir() { mkdir -p "$@"; }

# Common paths
export PREFIX="${PREFIX:-$HOME/.local}"
export PATH="$PREFIX/bin:$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.npm-global/bin:$HOME/.nvm:$HOME/.claude/bin:$PATH"

ensure_dir "$PREFIX/bin"
