# Upscope dev environment

Everything lives under `~/upscope-env`; a Go CLI (`upscope`) manages a remote
DigitalOcean docker machine. Nothing runs locally — local checkouts are
Mutagen-synced replicas.

```
~/upscope-env/
├── bin/upscope    # the CLI binary (on $PATH via zshenv: UPSCOPE_DIR=$HOME/upscope-env)
├── upscope-cli/   # CLI source (optional) → git@github.com:upscopeio/upscope-cli.git
├── userview/      # "uv" product         → git@github.com:upscopeio/upscope.git
├── ai/            # "ai" product
└── dev.toml       # machine config + credentials — SECRETS, not in git
```

Products are registered in `dev.toml` under `[projects]`. The CLI namespaces
commands per product: `upscope uv docker:<container> <cmd>`.

## Setup on a clean machine

Dotfiles first ([SETUP.md](SETUP.md)) — zshenv exports `UPSCOPE_DIR` and puts
`$UPSCOPE_DIR/bin` on `$PATH`. `migrate-import` restores `dev.toml`,
`~/.config/upscope/machines/` (droplet ssh keys) and the `gh` login.

```bash
cd ~/upscope-env
git clone git@github.com:upscopeio/upscope.git userview
gh auth status   # the upscope-cli repo is private; the installer downloads through gh
s=$(gh api -H "Accept: application/vnd.github.raw" repos/upscopeio/upscope-cli/contents/scripts/install.sh) && printf '%s\n' "$s" | sh
```

Then re-attach to the **existing** droplet (do not run `machine setup`, that
provisions a new one):

```bash
upscope machine sync     # claims the droplet for this Mac: rotates the sync token,
                         # rewrites ~/.ssh/config, severs the old Mac's sync
upscope hosts apply      # /etc/hosts entries (re-runs under sudo)
upscope up               # idempotent; containers are probably already running
```

The old Mac's mutagen will log sync errors until it runs `upscope machine
sync` itself — expected.

Fresh droplet instead: `upscope machine setup`, then `upscope hosts apply`,
`upscope deps`, `upscope up`.

`upscope docs` opens the full HTML documentation — source of truth when this
file drifts. `upscope upgrade` updates the binary.

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

When containers change, update `container_list` in `zsh/zshrc` to match
`upscope --help`'s `docker:*` commands.
