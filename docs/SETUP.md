# Clean machine setup

Ordered runbook for moving to a new Mac. Everything reproducible is in this
repo; everything secret or stateful travels in one encrypted archive.

## 0. On the old Mac

```bash
migrate-export            # → ~/Desktop/migrate-<host>-<date>.tar.gz.enc
```

Packs: `~/.ssh`, `~/.zsh_history`, `~/.config/gh` (GitHub auth),
`~/.config/upscope` (droplet keys), `~/upscope-env/dev.toml`, the projects' git-ignored `.env` files, `~/.claude-mem`
(minus logs), Claude memory dirs, `~/.claude/settings.local.json`. AirDrop the
file to the new Mac. Delete both copies once the new machine works.

Also push this repo if it has local changes.

## 1. Bootstrap

```bash
xcode-select --install     # wait for it to finish
git clone https://github.com/henryraccoon/dotfiles.git ~/.dotfiles
~/.dotfiles/install.sh     # add -n to preview
```

`install.sh` installs Homebrew, runs `brew bundle` (CLI tools, GUI apps,
font, VS Code extensions), symlinks every config, installs node LTS via nvm,
tpm, Claude Code + its plugins, and points iTerm2 at `iterm2/`. It backs up
anything it replaces to `~/.dotfiles-backup/<timestamp>/` and is safe to
re-run.

Open a new terminal afterwards. zplug asks to install zsh plugins — answer
`y`. In tmux press `prefix + I` once to install plugins.

## 2. Restore secrets and state

```bash
migrate-import ~/Downloads/migrate-*.tar.gz.enc
git -C ~/.dotfiles remote set-url origin git@github.com:henryraccoon/dotfiles.git
```

## 3. Sign in by hand

- 1Password, Google Chrome, Google Drive, Slack, Fellow
- Docker Desktop (Docker Hub login; credential store is the keychain)
- Claude Code: `claude` → login. Claude desktop app.
- System Settings → Privacy & Security → Accessibility: Hammerspoon, Homerow,
  Shortcat, iTerm2. Hammerspoon also wants to launch at login (it sets this
  itself on first run).
- iTerm2: prefs load from `~/.dotfiles/iterm2/`. In Settings → General →
  Settings set "Save changes" to *When Quitting* (or *Never*) so the repo
  only changes when you mean it to.

## 4. Upscope dev environment

See [UPSCOPE_ENV.md](UPSCOPE_ENV.md) — the import already restored
`dev.toml` and the droplet keys, so it is clone + CLI install + `upscope
machine sync`.

## 5. Verify

```bash
brew bundle check --file=~/.dotfiles/homebrew/Brewfile
claude plugin list
gh auth status
upscope projects
```

## Not covered

- **git identity** — `git/gitconfig` sets the personal email globally. For
  work repos set it per repo: `git config user.email <work email>`.
- **Browser profiles, app licences, macOS system settings** — manual.
