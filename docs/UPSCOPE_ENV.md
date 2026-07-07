# Upscope dev environment

Current architecture (mid-2026): everything lives under `~/upscope-env`, products are split, and a Go CLI (`upscope`) manages the remote docker machine.

```
~/upscope-env/
├── bin/upscope    # the CLI binary (on $PATH via zshenv: UPSCOPE_DIR=$HOME/upscope-env)
├── upscope-cli/   # CLI source        → git@github.com:upscopeio/upscope-cli.git
├── userview/      # "uv" product      → git@github.com:upscopeio/upscope.git
└── dev.toml       # machine config + credentials — SECRETS, not in git, back up separately
```

Products are registered in `dev.toml` under `[projects]` (currently only `uv = './userview'`). The CLI namespaces commands per product: `upscope uv docker:<container> <cmd>`.

## Setup on a clean machine

Dotfiles must be set up first (see [SETUP.md](SETUP.md)) — zshenv exports `UPSCOPE_DIR` and puts `$UPSCOPE_DIR/bin` on `$PATH`.

```bash
mkdir ~/upscope-env && cd ~/upscope-env
git clone git@github.com:upscopeio/upscope.git userview
gh auth login   # upscope-cli repo is private; the installer downloads through gh
s=$(gh api -H "Accept: application/vnd.github.raw" repos/upscopeio/upscope-cli/contents/scripts/install.sh) && printf '%s\n' "$s" | sh
```

The installer drops the prebuilt binary into `$UPSCOPE_DIR/bin`. It self-updates: `upscope upgrade` (and a daily auto-check prompts when a new release exists). Building from source (`git clone git@github.com:upscopeio/upscope-cli.git && cd upscope-cli && make install`, Go 1.24+) is only needed for CLI development.

Then, in order:

```bash
upscope machine setup    # provisions the DO machine, creates the docker network,
                         # syncs every project, and runs nginx sync (recreates dev.toml credentials)
upscope hosts apply      # add uv hostnames to /etc/hosts (re-runs under sudo)
upscope deps             # runs the dependency install steps (yarn installs etc.)
upscope up               # docker compose up -d for every configured project
```

`upscope machine sync` is only needed later (e.g. after `upscope machine repair` on another computer reclaims sync ownership) — `machine setup` already syncs everything.

`upscope docs` opens the full HTML documentation for the CLI and configured projects — source of truth when this file drifts.

## Day-to-day shell helpers (from zshrc)

| Command      | Does                                                     |
| ------------ | -------------------------------------------------------- |
| `ul`         | pick product + container → follow logs                   |
| `ur`         | pick product + container → restart it                    |
| `ue`         | pick product + container → shell into it                 |
| `ub`         | `upscope uv build cobrowsing`                            |
| `ut`         | pick product → build types                               |
| `ud`         | pick product → db reset                                  |
| `uc`         | `upscope machine sync`                                   |
| `us`         | terminate all mutagen syncs, then re-sync                |
| `lazydocker` | `upscope lazydocker` (project-scoped TUI inside a repo)  |

When containers change, update `container_list` in `zsh/zshrc` to match `upscope --help`'s `docker:*` commands.
