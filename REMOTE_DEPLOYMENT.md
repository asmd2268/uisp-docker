# Remote Device Management Configuration

## Your Setup

- **Domain**: almftres.uisp.com
- **VPS IP**: 192.168.64.2
- **Status**: Backup ready

## Architecture

```
Ubiquiti Devices
    ↓ (Connect via HTTPS)
Domain: almftres.uisp.com
    ↓
Nginx Reverse Proxy (Port 443 SSL)
    ↓
UISP Container (Port 8080)
    ↓
Persistent Data Volumes
    ↓
Restored Backup
```

## Components

### 1. Nginx Reverse Proxy
- Handles HTTPS/SSL termination
- Rate limiting per endpoint
- Proxy passes to UISP container
- WebSocket support for real-time updates

### 2. Let's Encrypt SSL
- Automatic certificate generation
- Auto-renewal (certbot service)
- No manual intervention needed

### 3. UISP Container
- Runs application internally
- Exposed only via nginx
- Data persistence across restarts

## Deployment

### On Your VPS (SSH)

```bash
cd ~/uisp-docker
chmod +x deploy-remote.sh
./deploy-remote.sh
```

The script will:
1. ✓ Install Docker
2. ✓ Generate SSL certificate
3. ✓ Start containers (nginx + UISP)
4. ✓ Install UISP application
5. ✓ Restore your backup
6. ✓ Configure remote access

### Access Points

**Web UI:**
- https://almftres.uisp.com (external - via Nginx)
- https://192.168.64.2:8443 (internal - direct)

**Device Registration:**
- Devices automatically register to: https://almftres.uisp.com

**API:**
- https://almftres.uisp.com/api/

## Security Features

- HTTPS/TLS 1.2+ only
- HSTS (Force HTTPS)
- Rate limiting (general, API, device)
- Security headers
- X-Frame-Options
- Content-Type validation

## Device Connection

### For Ubiquiti Devices

1. Access device web UI (192.168.X.X:8080)
2. Configure Controller:
   ```
   Controller: almftres.uisp.com
   Port: 443 (default HTTPS)
   ```
3. Device will auto-register to your UISP

### From UISP Web UI

1. Visit: https://almftres.uisp.com
2. Login with backup credentials
3. All devices will appear after registering
4. Manage from anywhere

## Certificate Management

**Check certificate status:**
```bash
docker exec uisp-certbot certbot certificates
```

**Certificate path:**
```
ssl/live/almftres.uisp.com/
├── fullchain.pem (for nginx)
├── privkey.pem (for nginx)
└── cert.pem (certificate only)
```

**Manual renewal (if needed):**
```bash
docker compose restart certbot
```

## Monitoring & Logs

**UISP logs:**
```bash
docker compose logs -f uisp
```

**Nginx logs:**
```bash
docker compose logs -f nginx
```

**Certbot logs:**
```bash
docker compose logs -f certbot
```

**Full logs:**
```bash
docker compose logs -f
```

## Firewall Configuration

Make sure these ports are open on your VPS:

```bash
# HTTP (Let's Encrypt validation)
sudo ufw allow 80/tcp

# HTTPS (Primary)
sudo ufw allow 443/tcp

# Optional: Direct UISP access
sudo ufw allow 8080/tcp
sudo ufw allow 8443/tcp
```

Check status:
```bash
sudo ufw status
```

## Troubleshooting

### Can't access domain
1. Check DNS: `nslookup almftres.uisp.com`
2. Should resolve to: 192.168.64.2
3. Restart nginx: `docker compose restart nginx`

### Certificate errors
1. Check cert: `docker exec uisp-certbot certbot certificates`
2. View error log: `docker compose logs certbot`
3. Renew: `docker exec uisp-certbot certbot renew --force-renewal`

### Devices not connecting
1. Check UISP running: `docker ps`
2. Check logs: `docker compose logs uisp`
3. Verify domain accessible: `curl -k https://almftres.uisp.com`
4. Restart UISP: `docker compose restart uisp`

### SSL port errors
1. Verify ports free: `sudo netstat -tlnp | grep :443`
2. Check firewall: `sudo ufw status`
3. Restart containers: `docker compose down && docker compose up -d`

## Performance Tuning

**For many devices:**

```bash
# Increase file descriptors
ulimit -n 65536

# Increase system limits (on VPS)
sudo sysctl -w net.ipv4.tcp_max_syn_backlog=4096
```

## Backup & Recovery

**Create new backup:**
```bash
docker exec uisp uisp-backup /data/backup-$(date +%Y%m%d).uisp
docker cp uisp:/data/backup-*.uisp ./backups/
```

**Restore new backup:**
```bash
cp new-backup.uisp ./uisp-backup/
docker exec uisp uisp-restore /backup/new-backup.uisp
```

## Next Steps

1. **Deploy:** Run `./deploy-remote.sh` on VPS
2. **Verify:** Check https://almftres.uisp.com
3. **Configure devices:** Add almftres.uisp.com as controller
4. **Monitor:** Watch devices auto-register in UISP

---

**Your UISP is now production-ready for remote device management!** 🚀
