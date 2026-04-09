# DawnCraft (Forge 1.18.2) Docker Compose

## Files

- `docker-compose.yml` - server stack
- `.env.example` - example configuration (copy to `.env`)
- `data/` - bind-mount folder that stores **all** server data (create on first start)

## First run (Linux VPS)

1) Install Docker + Docker Compose plugin.

2) In this folder:

```bash
cp .env.example .env
mkdir -p data
```

3) Set `CF_API_KEY` in `.env` (required for CurseForge downloads).

4) Start:

```bash
docker compose up -d
```

5) Watch logs:

```bash
docker compose logs -f --tail=200
```

Server listens on `25565/tcp`.

## IMPORTANT: How DawnCraft is installed

This stack uses `itzg/minecraft-server` with `TYPE=AUTO_CURSEFORGE`, which:

- downloads the modpack from CurseForge using your `CF_API_KEY`
- installs Forge/mods/configs into `/data`
- reuses `/data` on restarts (so the 800+ MB download happens only once unless you wipe `/data`)

You still need the `./data` folder for persistence (world/mods/configs). You can delete `./data` only if you intentionally want a clean reinstall.

### Pinning DawnCraft version

By default the image can track “latest”, but for stability you should pin the exact file URL:

- `CF_PAGE_URL=https://www.curseforge.com/minecraft/modpacks/dawn-craft/files/7243862`

This is already set in `.env.example`.

### If CurseForge download fails

Common causes:

- missing/invalid `CF_API_KEY`
- API key contains `$` and is not quoted in `.env` (see `.env.example`)

As a fallback, you can still do a manual install by disabling AUTO_CURSEFORGE and copying server files into `./data`, but that is not the default path in this stack.

## Where to put world/mods/configs

Everything is under `./data` (bind-mount):

- **World**: `./data/world/`
- **Mods**: `./data/mods/`
- **Configs**: `./data/config/` and sometimes `./data/defaultconfigs/`
- **Server properties**: `./data/server.properties`
- **Ops / whitelist**:
  - `./data/ops.json`
  - `./data/whitelist.json`

To import an existing world:

1) Stop server:

```bash
docker compose down
```

2) Copy your world folder to `./data/world/` (or replace the existing one).

3) Start:

```bash
docker compose up -d
```

## Backups

### Simple (offline) backup (recommended)

1) Stop server:

```bash
docker compose down
```

2) Tar the `data` folder:

```bash
tar -C . -czf backup-$(date +%F-%H%M).tar.gz data
```

3) Start again:

```bash
docker compose up -d
```

### Hot backup (advanced)

If you want hot backups, you can use RCON + `save-off`/`save-all flush`, but that requires enabling RCON and scripting it. (Not included to keep the stack beginner-simple.)

## Common knobs

Edit `.env`:

- `MAX_MEMORY` controls Xmx hard limit (e.g. `10G`)
- `INIT_MEMORY` controls Xms (e.g. `4G`)
- `MOTD`, `OPS`, `WHITELIST`
- `JVM_OPTS` for extra flags

## Restart behavior

The container is configured with `restart: unless-stopped` and will come back after reboots.
All data persists in `./data`.
