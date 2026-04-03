#!/bin/bash
# Run these commands on your Mac Terminal to fix port 8443 on the VPS
# Replace 'user' with your actual VPS username if different

VPS_USER="user"
VPS_IP="192.168.64.2"

echo "========================================="
echo "Fixing UISP Port 8443 on VPS"
echo "VPS: $VPS_IP"
echo "========================================="
echo ""

# Step 1: Navigate and update
echo "[1/10] Pulling latest changes from GitHub..."
ssh $VPS_USER@$VPS_IP 'cd ~/uisp-docker && git pull origin main'
echo "✓ Done"
echo ""

# Step 2: Stop containers
echo "[2/10] Stopping containers..."
ssh $VPS_USER@$VPS_IP 'cd ~/uisp-docker && docker compose down'
echo "✓ Done"
echo ""

# Step 3: Rebuild and start
echo "[3/10] Rebuilding and starting containers..."
ssh $VPS_USER@$VPS_IP 'cd ~/uisp-docker && docker compose up -d --build'
echo "✓ Done"
echo ""

# Step 4: Restart nginx
echo "[4/10] Restarting nginx..."
ssh $VPS_USER@$VPS_IP 'cd ~/uisp-docker && docker compose restart nginx'
echo "✓ Done"
echo ""

# Step 5: Wait
echo "[5/10] Waiting for containers to stabilize..."
sleep 5
echo "✓ Done"
echo ""

# Step 6: Check ports
echo "[6/10] Checking if ports 80, 443, 8443 are listening..."
ssh $VPS_USER@$VPS_IP 'sudo netstat -tlnp | grep -E ":80|:443|:8443"'
echo ""

# Step 7: Test HTTP redirect
echo "[7/10] Testing HTTP redirect..."
ssh $VPS_USER@$VPS_IP 'curl -I http://192.168.64.2/ 2>/dev/null | head -3'
echo ""

# Step 8: Test HTTPS on 8443
echo "[8/10] Testing HTTPS on port 8443..."
ssh $VPS_USER@$VPS_IP 'curl -k https://192.168.64.2:8443/ 2>/dev/null | head -5'
echo ""

# Step 9: Test domain HTTPS
echo "[9/10] Testing domain HTTPS..."
ssh $VPS_USER@$VPS_IP 'curl -k https://almftres.uisp.com/ 2>/dev/null | head -5'
echo ""

# Step 10: Check container status
echo "[10/10] Container status..."
ssh $VPS_USER@$VPS_IP 'cd ~/uisp-docker && docker compose ps'
echo ""

echo "========================================="
echo "✓ All steps complete!"
echo "========================================="
echo ""
echo "Access points:"
echo "  ✓ https://192.168.64.2/ (HTTP → HTTPS)"
echo "  ✓ https://192.168.64.2:8443/ (Direct HTTPS)"
echo "  ✓ https://almftres.uisp.com/ (Domain)"
echo ""
