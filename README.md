# Dotfiles

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

| Module       | Tool                       | Method          | Location                          |
|--------------|----------------------------|-----------------|-----------------------------------|
| `ssh-github` | GitHub SSH (Ed25519)       | ssh-keygen      | `~/.ssh/github_<host>_sshkey`     |
| `zsh`        | Zsh                        | From source     | `~/.local/bin/zsh`                |
| `ohmyzsh`    | Oh My Zsh + plugins + p10k | Official script | `~/.oh-my-zsh/`                   |
| `python`     | Python via uv              | Astral          | `~/.local/bin/uv`                 |
| `node`       | Node.js + npm via nvm      | nvm             | `~/.nvm/`                         |
| `claude`     | Claude Code                | Native binary   | `~/.claude/bin/claude`            |
| `aws`        | AWS CLI v2                 | User-local      | `~/.local/bin/aws`                |
| `kubectl`    | Kubernetes CLI             | Binary download | `~/.local/bin/kubectl`            |

## Usage

```bash
bash setup.sh                    # install all defaults
bash setup.sh ssh python node    # install specific modules only
bash setup.sh --list             # show available modules
```

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

## Roadmap

- [ ] Core modules (ssh, zsh, ohmyzsh, python, node, claude)
- [ ] Cloud tooling (aws, kubectl)
- [ ] Config templates (.zshrc, .gitconfig)
- [ ] CI smoke test

## License

MIT
