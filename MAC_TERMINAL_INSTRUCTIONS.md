# Run UISP Fix on Mac Terminal

## Option 1: Run All Commands at Once (Easiest)

Open Mac Terminal and run:

```bash
cd ~/uisp-docker
chmod +x mac-fix-vps.sh
./mac-fix-vps.sh
```

This runs all 10 steps automatically via SSH to your VPS.

---

## Option 2: Run Commands Individually on Mac

Open Mac Terminal and run each command:

### Command 1: Pull latest changes
```bash
ssh user@192.168.64.2 'cd ~/uisp-docker && git pull origin main'
```

### Command 2: Stop containers
```bash
ssh user@192.168.64.2 'cd ~/uisp-docker && docker compose down'
```

### Command 3: Rebuild and start
```bash
ssh user@192.168.64.2 'cd ~/uisp-docker && docker compose up -d --build'
```

### Command 4: Restart nginx
```bash
ssh user@192.168.64.2 'cd ~/uisp-docker && docker compose restart nginx'
```

### Command 5: Check ports
```bash
ssh user@192.168.64.2 'sudo netstat -tlnp | grep -E ":80|:443|:8443"'
```

### Command 6: Test HTTP
```bash
ssh user@192.168.64.2 'curl -I http://192.168.64.2/'
```

### Command 7: Test HTTPS 8443
```bash
ssh user@192.168.64.2 'curl -k https://192.168.64.2:8443/'
```

### Command 8: Test domain HTTPS
```bash
ssh user@192.168.64.2 'curl -k https://almftres.uisp.com/'
```

### Command 9: Check containers
```bash
ssh user@192.168.64.2 'cd ~/uisp-docker && docker compose ps'
```

### Command 10: View logs
```bash
ssh user@192.168.64.2 'cd ~/uisp-docker && docker compose logs nginx'
```

---

## Option 3: Copy-Paste All Commands

Open Mac Terminal and paste this entire block:

```bash
echo "Starting UISP fix..." && \
ssh user@192.168.64.2 'cd ~/uisp-docker && git pull origin main' && \
ssh user@192.168.64.2 'cd ~/uisp-docker && docker compose down' && \
ssh user@192.168.64.2 'cd ~/uisp-docker && docker compose up -d --build' && \
ssh user@192.168.64.2 'cd ~/uisp-docker && docker compose restart nginx' && \
sleep 5 && \
echo "Checking ports..." && \
ssh user@192.168.64.2 'sudo netstat -tlnp | grep -E ":80|:443|:8443"' && \
echo "Testing HTTP..." && \
ssh user@192.168.64.2 'curl -I http://192.168.64.2/' && \
echo "Testing HTTPS 8443..." && \
ssh user@192.168.64.2 'curl -k https://192.168.64.2:8443/ | head -5' && \
echo "All done!"
```

---

## Prerequisites

Before running any command, make sure:

1. You have SSH access to VPS:
   ```bash
   ssh user@192.168.64.2
   ```
   (Should connect without errors)

2. Replace `user` with your actual VPS username if different

3. SSH keys are set up (no password prompt)

---

## Expected Output

After running commands, you should see:

✓ Port 80 listening
✓ Port 443 listening  
✓ Port 8443 listening

Then:

✓ HTTP test shows redirect
✓ HTTPS 8443 test shows UISP login page
✓ Domain HTTPS test shows UISP login page

---

## If SSH prompts for password

Add `-o ConnectTimeout=5` to SSH commands:

```bash
ssh -o ConnectTimeout=5 user@192.168.64.2 'cd ~/uisp-docker && git pull origin main'
```

Or set up SSH key authentication (no password):
```bash
ssh-copy-id -i ~/.ssh/id_rsa.pub user@192.168.64.2
```

---

## Troubleshooting

**Command not found:**
```bash
which ssh  # Check if SSH installed
```

**Connection refused:**
```bash
ping 192.168.64.2  # Check VPS is reachable
```

**Permission denied (publickey):**
```bash
ssh-add ~/.ssh/id_rsa  # Add SSH key to agent
```

---

## Next Steps

Once all ports work:

1. Open browser: https://192.168.64.2:8443/
2. Or: https://almftres.uisp.com/
3. Login with your backup credentials
4. Add your Ubiquiti devices

Done! 🎉
