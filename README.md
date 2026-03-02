# Dotfiles

> Version 1.0.0

Modular, no-sudo dev environment bootstrap. One command, new server ready.

## Quick Start

```bash
# From a fresh server
bash <(curl -fsSL https://raw.githubusercontent.com/chiatsewang/dotfiles/main/setup.sh)

# Or clone and run
git clone https://github.com/chiatsewang/dotfiles.git ~/.dotfiles
bash ~/.dotfiles/setup.sh
```

## What It Installs

| Module       | Tool                       | Method          | Location                            |
|--------------|----------------------------|-----------------|-------------------------------------|
| `ssh-github` | GitHub SSH (Ed25519)       | ssh-keygen      | `~/.ssh/github_<account>_sshkey`    |
| `zsh`        | Zsh                        | From source     | `~/.local/bin/zsh`                  |
| `ohmyzsh`    | Oh My Zsh + plugins + p10k | Official script | `~/.oh-my-zsh/`                     |
| `python`     | Python via uv              | Astral          | `~/.local/bin/uv`                   |
| `node`       | Node.js + npm via nvm      | nvm             | `~/.nvm/`                           |
| `claude`     | Claude Code                | Native binary   | `~/.claude/bin/claude`              |
| `aws`        | AWS CLI v2                 | User-local      | `~/.local/bin/aws`                  |
| `kubectl`    | Kubernetes CLI             | Binary download | `~/.local/bin/kubectl`              |

## Usage

```bash
bash setup.sh                         # install all defaults (zsh, ohmyzsh, python, node, claude, aws, kubectl)
bash setup.sh ssh-github              # setup GitHub SSH key (interactive)
bash setup.sh zsh python node         # install specific modules only
bash setup.sh --list                  # show available modules
bash setup.sh --version               # show version
```

**Note:** The `ssh-github` module is interactive and not included in default setup. Run it separately when needed.

## Repo Structure

```text
dotfiles/
├── setup.sh              # entry point (curl-friendly, idempotent)
├── config.sh             # version pins (zsh, nvm, node, etc.)
├── modules/
│   ├── _common.sh        # shared helpers
│   ├── _dotfiles.sh      # symlink configs to $HOME
│   ├── _shellrc.sh       # managed PATH block in rc files
│   ├── ssh.sh
│   ├── zsh.sh
│   ├── ohmyzsh.sh
│   ├── python.sh
│   ├── node.sh
│   ├── claude.sh
│   ├── aws.sh
│   └── kubectl.sh
└── configs/              # dotfile templates (symlinked to $HOME)
    ├── zsh/.zshrc
    └── git/.gitconfig
```

## Design

**No sudo required.** Everything installs under `$HOME` (`~/.local`, `~/.nvm`, `~/.cargo`, etc.).

**Modular.** Each tool is a self-contained `modules/<name>.sh` with `install_<name>()` and `verify_<name>()`. Adding a new tool means adding one file.

**Idempotent.** Safe to re-run — each module skips if already installed.

**Config templates.** Files in `configs/` are symlinked to `$HOME`. Machine-specific overrides go in `~/.zshrc.local`, `~/.gitconfig.local`, etc.

## Development

### Pre-commit Hooks

This repo uses [pre-commit](https://pre-commit.com/) to automatically check formatting before commits.

**Install pre-commit:**

```bash
# Using pip
pip install pre-commit

# Using homebrew (macOS)
brew install pre-commit
```

**Setup hooks:**

```bash
cd ~/.dotfiles
pre-commit install
```

**Run manually:**

```bash
# Check all files
pre-commit run --all-files

# Check specific files
pre-commit run --files setup.sh modules/*.sh
```

The hooks will automatically:

- Format shell scripts with `shfmt`
- Check shell scripts with `shellcheck`
- Fix trailing whitespace
- Check YAML syntax

## Roadmap

- [x] Core modules (ssh-github, zsh, ohmyzsh, python, node, claude)
- [x] Cloud tooling (aws, kubectl)
- [x] Config templates (.zshrc)
- [x] Pre-commit hooks (shfmt, shellcheck)
- [ ] CI smoke test

## License

MIT
