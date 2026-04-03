# Quick Start

## For Users: Deploy to Your VPS

```bash
# 1. Clone
git clone https://github.com/YOUR_USERNAME/uisp-docker.git
cd uisp-docker

# 2. Add your backup
cp /path/to/uisp-backup-*.uisp uisp-backup/

# 3. Deploy
chmod +x deploy.sh
./deploy.sh
```

Access UISP at `http://your-vps-ip:8080`

---

## For Developers: Local Testing

```bash
# Build image locally
docker compose up -d --build

# Install UISP
docker exec uisp bash -c "yes | curl -fsSL https://uisp.ui.com/install | bash"

# View logs
docker compose logs -f uisp

# Stop
docker compose down
```

---

## Troubleshooting

**Container won't start?**
```bash
docker compose logs uisp
```

**Can't access port 8080?**
```bash
docker port uisp
docker ps
```

**Need shell access?**
```bash
docker exec -it uisp bash
```

See **DEPLOYMENT.md** for full troubleshooting guide.
