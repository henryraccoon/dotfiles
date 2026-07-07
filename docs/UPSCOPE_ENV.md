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
git clone git@github.com:upscopeio/upscope-cli.git
git clone git@github.com:upscopeio/upscope.git userview
cd upscope-cli && make    # builds the binary; check its README for the exact target
```

Then, in order:

```bash
upscope machine setup    # provisions the DigitalOcean docker machine (recreates dev.toml credentials)
upscope hosts            # /etc/hosts entries for uv
upscope deps             # runs the dependency install steps (yarn installs etc.)
upscope machine sync     # mutagen-syncs projects to the machine
upscope up               # docker compose up -d for every configured project
```

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
