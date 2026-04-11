# Software Setup — [Project Name]

## Base Image

[OS name and version, e.g.: Raspberry Pi OS Bookworm (Debian 12)]
Pi hostname: `[hostname]`, user: `pi`

## Dependencies

```bash
sudo apt-get update
sudo apt-get install -y [packages]
```

## Configuration

[Describe key configuration files. Config files live in `config/` and are deployed via `scripts/deploy.sh`.]

## SSH Access

```bash
ssh -i ~/.ssh/pi_key pi@[hostname].local
```

## Provisioning (Fresh Flash)

After flashing a fresh image, run from your Mac:

```bash
bash projects/[project-name]/scripts/setup.sh
```

## Deploy Config Changes

After modifying any file in `config/`:

```bash
bash projects/[project-name]/scripts/deploy.sh
```
