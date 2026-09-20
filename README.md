# Pelican RustFS

RustFS S3-compatible object storage server for Pelican.

This repository contains a custom Pelican Egg and Docker image for running RustFS as an S3-compatible storage server.

**Version: 1.1.0**

## Features

- RustFS S3-compatible object storage
- Pelican Egg
- Docker image published through GitHub Container Registry
- Persistent storage via Pelican Mounts
- S3 API and Web Console
- Configurable access and secret keys
- External storage support, such as HDDs

## Requirements

- Pelican Panel
- Pelican Wings
- A server/node with enough storage for your S3 data
- A configured Pelican Mount for persistent RustFS storage

## Installation

1. Download `egg-rustfs.json` from this repository.
2. Import the Egg into your Pelican Panel.
3. Create a new RustFS server using the imported Egg.
4. Assign two ports to the server:
   - `9000` – S3 API
   - `9001` – RustFS Web Console
5. Configure the Access Key and Secret Key.
6. Configure a Pelican Mount for `/rustfs-data` as described in the **Persistent Storage** section below.
7. Start the server.

## Configuration

The Egg provides the following variables:

| Variable | Description | Default |
|---|---|---|
| `RUSTFS_ACCESS_KEY` | S3 access key | `rustfsadmin` |
| `RUSTFS_SECRET_KEY` | S3 secret key | `Change this value` |

RustFS stores its data in:

```text
/rustfs-data
```

This path is intended to be provided through a Pelican Mount.

## Important: Private / Local S3 Addresses

When using a private or local RustFS address as a Pelican backup destination, the address may need to be added to the Pelican backup restore host allowlist.

Edit:

```text
/etc/pelican/config.yml
```

and add the RustFS IP address or hostname under:

```yaml
system:
  backups:
    restore_host_allowlist: []
```

For example:

```yaml
system:
  backups:
    restore_host_allowlist:
      - "192.168.178.50"
      - "rustfs.example.ts.net"
```

After changing the configuration, restart the Pelican Panel/Wings as required for the configuration change to take effect.

> **Note:** Only add addresses that you trust and actually use for your RustFS instance. Do not expose RustFS publicly just to avoid the allowlist.

## Ports

| Port | Purpose |
|---|---|
| `9000` | S3 API |
| `9001` | RustFS Web Console |

The ports are configured through Pelican Allocations and are not hard-coded in the Egg.

## Persistent Storage

RustFS stores its persistent data in:

```text
/rustfs-data
```

This path should be provided through a Pelican Mount.

A typical setup using a separate HDD looks like this:

| Location | Path |
|---|---|
| Wing host | `/mnt/rustfs/data` |
| RustFS container | `/rustfs-data` |

The host path can be located on a separate HDD or other persistent storage.

This allows the RustFS container and its operating system files to remain on the system/SSD storage while the actual S3 data is stored separately.

## Pelican Mount

Configure a Pelican Mount with:

| Setting | Value |
|---|---|
| Host Source | `/mnt/rustfs/data` |
| Container Target | `/rustfs-data` |
| Read Only | Disabled |

The Wing must allow the host path through `allowed_mounts`.

For example, in:

```text
/etc/pelican/config.yml
```

configure:

```yaml
allowed_mounts:
  - /mnt/rustfs
```

After changing the configuration, restart Wings.

The storage directory must be writable by the user running the RustFS container.

For example, on a setup where the Pelican container runs as UID/GID `988:988`:

```bash
sudo chown -R 988:988 /mnt/rustfs/data
```

The exact UID/GID may differ depending on the Pelican/Wings configuration.

RustFS checks that `/rustfs-data` exists and is writable before starting.

If the mount is missing or not writable, RustFS will refuse to start.

This prevents RustFS from accidentally storing data on the container's SSD when the external storage is unavailable.

## Docker Image

The Docker image is published to GitHub Container Registry:

```text
ghcr.io/batudege/pelican-rustfs:latest
```

## Repository Structure

```text
.
├── Dockerfile
├── entrypoint.sh
├── egg-rustfs.json
├── README.md
└── .github/
    └── workflows/
        └── docker.yml
```

## License

See the repository for license information.
