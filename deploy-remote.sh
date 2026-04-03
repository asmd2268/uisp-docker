#!/bin/bash
set -e

echo "=== UISP Remote Management Deployment ==="
echo "Domain: almftres.uisp.com"
echo "VPS IP: 192.168.64.2"
echo ""

# Step 1: Install Docker
echo "[1/6] Installing Docker..."
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
rm get-docker.sh

# Step 2: Setup directories
echo "[2/6] Creating directories..."
mkdir -p nginx/conf.d ssl certbot-webroot uisp-backup

# Step 3: Generate initial SSL certificate with Let's Encrypt
echo "[3/6] Generating SSL certificate..."
sudo mkdir -p ssl
docker run --rm -v $(pwd)/ssl:/etc/letsencrypt -v $(pwd)/certbot-webroot:/var/www/certbot \
  certbot/certbot certonly --webroot -w /var/www/certbot \
  -d almftres.uisp.com \
  --email admin@almftres.uisp.com \
  --agree-tos \
  --non-interactive \
  --preferred-challenges http || true

# Step 4: Start containers
echo "[4/6] Starting UISP container (this may take a few minutes)..."
docker compose up -d --build

echo "[5/6] Waiting for UISP to initialize..."
sleep 60

# Step 5: Install UISP
echo "[5/6] Installing UISP application..."
docker exec uisp bash -c "yes | curl -fsSL https://uisp.ui.com/install | bash" 2>&1 | tail -50

# Step 6: Restore backup
echo "[6/6] Restoring backup..."
if [ -f "uisp-backup/uisp-backup-*.uisp" ]; then
    docker exec uisp uisp-restore uisp-backup/uisp-backup-*.uisp
    echo "✓ Backup restored successfully"
else
    echo "⚠ No backup file found in uisp-backup/"
    echo "  Copy your backup and run:"
    echo "  docker exec uisp uisp-restore /backup/uisp-backup-*.uisp"
fi

echo ""
echo "=== Deployment Complete ==="
echo ""
echo "✓ UISP is running with SSL"
echo "✓ Domain: https://almftres.uisp.com"
echo "✓ VPS IP: 192.168.64.2"
echo ""
echo "Access UISP:"
echo "  Web UI: https://almftres.uisp.com"
echo "  Local: https://192.168.64.2:8443"
echo ""
echo "Configure your devices to connect to:"
echo "  https://almftres.uisp.com"
echo ""
echo "Useful commands:"
echo "  View logs:     docker compose logs -f uisp"
echo "  Restart:       docker compose restart uisp"
echo "  Stop:          docker compose down"
echo "  Shell access:  docker exec -it uisp bash"
echo "  Check cert:    docker exec uisp-certbot certbot certificates"
echo ""
echo "Certificate renewal: Automatic (certbot runs in background)"
echo ""
