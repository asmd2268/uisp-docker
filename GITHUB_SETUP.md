# GitHub Upload Instructions

## Step 1: Create GitHub Repository

1. Go to https://github.com/new
2. Create new repository:
   - **Name**: `uisp-docker`
   - **Description**: `Docker Compose deployment for UISP with backup restoration`
   - **Public** (for Vercel hosting)
   - **Initialize without README** (we have one)
   - Click **Create Repository**

## Step 2: Push to GitHub

Copy and run these commands in your terminal:

```bash
cd ~/uisp-docker  # or your project directory
git remote add origin https://github.com/YOUR_USERNAME/uisp-docker.git
git branch -M main
git push -u origin main
```

Replace `YOUR_USERNAME` with your GitHub username.

## Step 3: Deploy to Vercel

### Option A: Vercel Dashboard (Easiest)

1. Go to https://vercel.com/new
2. **Import Git Repository**
3. Search for and select `uisp-docker`
4. Configure:
   - **Framework**: Other
   - **Build Command**: (leave empty)
   - **Output Directory**: (leave empty)
5. Click **Deploy**

### Option B: Vercel CLI

```bash
# Install Vercel CLI
npm i -g vercel

# Deploy
cd ~/uisp-docker
vercel --prod
```

## Step 4: Configure Vercel

After deployment, your repository will be hosted at:
```
https://uisp-docker.vercel.app
```

You can also add a custom domain in Vercel dashboard.

## Step 5: Add Backup File (Optional)

If you want to version your backup in git (not recommended for large files):

```bash
# Compress backup
gzip -c uisp-backup/uisp-backup-*.uisp > uisp-backup/backup.uisp.gz

# Add to git
git add uisp-backup/backup.uisp.gz
git commit -m "Add compressed backup file"
git push
```

**Note**: Backups are large. Better to:
1. Host backup separately (AWS S3, Dropbox, etc.)
2. Document backup location in deployment guide
3. Update `deploy.sh` to download from external URL

## Verify Deployment

After Vercel deployment:
1. Visit `https://uisp-docker.vercel.app`
2. Should show your README.md
3. All files accessible for download

## GitHub Repository Layout

```
uisp-docker/
├── README.md                    # Main guide
├── DEPLOYMENT.md               # Full deployment guide
├── DHI_MIGRATION.md            # Security hardening
├── Dockerfile                  # Container image
├── docker-compose.yml          # Orchestration
├── deploy.sh                   # Automated deployment
├── package.json                # Metadata
├── vercel.json                 # Vercel config
├── .gitignore                  # Ignore rules
└── uisp-backup/               # Backup directory (empty in repo)
    └── .gitkeep               # Placeholder
```

## Usage After Deployment

Users clone from GitHub:
```bash
git clone https://github.com/YOUR_USERNAME/uisp-docker.git
cd uisp-docker
cp /path/to/your/backup uisp-backup/
./deploy.sh
```

---

Complete these steps to host on GitHub and Vercel!
