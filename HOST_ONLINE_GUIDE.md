# Host UISP Online - Complete Guide

## What You Need

To make your local Ubuntu machine accessible from the internet, you need:

### 1. **Internet Connection with Public IP**
- Your ISP should give you a public IP (not always)
- Check: https://whatismyipaddress.com/
- Note: Most home ISPs use dynamic IPs (changes daily)

### 2. **Domain Name** (almftres.uisp.com ✓ You have this!)
- Points to your public IP
- Update DNS when IP changes

### 3. **Port Forwarding**
- Forward internet traffic (80, 443) to 192.168.64.2
- Done in your router/modem settings

### 4. **Dynamic DNS (If IP changes)**
- Automatically updates DNS when IP changes
- Services: Duck DNS, NoIP, Cloudflare

---

## Step 1: Find Your Public IP

Run on your Mac:
```bash
curl ifconfig.me
```

Example output: `203.45.67.89`

**This is your public IP** (may change daily if dynamic)

---

## Step 2: Check if Port 80/443 are Accessible

From your Mac, test:
```bash
# Replace with your public IP
curl -I http://YOUR_PUBLIC_IP/
curl -I https://YOUR_PUBLIC_IP:8443/
```

If they connect, good! If not, firewall is blocking.

---

## Step 3: Port Forwarding Setup

You need to **forward ports from your router to 192.168.64.2**

### Get into Router Settings:
```
1. Open browser: http://192.168.1.1 or http://192.168.0.1
2. Login (check router sticker for username/password)
3. Find "Port Forwarding" (name varies by router)
4. Add port forward rule:
   - External Port: 80 → Internal IP: 192.168.64.2 → Internal Port: 80
   - External Port: 443 → Internal IP: 192.168.64.2 → Internal Port: 443
   - External Port: 8443 → Internal IP: 192.168.64.2 → Internal Port: 8443
5. Save and apply
```

### Common Router Login IPs:
- TP-Link: `192.168.0.1`
- Netgear: `192.168.1.1`
- ASUS: `192.168.1.1`
- Linksys: `192.168.1.1`

---

## Step 4: Update DNS (almftres.uisp.com)

You need to point your domain to your **public IP**:

### If using Ubiquiti's DNS:
```
1. Go to almftres.uisp.com DNS provider
2. Update A record to your public IP
3. Example:
   - Type: A
   - Name: almftres.uisp.com
   - Value: 203.45.67.89 (your public IP)
4. Save (may take 5-30 minutes to propagate)
```

### Check DNS is working:
```bash
nslookup almftres.uisp.com
# Should show your public IP
```

---

## Step 5: Handle Dynamic IP (If ISP Changes IP)

Most home ISPs change your public IP daily/weekly.

### Solution: Use Dynamic DNS

**Option A: Cloudflare DDNS**
```bash
# On Ubuntu 192.168.64.2:
sudo apt-get install ddclient

# Edit config:
sudo nano /etc/ddclient/ddclient.conf

# Add:
protocol=cloudflare
zone=almftres.uisp.com
ttl=1
password=YOUR_CLOUDFLARE_API_TOKEN
ssl=yes
almftres.uisp.com
```

**Option B: Duck DNS (Free & Easy)**
```bash
# Visit: https://www.duckdns.org
# Create account
# Get token and domain
# Run on Ubuntu every 5 minutes to update IP:

*/5 * * * * curl "https://www.duckdns.org/update?domains=YOUR_DOMAIN&token=YOUR_TOKEN"
```

**Option C: AWS Route 53 / Azure DNS**
- More complex but reliable
- Automatic IP updates

---

## Step 6: Firewall Configuration

Make sure Ubuntu's firewall allows ports:

```bash
# SSH to Ubuntu 192.168.64.2
ssh user@192.168.64.2

# Allow HTTP
sudo ufw allow 80/tcp

# Allow HTTPS
sudo ufw allow 443/tcp

# Allow UISP direct access
sudo ufw allow 8443/tcp

# Enable firewall
sudo ufw enable

# Check status
sudo ufw status
```

---

## Step 7: Test Everything

From your Mac:

```bash
# Test public IP access
curl -I http://YOUR_PUBLIC_IP/
curl -k https://YOUR_PUBLIC_IP:8443/

# Test domain access
curl -I http://almftres.uisp.com/
curl -k https://almftres.uisp.com:8443/

# Test from phone (different network)
# Open in browser: https://almftres.uisp.com
```

---

## Complete Setup Commands for Ubuntu 192.168.64.2

SSH into Ubuntu and run:

```bash
# 1. Navigate to project
cd ~/uisp-docker

# 2. Update code
git pull origin main

# 3. Rebuild containers
docker compose down
docker compose up -d --build

# 4. Restart nginx
docker compose restart nginx

# 5. Check ports
sudo netstat -tlnp | grep -E ":80|:443|:8443"

# 6. Configure firewall
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 8443/tcp
sudo ufw enable

# 7. View logs
docker compose logs nginx
```

---

## Checklist

- [ ] Find your public IP: `curl ifconfig.me`
- [ ] Configure router port forwarding (80, 443, 8443 → 192.168.64.2)
- [ ] Update almftres.uisp.com DNS to public IP
- [ ] Enable firewall on Ubuntu (ufw)
- [ ] Test: `curl https://almftres.uisp.com/`
- [ ] Set up Dynamic DNS if IP changes frequently
- [ ] Open browser: https://almftres.uisp.com/
- [ ] Login with backup credentials
- [ ] Add your Ubiquiti devices

---

## Troubleshooting

**Can't access from internet:**
1. Check port forwarding in router
2. Check firewall allows ports
3. Verify DNS points to correct IP
4. Check public IP hasn't changed

**DNS not updating:**
1. Clear browser cache: Cmd+Shift+Delete
2. Wait 5-30 minutes for propagation
3. Check: `nslookup almftres.uisp.com`

**Port forwarding not working:**
1. Confirm 192.168.64.2 is correct internal IP
2. Restart router after changing settings
3. Test from another network (phone hotspot)

---

## Security Notes

⚠️ **Warning**: Opening ports to internet is a security risk

**Recommendations:**
1. ✓ Use strong UISP password
2. ✓ Enable HTTPS (already done with SSL cert)
3. ✓ Use firewall rules to limit access
4. ✓ Keep Ubuntu updated: `sudo apt update && sudo apt upgrade`
5. ✓ Monitor logs: `docker compose logs -f`
6. ✓ Consider VPN for remote access (safer)

---

Let me know your public IP and I'll help with the next steps!
