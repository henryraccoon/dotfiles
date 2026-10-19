#!/usr/bin/env bash
# Bootstrap a Mac from these dotfiles. Idempotent: safe to re-run any time.
# Usage: ./install.sh [-n|--dry-run]
set -euo pipefail

DOTFILES="${DOTFILES:-$HOME/.dotfiles}"
BREWFILE="$DOTFILES/homebrew/Brewfile"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
BREW_PREFIX=/opt/homebrew
DRY_RUN=0

case "${1:-}" in
  -n|--dry-run) DRY_RUN=1 ;;
  "") ;;
  *) echo "usage: $0 [-n|--dry-run]" >&2; exit 2 ;;
esac

log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33mwarn:\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31merror:\033[0m %s\n' "$*" >&2; exit 1; }
run()  { if (( DRY_RUN )); then printf '    [dry-run] %s\n' "$*"; else "$@"; fi; }

[[ -f "$BREWFILE" ]] || die "dotfiles not found at $DOTFILES (clone to ~/.dotfiles or set DOTFILES)"

link() {
  local src="$DOTFILES/$1" dst="$2"
  if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
    return
  fi
  if [[ -e "$dst" || -L "$dst" ]]; then
    local backup="$BACKUP_DIR${dst#"$HOME"}"
    warn "$dst exists, moving to $backup"
    run mkdir -p "$(dirname "$backup")"
    run mv "$dst" "$backup"
  fi
  [[ -d "$(dirname "$dst")" ]] || run mkdir -p "$(dirname "$dst")"
  run ln -s "$src" "$dst"
  log "linked $dst"
}

remove_dangling_link() {
  local path="$1"
  if [[ -L "$path" && ! -e "$path" ]]; then
    log "removing dangling symlink $path"
    run rm "$path"
  fi
}

install_xcode_clt() {
  xcode-select -p &>/dev/null && return
  log "installing Xcode Command Line Tools (follow the GUI prompt)"
  run xcode-select --install
  (( DRY_RUN )) && return
  until xcode-select -p &>/dev/null; do sleep 10; done
}

install_homebrew() {
  if [[ ! -x "$BREW_PREFIX/bin/brew" ]]; then
    log "installing Homebrew"
    run /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  [[ -x "$BREW_PREFIX/bin/brew" ]] && eval "$("$BREW_PREFIX/bin/brew" shellenv)"
}

trust_taps() {
  local taps
  taps=$(sed -n 's/^tap "\(.*\)"$/\1/p' "$BREWFILE")
  [[ -n "$taps" ]] || return
  log "trusting third-party taps"
  # shellcheck disable=SC2086
  run brew trust --tap $taps
}

install_packages() {
  log "brew bundle ($BREWFILE)"
  run brew bundle install --file="$BREWFILE"
}

link_configs() {
  log "symlinking configs"
  link zsh/zshrc    "$HOME/.zshrc"
  link zsh/zshenv   "$HOME/.zshenv"
  link zsh/zprofile "$HOME/.zprofile"

  link git/gitconfig     "$HOME/.gitconfig"
  link git/gitmessage    "$HOME/.gitmessage"
  link git/global_ignore "$HOME/.global_ignore"

  link starship.toml "$HOME/.config/starship.toml"
  link tmux          "$HOME/.config/tmux"
  link hammerspoon   "$HOME/.hammerspoon"

  link claude/settings.json "$HOME/.claude/settings.json"
  link claude/CLAUDE.md     "$HOME/.claude/CLAUDE.md"
  link claude/agents        "$HOME/.claude/agents"
  link claude/skills        "$HOME/.claude/skills"
  link claude/docs          "$HOME/.claude/docs"
  link claude/commands      "$HOME/.claude/commands"

  link vscode/settings.json    "$HOME/Library/Application Support/Code/User/settings.json"
  link vscode/keybindings.json "$HOME/Library/Application Support/Code/User/keybindings.json"

  remove_dangling_link "$HOME/.zlogin"
  remove_dangling_link "$HOME/.config/nvim"
}

install_node() {
  local nvm_sh="$BREW_PREFIX/opt/nvm/nvm.sh"
  [[ -s "$nvm_sh" ]] || { warn "nvm not installed yet, skipping node"; return; }
  export NVM_DIR="$HOME/.nvm"
  run mkdir -p "$NVM_DIR"
  # shellcheck disable=SC1090
  source "$nvm_sh"
  if ! nvm ls --no-colors lts/* &>/dev/null; then
    log "installing node LTS via nvm"
    run nvm install --lts
    run nvm alias default 'lts/*'
  fi
}

install_tmux_plugins() {
  local tpm="$HOME/.config/tmux/plugins/tpm"
  [[ -d "$tpm" ]] && return
  log "cloning tpm"
  run git clone --depth 1 https://github.com/tmux-plugins/tpm "$tpm"
}

install_claude_code() {
  if ! command -v claude &>/dev/null; then
    log "installing Claude Code"
    run bash -c "$(curl -fsSL https://claude.ai/install.sh)"
    export PATH="$HOME/.local/bin:$PATH"
  fi
  command -v claude &>/dev/null || { warn "claude not on PATH, skipping plugins"; return; }

  log "configuring Claude Code plugin marketplaces"
  run claude plugin marketplace add anthropics/claude-plugins-official
  run claude plugin marketplace add thedotmack/claude-mem
  run claude plugin marketplace update
  jq -r '.enabledPlugins | to_entries[] | select(.value) | .key' "$DOTFILES/claude/settings.json" |
    while read -r plugin; do
      run claude plugin install "$plugin" || warn "could not install $plugin"
    done
}

configure_iterm() {
  log "pointing iTerm2 at $DOTFILES/iterm2"
  run defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$DOTFILES/iterm2"
  run defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
}

main() {
  install_xcode_clt
  install_homebrew
  trust_taps
  install_packages
  link_configs
  install_node
  install_tmux_plugins
  install_claude_code
  configure_iterm
  log "done. Open a new terminal; zplug will offer to install zsh plugins, tmux needs prefix+I once."
}

main
