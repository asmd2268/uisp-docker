# UISP Online Remote Management Setup

## What You Need

To control and host UISP devices online, you need:

1. **Public VPS with fixed IP** (for devices to connect)
2. **Domain name** (for easy access)
3. **SSL certificate** (for secure connections)
4. **Proper port forwarding** (to expose UISP)

## Architecture

```
Your Devices (WiFi/Network)
    ↓
Device Controller Protocol
    ↓
UISP Container (Port 8080/8443)
    ↓
VPS with Public IP
    ↓
Domain: uisp.yourdomain.com
    ↓
Users access remotely
```

## Setup Steps

### Step 1: Deploy on VPS (Already Done ✓)

Your `docker-compose.yml` already handles this:
- Ports: 80, 443, 8080, 8443
- Persistent volumes for data
- Systemd for reliability

### Step 2: Configure Domain & SSL

Update `docker-compose.yml` to add:
- Domain name
- Let's Encrypt SSL certificate
- Reverse proxy (nginx)

### Step 3: Device Registration

UISP devices will connect to your VPS IP/domain and register automatically.

### Step 4: Remote Access

- Access UISP web UI: `https://uisp.yourdomain.com:8443`
- Manage all devices from anywhere
- Real-time monitoring and updates

---

## What Do You Have?

Please answer:

1. **VPS already deployed?** (Yes/No)
   - If yes: What's the IP address?

2. **Do you have a domain name?** (Yes/No)
   - If yes: What is it?

3. **Ubiquiti devices ready?** (AirMAX, EdgePoint, etc.)
   - How many devices?
   - What types?

4. **Current UISP status:**
   - Is backup restore complete?
   - Does UISP web UI load?

Once you answer, I'll provide:
- Complete nginx reverse proxy config
- SSL certificate setup (Let's Encrypt)
- Device communication configuration
- Firewall rules
- Port forwarding guide

---

Let me know your current situation!
