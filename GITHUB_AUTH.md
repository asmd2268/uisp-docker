# GitHub Authentication

## Option 1: Personal Access Token (Recommended)

### Step 1: Create Token on GitHub
1. Go to https://github.com/settings/tokens/new
2. Click **Generate new token (classic)**
3. Set:
   - **Token name**: uisp-docker
   - **Expiration**: 90 days
   - **Scopes**: Check `repo` (all)
4. Click **Generate token**
5. **Copy the token** (you won't see it again)

### Step 2: Use Token to Push

```bash
git push -u origin main
```

When prompted:
- **Username**: `asmd2268`
- **Password**: Paste your token

Or use this one-liner:

```bash
git push https://asmd2268:YOUR_TOKEN@github.com/asmd2268/uisp-docker.git main
```

Replace `YOUR_TOKEN` with the token you generated.

---

## Option 2: SSH Key (More Secure)

### Step 1: Generate SSH Key
```bash
ssh-keygen -t ed25519 -C "your@email.com"
# Press Enter for all prompts (use defaults)
```

### Step 2: Add Key to GitHub
```bash
cat ~/.ssh/id_ed25519.pub
```
Copy the output → Go to https://github.com/settings/ssh → Click "New SSH key" → Paste

### Step 3: Change Remote URL
```bash
git remote remove origin
git remote add origin git@github.com:asmd2268/uisp-docker.git
git push -u origin main
```

---

## Option 3: GitHub CLI (Easiest)

```bash
# Install GitHub CLI
brew install gh  # macOS
# or use apt-get/yum for Linux

# Authenticate
gh auth login

# Push (automatic authentication)
git push -u origin main
```

---

Choose one option above!
