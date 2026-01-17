# Fresh Mac Setup Instructions

Complete guide to restore your development environment on a brand new Mac.

---

## BEFORE YOU WIPE (Checklist)

### 1. Export Xcode Signing Certificates (REQUIRED)

Open **Keychain Access** and export these certificates:

```
Apple Development: Jason Kihlstadius (P5TVX6Y8T3)
Apple Distribution: Jason Kihlstadius (D33FTL28LK)
```

**Steps:**
1. Open Keychain Access (Cmd + Space, type "Keychain Access")
2. Select **login** keychain (left sidebar)
3. Click **My Certificates** (category)
4. Right-click each certificate → **Export...**
5. Format: **Personal Information Exchange (.p12)**
6. Save to: `/Users/tonyakihlstadius/xcode_signing_backup_20260116_185159/`
7. Set a password (WRITE IT DOWN!)

### 2. Copy Everything to External Drive

```bash
# Copy the project folder
cp -R "/Users/tonyakihlstadius/script to run to rebuild my terminal" /Volumes/YOUR_DRIVE/

# Copy the Xcode signing backup (with your .p12 files)
cp -R /Users/tonyakihlstadius/xcode_signing_backup_20260116_185159 /Volumes/YOUR_DRIVE/
```

### 3. Verify Before Wiping

Check that your external drive contains:
- [ ] `script to run to rebuild my terminal/` folder
- [ ] `xcode_signing_backup_*/` folder with `.p12` files inside
- [ ] Both certificates exported (Development + Distribution)

---

## ON YOUR FRESH MAC

### Step 1: Open Terminal

Press `Cmd + Space`, type "Terminal", press Enter.

### Step 2: Copy Files from External Drive

```bash
# Create a working directory
mkdir -p ~/rebuild
cd ~/rebuild

# Copy from external drive (adjust YOUR_DRIVE to your drive name)
cp -R "/Volumes/YOUR_DRIVE/script to run to rebuild my terminal/"* .
cp -R "/Volumes/YOUR_DRIVE/xcode_signing_backup_"* .

# Make scripts executable
chmod +x *.sh
```

### Step 3: Run the Main Rebuild Script

```bash
./rebuild_terminal.sh
```

This will:
- Install Xcode Command Line Tools (you'll see a popup - click Install)
- Install Homebrew
- Install all CLI tools (node, python, gh, etc.)
- Install Homebrew casks (Docker, VSCodium, etc.)
- Install Xcode from Mac App Store
- Install npm global packages (Claude Code, Vercel, etc.)
- Configure git

**Note:** You'll need to enter your Mac password for some installations.

### Step 4: Import Xcode Signing Certificates

```bash
# Find your .p12 files
ls xcode_signing_backup_*/*.p12

# Import each certificate (double-click works too)
security import xcode_signing_backup_*/*.p12 -k ~/Library/Keychains/login.keychain-db
```

When prompted, enter the password you set when exporting.

Then in Xcode:
1. Open Xcode
2. Go to **Xcode → Settings → Accounts** (Cmd + ,)
3. Click **+** → Add Apple ID
4. Sign in with your Apple Developer account
5. Verify your team appears: "Jason Kihlstadius (D33FTL28LK)"

### Step 5: Install GUI Applications

```bash
./install_apps.sh
```

This will:
- Install apps available via Homebrew (Docker, VSCodium, etc.)
- Open download pages for manual-install apps
- Show you what needs manual installation

### Step 6: Sign Into Services

```bash
# Claude Code
claude

# GitHub CLI
gh auth login

# Vercel
vercel login

# Railway
railway login

# Stripe
stripe login
```

### Step 7: Generate SSH Keys

```bash
ssh-keygen -t ed25519 -C "bukumentor@gmail.com"
cat ~/.ssh/id_ed25519.pub
```

Copy the output and add to:
- GitHub: https://github.com/settings/keys
- Any other services that need SSH

### Step 8: Complete Manual App Installations

Download and install these manually:
- **Ableton Live 12 Suite** - https://www.ableton.com/en/shop/live/
- **Adobe Creative Cloud** - https://www.adobe.com/creativecloud/desktop-app.html
- **Trilian** - https://www.spectrasonics.net/products/trilian/
- **Arcade** - https://output.com/products/arcade
- **iZotope plugins** - https://www.izotope.com/

---

## Quick Command Reference

```bash
# Full rebuild (run these in order)
./rebuild_terminal.sh      # Install all CLI tools
./install_apps.sh          # Install GUI apps

# Individual checks
brew list                  # See installed Homebrew packages
npm list -g --depth=0      # See global npm packages
security find-identity -v -p codesigning  # Check signing certs

# If something fails
brew doctor                # Diagnose Homebrew issues
xcode-select --install     # Reinstall CLI tools
```

---

## Troubleshooting

### "Command not found: brew"
Homebrew isn't in your PATH. Run:
```bash
eval "$(/opt/homebrew/bin/brew shellenv)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
```

### Xcode installation hangs
The Mac App Store download can be slow. Check progress in the App Store app.

### "No signing certificate found" in Xcode
1. Make sure you imported the .p12 files
2. Check Keychain Access → My Certificates
3. Ensure the certificate has a key icon (private key attached)

### Permission denied running scripts
```bash
chmod +x *.sh
```

---

## What Gets Installed

### Terminal Tools
- Homebrew (package manager)
- Node.js v25.x + fnm
- Python 3.14
- Ruby
- Git (configured)
- GitHub CLI
- Docker, Docker Compose
- ffmpeg, tesseract
- CocoaPods, XcodeGen
- Stripe CLI, Gemini CLI

### npm Global Packages
- Claude Code (@anthropic-ai/claude-code)
- Vercel CLI
- Railway CLI
- Convex
- Yarn

### Applications (via Homebrew)
- Docker Desktop
- VSCodium
- Wine Stable
- ngrok

### Applications (Manual)
- Xcode (App Store)
- Ableton Live 12 Suite
- Adobe Creative Cloud
- Adobe Premiere Pro 2025
- And more...

---

## Time Estimate

| Step | Duration |
|------|----------|
| Xcode CLI Tools | 2-5 min |
| Homebrew install | 2-3 min |
| Homebrew packages | 10-15 min |
| Xcode download | 15-30 min |
| npm packages | 2-3 min |
| GUI apps | 10-20 min |
| Manual apps | Varies |

**Total: ~45-90 minutes** (depending on internet speed)

---

Generated: 2026-01-16
