# @henryraccoon's dotfiles

My personal dotfiles.

## What's included

- **homebrew/** — Brewfile (all packages and apps)
- **zsh/** — shell config (zshrc, zshenv, zprofile, zlogin)
- **git/** — git config, aliases, global ignore
- **tmux/** — tmux config and plugins
- **hammerspoon/** — window management and app shortcuts
- **scripts/** — tmux-sessionizer, tmux-cht
- **claude/** — Claude Code config (agents, skills, docs)
- **starship.toml** — terminal prompt theme

## Setup

Full clean-machine walkthrough: [docs/SETUP.md](docs/SETUP.md).
Upscope dev environment: [docs/UPSCOPE_ENV.md](docs/UPSCOPE_ENV.md).

```bash
git clone https://github.com/henryraccoon/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
brew bundle --file=homebrew/Brewfile
```

Then symlink configs to their expected locations (see docs/SETUP.md).
