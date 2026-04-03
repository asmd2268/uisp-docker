# Docker Hardened Images (DHI) Migration Guide

## Current Status

The Dockerfile uses `ubuntu:22.04` as the base image. To migrate to Docker Hardened Images (DHI) on your VPS:

## Option 1: With Docker Scout (Recommended)

After deploying to your VPS, scan for vulnerabilities:

```bash
# On VPS
docker scout cves default-uisp:latest
```

This will identify any CVEs and help prioritize security patches.

## Option 2: Manual DHI Migration

If you have Docker Hub authentication on your VPS:

1. **Log in to Docker Hub** on your VPS:
   ```bash
   docker login
   # Enter your Docker Hub credentials
   ```

2. **Update Dockerfile**:
   ```dockerfile
   FROM docker/dhi:ubuntu-22.04
   ```

3. **Rebuild**:
   ```bash
   docker compose up -d --build
   ```

## Option 3: CIS Hardened Base Image

Use a CIS-hardened Ubuntu variant:

```dockerfile
FROM aquasec/aqua:latest
# Or
FROM cisecurity/cis-ubuntu-linux-22.04-benchmark:latest
```

## Security Best Practices (Without DHI)

Even with standard Ubuntu, ensure security:

1. **Scan image**:
   ```bash
   docker scout cves uisp:latest
   ```

2. **Keep base image updated**:
   ```bash
   # Rebuild periodically
   docker compose up -d --build --pull always
   ```

3. **Monitor vulnerabilities**:
   ```bash
   # Enable Docker Scout
   docker scout enable-sbom
   docker scout sbom default-uisp:latest
   ```

4. **Security scanning in CI/CD**:
   ```bash
   docker scout cves --exit-code high default-uisp:latest
   ```

## Next Steps on VPS

After deployment with current Dockerfile:

```bash
# SSH to VPS
ssh user@your-vps-ip
cd ~/uisp-docker

# Run security scan
docker scout cves default-uisp:latest

# Review results and plan DHI migration if needed
```

## Summary

- Current setup uses `ubuntu:22.04` (widely supported, well-tested)
- DHI migration requires Docker Hub authentication
- Security can be achieved through regular scanning and updates
- Deploy now, migrate to DHI later if needed

See DEPLOYMENT.md for VPS deployment instructions.
