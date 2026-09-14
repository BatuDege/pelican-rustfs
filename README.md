Ja, unbedingt. Das ist für unser Egg eine wichtige Besonderheit, weil RustFS gerade für **Backups in Pelican** interessant ist.

Ich würde die README ungefähr so strukturieren:

````markdown
# Pelican RustFS

RustFS S3-compatible object storage server for Pelican.

This repository contains a custom Pelican Egg and Docker image for running
RustFS as an S3-compatible storage server.

## Features

- RustFS S3-compatible object storage
- Pelican Egg
- Docker image published through GitHub Container Registry
- Persistent storage in `/mnt/server/data`
- S3 API and Web Console
- Configurable access and secret keys

## Requirements

- Pelican Panel
- Pelican Wings
- A server/node with enough storage for your S3 data

## Installation

1. Download `egg-rustfs.json` from this repository.
2. Import the Egg into your Pelican Panel.
3. Create a new RustFS server using the imported Egg.
4. Assign two ports to the server:

   - `9000` – S3 API
   - `9001` – RustFS Web Console

5. Configure the Access Key and Secret Key.
6. Start the server.

## Configuration

The Egg provides the following variables:

| Variable | Description | Default |
|---|---|---|
| `RUSTFS_ACCESS_KEY` | S3 access key | `rustfsadmin` |
| `RUSTFS_SECRET_KEY` | S3 secret key | `Change this value` |

The RustFS data is stored in:

```text
/mnt/server/data
````

## Important: Private / Local S3 Addresses

Pelican does not allow local or private IP addresses as S3 backup destinations
by default.

If RustFS is running on a private IP address or an internal hostname, the
address must be added to the Pelican backup restore host allowlist.

Edit:

```text
/etc/pelican/config.yml
```

and add the RustFS IP address or hostname under:

```yaml
system:
  backups:
    restore_host_allowlist:
      - "xx.xxx.xxx.xx"
      - "rustfs-deinname.ts.net"
```

For example:

```yaml
system:
  backups:
    restore_host_allowlist:
      - "192.168.178.50"
      - "rustfs.example.ts.net"
```

After changing the configuration, restart the Pelican Panel/Wings as required
for the configuration change to take effect.

> **Note:** Only add addresses that you trust and actually use for your RustFS
> instance. Do not expose RustFS publicly just to avoid the allowlist.

## Ports

| Port   | Purpose            |
| ------ | ------------------ |
| `9000` | S3 API             |
| `9001` | RustFS Web Console |

The ports are configured through Pelican Allocations and are not hard-coded
in the Egg.

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
└── .github/
    └── workflows/
        └── docker.yml
```

## License

See the repository for license information.
