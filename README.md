# Mac System Rebuild Kit

A comprehensive toolkit for backing up and restoring your entire macOS development environment, including terminal tools, applications, Xcode signing certificates, and configurations.

## Quick Start

### Before Wiping Your Machine

Run these scripts **in order** to back up everything:

```bash
# 1. Back up Xcode signing certificates (CRITICAL - cannot be recovered!)
./backup_xcode_signing.sh

# 2. Discover and catalog all installed applications
./discover_apps.sh

# 3. Copy this entire folder to USB/cloud storage
```

### On Your Fresh System

```bash
# 1. Install terminal tools and CLI apps
./rebuild_terminal.sh

# 2. Install GUI applications
./install_apps.sh

# 3. Import Xcode signing certificates (from backup folder)
# Double-click .p12 files or: security import cert.p12 -k ~/Library/Keychains/login.keychain-db
```

---

## What's Included

| File | Purpose |
|------|---------|
| `rebuild_terminal.sh` | Installs Homebrew, CLI tools, npm packages, Xcode |
| `discover_apps.sh` | Scans and catalogs all installed applications |
| `install_apps.sh` | Reinstalls applications from the catalog |
| `backup_xcode_signing.sh` | Backs up code signing certificates |
| `apps_inventory.json` | Auto-generated list of your applications |
| `INSTALLATION_INVENTORY.md` | Detailed inventory of all terminal tools |
| `QUICK_START.md` | Quick reference guide |

---

## Detailed Instructions

### 1. Terminal Tools (`rebuild_terminal.sh`)

Automatically installs:

**Homebrew Packages:**
- Node.js, fnm (Node version manager)
- Python 3.14, Ruby
- GitHub CLI (`gh`), Stripe CLI
- ffmpeg, tesseract, watchman
- CocoaPods, XcodeGen
- And all dependencies...

**Homebrew Casks:**
- Docker Desktop
- VSCodium
- ngrok
- Wine

**npm Global Packages:**
- Claude Code (`@anthropic-ai/claude-code`)
- Vercel CLI
- Railway CLI
- Convex
- Yarn

**Xcode:**
- Installs via Mac App Store (`mas`)
- Accepts license automatically
- Runs first launch setup

### 2. Applications (`discover_apps.sh` + `install_apps.sh`)

The discovery script catalogs:
- Mac App Store apps
- Homebrew cask apps
- Manually installed apps
- User ~/Applications

Each app is saved with:
- Bundle identifier
- Installation source
- Download link (where known)

**Your Applications:**
| App | Source | Download |
|-----|--------|----------|
| Ableton Live 12 Suite | Manual | ableton.com |
| Adobe Creative Cloud | Manual | adobe.com |
| Adobe Premiere Pro 2025 | Manual | adobe.com |
| Arcade | Manual | output.com |
| Docker | Homebrew | `brew install --cask docker` |
| GPG Keychain | Manual | gpgtools.org |
| kdenlive | Manual | kdenlive.org |
| Malwarebytes | Manual | malwarebytes.com |
| Output Creator | Manual | output.com |
| qBittorrent | Manual | qbittorrent.org |
| Steam | Manual | steampowered.com |
| Tor Browser | Manual | torproject.org |
| Trilian | Manual | spectrasonics.net |
| VSCodium | Homebrew | `brew install --cask vscodium` |
| Wine Stable | Homebrew | `brew install --cask wine-stable` |
| Xcode | App Store | `mas install 497799835` |
| Zoom | Manual | zoom.us |

### 3. Xcode Signing (`backup_xcode_signing.sh`)

**Your Certificates:**
| Type | Identity |
|------|----------|
| Development | Apple Development: Jason Kihlstadius (P5TVX6Y8T3) |
| Distribution | Apple Distribution: Jason Kihlstadius (D33FTL28LK) |

**CRITICAL:** These certificates contain private keys that **cannot be re-downloaded** from Apple. The backup script:

1. Opens Keychain Access for you to export `.p12` files
2. Backs up Xcode preferences
3. Backs up provisioning profiles (if any)
4. Creates restore instructions

**To Restore:**
1. Double-click each `.p12` file
2. Enter the password you set during export
3. Sign into Apple Developer account in Xcode

### 4. Git Configuration

The rebuild script configures git with:
```
user.name: Jason Kihlstadius
user.email: bukumentor@gmail.com
```

---

## Manual Steps After Restore

### Sign Into Services
```bash
claude              # Claude Code (Anthropic)
gh auth login       # GitHub CLI
vercel login        # Vercel
railway login       # Railway
stripe login        # Stripe
```

### Generate New SSH Keys
```bash
ssh-keygen -t ed25519 -C "bukumentor@gmail.com"
cat ~/.ssh/id_ed25519.pub  # Add to GitHub, etc.
```

### Import GPG Keys
If you backed up GPG keys, import them:
```bash
gpg --import private-key.asc
```

### Activate Software Licenses
- Ableton Live 12 Suite
- Adobe Creative Cloud
- Spectrasonics Trilian
- Output Arcade
- iZotope plugins

---

## File Structure

```
script to run to rebuild my terminal/
├── README.md                    # This file
├── QUICK_START.md              # Quick reference
├── INSTALLATION_INVENTORY.md   # Detailed tool inventory
│
├── rebuild_terminal.sh         # Main CLI installer
├── discover_apps.sh            # App discovery script
├── install_apps.sh             # App installer script
├── backup_xcode_signing.sh     # Certificate backup
│
├── apps_inventory.json         # Generated app catalog
│
└── xcode_signing_backup_*/     # Created by backup script
    ├── *.p12                   # Your exported certificates
    ├── com.apple.dt.Xcode.plist
    ├── Xcode_UserData/
    └── RESTORE_INSTRUCTIONS.md
```

---

## Customization

### Adding New Apps to Download Database

Edit `discover_apps.sh` and add to the `get_download_link()` function:

```bash
"YourApp.app") echo "https://example.com/download" ;;
```

### Adding New Homebrew Packages

Edit `rebuild_terminal.sh` and add to the `BREW_FORMULAS` or `BREW_CASKS` arrays.

### Adding New npm Packages

Edit `rebuild_terminal.sh` and add to the `NPM_GLOBALS` array.

---

## System Requirements

- macOS (tested on macOS 15+)
- Apple Silicon or Intel Mac
- Internet connection
- Apple ID (for Mac App Store apps)
- Apple Developer account (for Xcode signing)

---

## Troubleshooting

### "Command not found: brew"
Run the Homebrew installer:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Xcode signing certificate not trusted
Install Apple's intermediate certificates:
```bash
curl -O https://www.apple.com/certificateauthority/AppleWWDRCAG3.cer
curl -O https://www.apple.com/certificateauthority/DeveloperIDG2CA.cer
open AppleWWDRCAG3.cer
open DeveloperIDG2CA.cer
```

### mas install fails
Sign into the Mac App Store app first, then retry.

---

## License

Personal use. Created for Jason Kihlstadius system rebuild.

---

Generated: 2026-01-16
