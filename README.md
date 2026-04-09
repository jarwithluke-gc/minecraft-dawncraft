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

3) **Put DawnCraft server files** into `./data` (see next section).

4) Start:

```bash
docker compose up -d
```

5) Watch logs:

```bash
docker compose logs -f --tail=200
```

Server listens on `25565/tcp`.

## IMPORTANT: How to install DawnCraft server files

DawnCraft usually requires **their provided server pack/archive** (not only Forge installer).
There are two common approaches:

### Option A (recommended): Use DawnCraft “Server Files” archive

1) Download the official DawnCraft **Server Files** archive for the same modpack version you want.
2) Extract/copy the contents of that archive into `./data/`.

You should end up with something like:

- `data/mods/` (many `.jar`)
- `data/config/`
- `data/defaultconfigs/` (often)
- `data/kubejs/` (if included)
- `data/scripts/` or similar

Then start the container.

### Option B: Let container install Forge, then “overlay” mods/configs

If you don’t have a full server pack, but only client pack content:

1) Start once with empty `data/` (container will generate Forge server skeleton):

```bash
docker compose up -d
```

2) Stop:

```bash
docker compose down
```

3) Copy DawnCraft `mods/`, `config/`, `defaultconfigs/`, etc. into `./data/`.

4) Start again.

Notes:
- Many guides pin **Forge 40.2.1** for 1.18.2; this stack exposes it via `FORGE_VERSION`.
- Some modpacks require accepting additional mod-specific prompts on first boot; check logs.

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
