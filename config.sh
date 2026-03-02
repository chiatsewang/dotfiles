#!/usr/bin/env bash
# ============================================================================
# config.sh — Version pins & preferences
# ============================================================================

# Zsh (from source)
ZSH_VERSION_TAG="5.9.1"

# nvm / Node
NVM_VERSION="v0.40.1"
NODE_VERSION="--lts" # or pin: "22"

# SSH
# Note: ssh-github module will prompt for account name and generate
# keys with format: ~/.ssh/github_<account>_sshkey

# Paths
PREFIX="$HOME/.local"
