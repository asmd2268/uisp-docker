# UISP Docker Deployment

Complete Docker Compose setup for deploying Ubiquiti UISP (UI Service Platform) on a VPS with backup restoration.

## Quick Start

### Prerequisites
- Ubuntu 22.04 LTS VPS (2GB+ RAM, 20GB+ disk)
- SSH access with sudo privileges

### Deploy

```bash
# 1. Clone repository
git clone https://github.com/YOUR_USERNAME/uisp-docker.git
cd uisp-docker

# 2. Copy your UISP backup
cp /path/to/uisp-backup-*.uisp ./uisp-backup/

# 3. Run deployment
chmod +x deploy.sh
./deploy.sh
```

### Access UISP
- **HTTP**: `http://your-vps-ip:8080`
- **HTTPS**: `http://your-vps-ip:8443`

## Features

- 🐳 Docker Compose orchestration
- 💾 Persistent volumes for data and configuration
- 🔄 Automatic backup restoration
- 🔒 Systemd-based init process
- 📊 Multiple port mapping (80, 443, 8080, 8443)
- 🛡️ Hardened image migration guide included

## Files

- `docker-compose.yml` — Container orchestration configuration
- `Dockerfile` — Ubuntu 22.04 with UISP installer
- `deploy.sh` — Automated deployment script
- `DEPLOYMENT.md` — Complete deployment guide
- `DHI_MIGRATION.md` — Security hardening options
- `uisp-backup/` — Place your backup file here

## Deployment Options

### Option 1: Automated (Recommended)
```bash
./deploy.sh
```

### Option 2: Manual
```bash
docker compose up -d --build
docker exec uisp bash -c "yes | curl -fsSL https://uisp.ui.com/install | bash"
docker exec uisp uisp-restore /backup/uisp-backup-*.uisp
```

## Documentation

- **DEPLOYMENT.md** — Full deployment guide with troubleshooting
- **DHI_MIGRATION.md** — Docker Hardened Images migration
- `docker-compose.yml` — Inline comments for configuration

## Ports

- `80` — HTTP
- `443` — HTTPS
- `8080` — UISP Web UI (HTTP)
- `8443` — UISP Web UI (HTTPS)

## Useful Commands

```bash
# View logs
docker compose logs -f uisp

# Shell access
docker exec -it uisp bash

# Restart
docker compose restart uisp

# Stop
docker compose down
```

## Backup & Recovery

### Create backup
```bash
docker exec uisp uisp-backup /data/backup-$(date +%Y%m%d).uisp
docker cp uisp:/data/backup-*.uisp ./backups/
```

### Restore backup
```bash
cp your-backup.uisp ./uisp-backup/
docker exec uisp uisp-restore /backup/your-backup.uisp
```

## Security

1. Update admin credentials after deployment
2. Use HTTPS (port 8443) with valid certificate
3. Restrict firewall rules to trusted IPs
4. Keep backups in secure location
5. Monitor with Docker Scout: `docker scout cves uisp:latest`

## VPS Providers

Tested with:
- DigitalOcean (Ubuntu 22.04)
- Linode (Ubuntu 22.04)
- AWS (Ubuntu 22.04 AMI)
- Vultr (Ubuntu 22.04)

## Troubleshooting

See **DEPLOYMENT.md** for:
- Container startup issues
- UISP installation problems
- Port mapping issues
- Backup restoration failures
- Firewall configuration

## License

Use according to UISP and Ubuntu licensing terms.

## Support

For issues:
1. Check `DEPLOYMENT.md` troubleshooting section
2. Review `docker compose logs uisp`
3. Access container: `docker exec -it uisp bash`

---

**Deployed with Docker** 🐳
