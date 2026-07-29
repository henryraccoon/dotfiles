# Upscope Dev Environment (for Claude)

Applies when working anywhere under `~/upscope-env/`.

## Mental model — READ FIRST

- Nothing runs locally. All containers run on a **DigitalOcean droplet**; the local docker daemon is not used. The local checkout is an editor-side replica, **Mutagen-synced** to the droplet (edits arrive in ~1-2s).
- The only correct way to run, test, migrate, or open consoles is the **`upscope` CLI** — it execs into containers on the droplet. NEVER run bare `yarn <script>`, `docker compose`, `psql`, `redis-cli`, or app servers on the local machine and expect the app to react.
- Local `yarn install` / `tsc` / lint for editor tooling is fine — it's the runtime that lives remotely.
- Dirs generated on the remote (drizzle migrations: `ai/drizzle`, `userview/api/db/migrations`) sync back two-way; after `db generate` the files appear locally on their own.
- `~/upscope-env/dev.toml` holds droplet credentials and an access token — SECRETS. Never read, print, or commit it.
- `upscope docs` opens full HTML docs for the CLI + projects — source of truth if this file drifts.

## CLI structure

`dev.toml [projects]` registers aliases: `uv` → `userview/`, `ai` → `ai/`. Each project's `cli.yml` declares its command tree, mounted under the alias:

```sh
upscope uv db migrate apply     # from anywhere
upscope db migrate              # alias optional inside ~/upscope-env/ai
```

`upscope <alias> --help` / `upscope --help` list the real tree — check there before inventing a command.

## Common commands

Global:

| Command | Does |
| --- | --- |
| `upscope up` | `docker compose up -d` for every project |
| `upscope machine ssh` | shell on the droplet |
| `upscope machine sync` | re-sync all projects to the droplet |
| `upscope docker:<container> <compose args>` | compose scoped to one container (current project) |
| `upscope worktree ...` | git worktree management (runs cli.yml setup steps) |
| `upscope projects` | list registered projects |

`ai` project:

| Command | Does |
| --- | --- |
| `upscope ai db migrate` / `generate` / `smoke` | drizzle migrations in the `ai` container |
| `upscope ai run analyze` / `nightly` / `list-tools` | run agents/scripts in the `ai` container |
| `upscope ai console postgres` | psql into `event-db` (db `company_ai`) |
| `upscope ai console redis` | redis-cli |

`uv` (userview) project:

| Command | Does |
| --- | --- |
| `upscope uv db migrate apply` / `push` / `generate` / `generate:blank` / `drop` | drizzle migrations in the `api` container (dev + test dbs) |
| `upscope uv db setup` / `seed` / `reset` | create/seed/reset `upscope_dev` + `upscope_test` |
| `upscope uv test api [file/flags]` | api suite; args forward to `yarn test` |
| `upscope uv test cobrowsing server [args]` | cobrowsing server suite |
| `upscope uv console api` / `postgres` / `redis` / `mongodb` | consoles in containers |
| `upscope uv build cobrowsing` / `types` / `onpremise` | rebuild bundles / api types / on-prem image |
| `upscope uv yarn api` / `app-frontend` / `cobrowsing sdk\|viewer\|server` | reinstall deps in containers + restart |

App hostnames (`app.upscope.local`, `api.upscope.local`, …) are routed via `/etc/hosts` + the droplet's nginx — managed by `upscope hosts` / `upscope machine nginx`, not hand-edited.
