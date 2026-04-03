#!/bin/bash
set -e

echo "=== UISP Docker Deployment Script ==="
echo ""
echo "This script will:"
echo "1. Install Docker & Docker Compose"
echo "2. Deploy UISP container"
echo "3. Install UISP (with your backup)"
echo "4. Restore your backup data"
echo ""
read -p "Press Enter to continue or Ctrl+C to cancel..."
echo ""

# Install Docker
echo "[1/4] Installing Docker..."
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
rm get-docker.sh

# Create working directory
echo "[2/4] Setting up directories..."
mkdir -p ~/uisp-docker/uisp-backup
cd ~/uisp-docker

# Download files (or they should already be present)
if [ ! -f "docker-compose.yml" ]; then
    echo "[3/4] Downloading Docker Compose config..."
    # Files should be copied manually or via git
    echo "ERROR: docker-compose.yml not found. Please copy files to ~/uisp-docker/"
    exit 1
fi

echo "[3/4] Starting UISP container..."
docker compose up -d --build

echo "[4/4] Waiting for container to initialize (30 seconds)..."
sleep 30

echo ""
echo "Container status:"
docker ps | grep uisp

echo ""
echo "Installing UISP (this may take 5-10 minutes)..."
docker exec uisp bash -c "yes | curl -fsSL https://uisp.ui.com/install | bash" 2>&1 | tail -20

echo ""
echo "Restoring backup..."
if [ -f "uisp-backup/uisp-backup-*.uisp" ]; then
    docker exec uisp uisp-restore uisp-backup/uisp-backup-*.uisp
    echo "✓ Backup restored successfully"
else
    echo "⚠ No backup file found in uisp-backup/"
    echo "  To restore later, run:"
    echo "  docker exec uisp uisp-restore /backup/uisp-backup-*.uisp"
fi

echo ""
echo "=== Deployment Complete ==="
echo ""
echo "UISP is now running at:"
echo "  HTTP:  http://$(hostname -I | awk '{print $1}'):8080"
echo "  HTTPS: https://$(hostname -I | awk '{print $1}'):8443"
echo ""
echo "Container logs:"
docker compose logs uisp | tail -20

echo ""
echo "Useful commands:"
echo "  View logs:     docker compose logs -f uisp"
echo "  Restart:       docker compose restart uisp"
echo "  Stop:          docker compose down"
echo "  Shell access:  docker exec -it uisp bash"
