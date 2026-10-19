# @henryraccoon's dotfiles

## What's included

- **install.sh** — one-shot, idempotent bootstrap (brew bundle, symlinks, node, tmux, Claude Code, iTerm2)
- **homebrew/** — Brewfile (CLI tools, GUI apps, font, VS Code extensions)
- **zsh/** — shell config (zshrc, zshenv, zprofile)
- **git/** — git config, aliases, global ignore
- **tmux/** — tmux config (plugins via tpm)
- **hammerspoon/** — window management and app shortcuts
- **vscode/** — settings + keybindings
- **iterm2/** — iTerm2 preferences (loaded from this folder)
- **claude/** — Claude Code config (settings, CLAUDE.md, agents, skills, docs, commands)
- **scripts/** — on `$PATH`: `tmux-sessionizer`, `tmux-cht`, `migrate-export`, `migrate-import`
- **starship.toml** — prompt theme

## New machine

```bash
xcode-select --install
git clone https://github.com/henryraccoon/dotfiles.git ~/.dotfiles
~/.dotfiles/install.sh
```

Full runbook incl. secrets transfer: [docs/SETUP.md](docs/SETUP.md).
Upscope dev environment: [docs/UPSCOPE_ENV.md](docs/UPSCOPE_ENV.md).
