# Quick Start Guide

## BEFORE You Wipe Your Machine

**Run the backup script to save your Xcode signing certificates:**
```bash
./backup_xcode_signing.sh
```

This will:
1. Guide you through exporting your `.p12` certificate files (with private keys)
2. Back up provisioning profiles
3. Back up Xcode preferences
4. Create restore instructions

**Your certificates:**
- Apple Development: Jason Kihlstadius (P5TVX6Y8T3)
- Apple Distribution: Jason Kihlstadius (D33FTL28LK)

⚠️ **WARNING:** The private keys in these certificates CANNOT be re-downloaded from Apple. If you lose them, you must revoke and regenerate all certificates.

---

## How to Use on a Fresh System

### Option 1: Run the Full Script

1. Copy these files to your new system (via USB, cloud, etc.)
2. Open Terminal
3. Run:
   ```bash
   cd "/path/to/script to run to rebuild my terminal"
   ./rebuild_terminal.sh
   ```

### Option 2: Manual Step-by-Step

If you prefer to run things manually or the script fails, here are the key commands:

#### 1. Install Xcode Command Line Tools
```bash
xcode-select --install
```

#### 2. Install Homebrew
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

For Apple Silicon, add to PATH:
```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

#### 3. Install Main Tools
```bash
# Add taps
brew tap stripe/stripe-cli

# Install core tools (including mas for App Store)
brew install node fnm gh watchman cocoapods xcodegen ffmpeg tesseract stripe gemini-cli mas

# Install casks
brew install --cask docker-desktop ngrok vscodium
```

#### 4. Install Xcode
```bash
# Install Xcode from Mac App Store (requires Apple ID sign-in)
mas install 497799835

# Accept license and run first launch
sudo xcodebuild -license accept
sudo xcodebuild -runFirstLaunch
```

#### 5. Install npm Global Packages
```bash
npm install -g @anthropic-ai/claude-code @railway/cli convex vercel yarn
```

#### 6. Configure Git
```bash
git config --global user.name "Jason Kihlstadius"
git config --global user.email "bukumentor@gmail.com"
```

---

## Things to Do Manually After

1. **Xcode**: Open Xcode and complete any remaining setup prompts

2. **Restore Xcode Signing Certificates**:
   ```bash
   # Double-click each .p12 file from your backup to import
   # Or use command line:
   security import your-cert.p12 -k ~/Library/Keychains/login.keychain-db
   ```
   Then in Xcode:
   - Go to Xcode → Settings → Accounts
   - Sign in with your Apple ID
   - Verify certificates: `security find-identity -v -p codesigning`

3. **Docker Desktop**: Open and complete first-time setup

4. **Claude Code**: Run `claude` and authenticate with your Anthropic account

5. **Generate SSH Keys**:
   ```bash
   ssh-keygen -t ed25519 -C "your-email@example.com"
   ```

6. **Generate/Import GPG Keys** (if needed)

7. **Login to services**:
   - `claude` (Claude Code - Anthropic)
   - `gh auth login` (GitHub)
   - `vercel login` (Vercel)
   - `railway login` (Railway)
   - `stripe login` (Stripe)

---

## Files in This Directory

| File | Purpose |
|------|---------|
| `backup_xcode_signing.sh` | **RUN FIRST** - Backs up Xcode certificates before wiping |
| `rebuild_terminal.sh` | Main automated installation script |
| `INSTALLATION_INVENTORY.md` | Complete list of all discovered installations |
| `QUICK_START.md` | This file - quick reference guide |
