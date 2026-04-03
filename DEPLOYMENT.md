# UISP Docker Deployment Guide

## Quick Start

### 1. Prepare Your VPS
- Ubuntu 22.04 LTS (recommended)
- At least 2GB RAM, 20GB disk space
- SSH access with sudo privileges

### 2. Copy Files to Your VPS
```bash
scp -r /path/to/local/uisp-docker user@your-vps-ip:~/
# Or: git clone <repo> ~/uisp-docker && cd ~/uisp-docker
```

Your directory should look like:
```
uisp-docker/
├── docker-compose.yml
├── Dockerfile
├── deploy.sh
└── uisp-backup/
    └── uisp-backup-20260210-0400-3.0.151.uisp
```

### 3. Deploy to VPS
```bash
ssh user@your-vps-ip
cd ~/uisp-docker
chmod +x deploy.sh
./deploy.sh
```

The script will:
- Install Docker and Docker Compose
- Build the UISP container
- Install UISP inside the container
- Restore your backup automatically

### 4. Access UISP
Once deployment completes, visit:
- **HTTP**: `http://your-vps-ip:8080`
- **HTTPS**: `http://your-vps-ip:8443`

---

## Manual Deployment (Step-by-Step)

If you prefer manual control:

```bash
# 1. SSH to your VPS
ssh user@your-vps-ip
cd ~/uisp-docker

# 2. Start the container
docker compose up -d --build

# 3. Install UISP (5-10 min)
docker exec uisp bash -c "yes | curl -fsSL https://uisp.ui.com/install | bash"

# 4. Restore backup
docker exec uisp uisp-restore /backup/uisp-backup-*.uisp

# 5. Verify
docker compose logs uisp
docker ps
```

---

## File Structure

### docker-compose.yml
- Defines UISP service
- Maps ports: 80, 443, 8080, 8443
- Creates persistent volumes for data and config
- Mounts backup directory as read-only

### Dockerfile
- Base: Ubuntu 22.04 with systemd
- Pre-installs: curl, ca-certificates, gettext-base
- Includes UISP installation script

### uisp-backup/
- Mount point for your backup file
- Automatically available inside container at `/backup/`

---

## Useful Commands

```bash
# View logs (live)
docker compose logs -f uisp

# View logs (last 50 lines)
docker compose logs --tail=50 uisp

# Shell access
docker exec -it uisp bash

# Restart container
docker compose restart uisp

# Stop container
docker compose down

# Check status
docker ps
docker compose ps
systemctl status docker  # VPS-only

# Check disk usage
docker system df
du -sh uisp_*  # Volume sizes
```

---

## Troubleshooting

### Container won't start
```bash
docker compose logs uisp
docker inspect uisp  # Check error details
```

### UISP installation failed
```bash
# Re-run installation
docker exec uisp bash -c "yes | curl -fsSL https://uisp.ui.com/install | bash"

# Check installation
docker exec uisp systemctl status uisp-unms
docker exec uisp systemctl status unms
```

### Can't access UISP (port 8080)
```bash
# Check if container is running
docker ps | grep uisp

# Check port mapping
docker port uisp

# Check firewall (on VPS)
sudo ufw status
sudo ufw allow 8080/tcp
sudo ufw allow 8443/tcp
```

### Restore backup failed
```bash
# Verify backup file exists
docker exec uisp ls -lh /backup/

# Re-run restore
docker exec uisp uisp-restore /backup/uisp-backup-*.uisp

# Check UISP logs for errors
docker exec uisp tail -f /var/log/unms/unms.log
```

---

## Backup & Recovery

### Create a backup
```bash
docker exec uisp uisp-backup /data/uisp-backup.uisp
docker cp uisp:/data/uisp-backup.uisp ./backups/
```

### Restore a backup
```bash
cp your-backup.uisp ./uisp-backup/
docker exec uisp uisp-restore /backup/your-backup.uisp
```

---

## Security Notes

1. **Change default credentials** — Login to UISP and update admin password
2. **Use HTTPS** — Access via port 8443 with valid certificate
3. **Firewall rules** — Restrict ports to trusted IPs:
   ```bash
   sudo ufw allow from YOUR.IP.ADDRESS to any port 8080
   ```
4. **Keep updated** — Check for UISP updates regularly

---

## Performance Tips

- Allocate at least 2 CPUs and 2GB RAM to the container
- Use SSD storage for database
- Monitor disk space: `docker exec uisp df -h /data`
- Periodic backups: `docker exec uisp uisp-backup /data/backup-$(date +%Y%m%d).uisp`

---

## Need Help?

Check container logs:
```bash
docker compose logs uisp
```

Access container shell:
```bash
docker exec -it uisp bash
systemctl status  # Inside container
```
