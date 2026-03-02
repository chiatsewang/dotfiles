# ============================================================================
# .zshrc — managed by dotfiles (edit in dotfiles/configs/zsh/.zshrc)
# ============================================================================

# ── Oh My Zsh ────────────────────────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
    git
    docker
    kubectl
    aws
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-completions
)

source "$ZSH/oh-my-zsh.sh"

# ── Powerlevel10k instant prompt (keep near top) ────────────────────────────
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# ── Paths ────────────────────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.npm-global/bin:$HOME/.claude/bin:$PATH"
export LD_LIBRARY_PATH="$HOME/.local/lib:${LD_LIBRARY_PATH:-}"

# ── nvm ──────────────────────────────────────────────────────────────────────
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

# ── ssh-agent ────────────────────────────────────────────────────────────────
if [ -z "${SSH_AUTH_SOCK:-}" ]; then
    eval "$(ssh-agent -s)" >/dev/null 2>&1
fi

# ── Aliases ──────────────────────────────────────────────────────────────────
# alias k="kubectl"

# ── Custom ───────────────────────────────────────────────────────────────────
# Add your overrides below or in ~/.zshrc.local
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
