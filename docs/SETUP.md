# Clean machine setup

Steps to bootstrap a new Mac with these dotfiles, in order.

## 1. Prerequisites

```bash
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## 2. Clone and install packages

```bash
git clone https://github.com/henryraccoon/dotfiles.git ~/.dotfiles
brew bundle --file=~/.dotfiles/homebrew/Brewfile
```

The Brewfile installs all CLI tools (zplug, starship, lsd, fzf, zoxide, tmux, neovim, terminal-notifier, ...), GUI apps (iTerm2, Docker Desktop, 1Password, Hammerspoon, ...) and VS Code extensions.

## 3. Symlink configs

```bash
# zsh
ln -s ~/.dotfiles/zsh/zshrc ~/.zshrc
ln -s ~/.dotfiles/zsh/zshenv ~/.zshenv
ln -s ~/.dotfiles/zsh/zprofile ~/.zprofile
ln -s ~/.dotfiles/zsh/zlogin ~/.zlogin

# git
ln -s ~/.dotfiles/git/gitconfig ~/.gitconfig
ln -s ~/.dotfiles/git/gitmessage ~/.gitmessage
ln -s ~/.dotfiles/git/global_ignore ~/.global_ignore

# starship + tmux
mkdir -p ~/.config
ln -s ~/.dotfiles/starship.toml ~/.config/starship.toml
ln -s ~/.dotfiles/tmux ~/.config/tmux

# hammerspoon
ln -s ~/.dotfiles/hammerspoon ~/.hammerspoon

# claude code
mkdir -p ~/.claude
ln -s ~/.dotfiles/claude/settings.json ~/.claude/settings.json
ln -s ~/.dotfiles/claude/CLAUDE.md ~/.claude/CLAUDE.md
ln -s ~/.dotfiles/claude/agents ~/.claude/agents
ln -s ~/.dotfiles/claude/skills ~/.claude/skills
ln -s ~/.dotfiles/claude/docs ~/.claude/docs
ln -s ~/.dotfiles/claude/commands ~/.claude/commands
```

`~/.dotfiles/scripts` (tmux-sessionizer, tmux-cht) is already on `$PATH` via zshenv — no linking needed.

## 4. Node (nvm)

nvm is installed via the official script, not Homebrew:

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
nvm install --lts
```

zshrc auto-switches node versions from `.nvmrc` files on `cd`.

## 5. First shell

Open a new terminal. zplug will prompt to install missing plugins (zsh-autosuggestions) — answer `y`.

## 6. tmux plugins

```bash
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
```

Then inside tmux press `prefix + I` to install the plugins from tmux.conf.

## 7. Upscope dev environment

See [UPSCOPE_ENV.md](UPSCOPE_ENV.md).

## Not covered by this repo

- **nvim config** — lives outside this repo. NOTE: `~/.config/nvim` currently points to `~/dotfiles/nvim` which does not exist; restore it from wherever the old nvim config lives.
- **git identity** — `git/gitconfig` sets the personal email globally. For work repos set it per repo: `git config user.email <work email>`.
- **SSH keys, GPG, 1Password data** — restore manually.
