# shellcheck shell=bash
# ============================================================================
# config.sh — Version pins & preferences (sourced by setup.sh)
# ============================================================================

# Zsh (from source)
export ZSH_VERSION_TAG="5.9"

# nvm / Node
export NVM_VERSION="v0.40.1"
export NODE_VERSION="--lts" # or pin: "22"

# SSH
# Note: ssh-github module will prompt for account name and generate
# keys with format: ~/.ssh/github_<account>_sshkey

# Paths
export PREFIX="$HOME/.local"
