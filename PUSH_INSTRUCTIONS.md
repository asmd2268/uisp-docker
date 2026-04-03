# Push to GitHub - Manual Steps

## Quick Method (Copy-Paste)

### 1. Create Personal Access Token
Go to: https://github.com/settings/tokens/new

Settings:
- **Token name**: uisp-docker
- **Expiration**: 90 days
- **Scopes**: ✓ repo (all)

Click **Generate token** and copy it.

### 2. Push Code
Run this command (replace YOUR_TOKEN):

```bash
git push https://asmd2268:YOUR_TOKEN@github.com/asmd2268/uisp-docker.git main
```

Example if token is `ghp_abc123xyz`:
```bash
git push https://asmd2268:ghp_abc123xyz@github.com/asmd2268/uisp-docker.git main
```

### 3. Verify
Go to https://github.com/asmd2268/uisp-docker

Should show all your files!

---

## Alternative: Store Token Locally (Safer)

```bash
# Create ~/.netrc file (one-time)
cat > ~/.netrc << 'NETRC'
machine github.com
login asmd2268
password YOUR_TOKEN
NETRC

chmod 600 ~/.netrc

# Now just push normally
git push -u origin main
```

Replace `YOUR_TOKEN` with your actual token.

---

## Need Help?

If push fails:
1. Verify token has `repo` scope
2. Check GitHub username (asmd2268)
3. Ensure repository is public
4. Try: `git remote -v` (should show https origin)

After push succeeds:
- Go to https://github.com/asmd2268/uisp-docker
- All files will be there!
