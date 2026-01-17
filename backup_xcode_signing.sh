#!/bin/bash

#===============================================================================
# XCODE SIGNING BACKUP SCRIPT
#
# This script backs up your code signing certificates and private keys.
# RUN THIS BEFORE WIPING YOUR MACHINE!
#
# The exported .p12 files contain your private keys which CANNOT be
# re-downloaded from Apple. Without these, you'll need to revoke and
# regenerate all certificates.
#===============================================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

echo "=============================================="
echo "  Xcode Signing Backup Script"
echo "=============================================="
echo ""

# Create backup directory
BACKUP_DIR="$HOME/xcode_signing_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

log_info "Backup directory: $BACKUP_DIR"
echo ""

#===============================================================================
# STEP 1: List current signing identities
#===============================================================================
log_info "Your current code signing identities:"
echo ""
security find-identity -v -p codesigning
echo ""

#===============================================================================
# STEP 2: Export certificates (interactive - requires password)
#===============================================================================
echo "=============================================="
echo "  CERTIFICATE EXPORT (Manual Step Required)"
echo "=============================================="
echo ""
log_warning "You must manually export your certificates with private keys!"
echo ""
echo "Follow these steps in Keychain Access:"
echo ""
echo "1. Open Keychain Access (Cmd+Space, type 'Keychain Access')"
echo "2. Select 'login' keychain on the left"
echo "3. Click 'My Certificates' category"
echo "4. Find these certificates:"
echo "   - Apple Development: Jason Kihlstadius (P5TVX6Y8T3)"
echo "   - Apple Distribution: Jason Kihlstadius (D33FTL28LK)"
echo ""
echo "5. For EACH certificate:"
echo "   a. Right-click → 'Export...'"
echo "   b. Choose format: 'Personal Information Exchange (.p12)'"
echo "   c. Save to: $BACKUP_DIR"
echo "   d. Set a STRONG password (you'll need this to import later)"
echo "   e. Enter your Mac login password when prompted"
echo ""
log_warning "IMPORTANT: Remember the .p12 passwords! Write them down securely."
echo ""

# Open Keychain Access for the user
read -p "Press Enter to open Keychain Access..."
open -a "Keychain Access"

# Open backup folder
open "$BACKUP_DIR"

echo ""
log_info "Waiting for you to export certificates..."
read -p "Press Enter when you've finished exporting all certificates..."

#===============================================================================
# STEP 3: Backup provisioning profiles
#===============================================================================
log_info "Backing up provisioning profiles..."

PROFILES_DIR="$HOME/Library/MobileDevice/Provisioning Profiles"
if [[ -d "$PROFILES_DIR" ]] && [[ -n "$(ls -A "$PROFILES_DIR" 2>/dev/null)" ]]; then
    cp -R "$PROFILES_DIR" "$BACKUP_DIR/Provisioning_Profiles"
    PROFILE_COUNT=$(ls -1 "$BACKUP_DIR/Provisioning_Profiles" | wc -l | tr -d ' ')
    log_success "Backed up $PROFILE_COUNT provisioning profiles"
else
    log_info "No provisioning profiles found (Xcode will re-download them automatically)"
    mkdir -p "$BACKUP_DIR/Provisioning_Profiles"
    echo "No profiles found - Xcode manages these automatically" > "$BACKUP_DIR/Provisioning_Profiles/README.txt"
fi

#===============================================================================
# STEP 4: Backup Xcode preferences and account info
#===============================================================================
log_info "Backing up Xcode preferences..."

# Xcode preferences
if [[ -f "$HOME/Library/Preferences/com.apple.dt.Xcode.plist" ]]; then
    cp "$HOME/Library/Preferences/com.apple.dt.Xcode.plist" "$BACKUP_DIR/"
    log_success "Backed up Xcode preferences"
fi

# Xcode user data (keybindings, themes, snippets)
if [[ -d "$HOME/Library/Developer/Xcode/UserData" ]]; then
    cp -R "$HOME/Library/Developer/Xcode/UserData" "$BACKUP_DIR/Xcode_UserData"
    log_success "Backed up Xcode user data (keybindings, snippets, themes)"
fi

#===============================================================================
# STEP 5: Create restore instructions
#===============================================================================
cat > "$BACKUP_DIR/RESTORE_INSTRUCTIONS.md" << 'EOF'
# Xcode Signing Restore Instructions

## On Your New Machine

### Step 1: Install Xcode
Run the main rebuild script or install from App Store.

### Step 2: Import Certificates
1. Double-click each `.p12` file in this backup folder
2. Enter the password you set when exporting
3. When prompted, add to "login" keychain
4. Verify import: `security find-identity -v -p codesigning`

### Step 3: Sign into Apple Developer Account
1. Open Xcode
2. Go to Xcode → Settings → Accounts (Cmd+,)
3. Click "+" and sign in with your Apple ID
4. Your team "Jason Kihlstadius (D33FTL28LK)" should appear

### Step 4: Provisioning Profiles
Xcode will automatically download provisioning profiles when you:
- Open a project that needs signing
- Or manually: Xcode → Settings → Accounts → Select team → "Download Manual Profiles"

### Step 5: Restore Xcode Preferences (Optional)
Copy these back if you want your old settings:
- `com.apple.dt.Xcode.plist` → `~/Library/Preferences/`
- `Xcode_UserData/` → `~/Library/Developer/Xcode/UserData/`

## Troubleshooting

### "No signing certificate found"
- Make sure you imported the .p12 files
- Check Keychain Access → "My Certificates"
- The certificate should show a disclosure triangle with a private key inside

### "Certificate not trusted"
- You may need to install Apple's intermediate certificates
- Download from: https://www.apple.com/certificateauthority/
- Install: AppleWWDRCAG3.cer and DeveloperIDG2CA.cer

### Need to revoke and regenerate?
If you lost your .p12 files:
1. Go to https://developer.apple.com/account/resources/certificates
2. Revoke old certificates
3. Create new ones in Xcode (Xcode will generate new private keys)
EOF

log_success "Created restore instructions"

#===============================================================================
# STEP 6: Summary
#===============================================================================
echo ""
echo "=============================================="
echo "  Backup Complete!"
echo "=============================================="
echo ""
log_info "Backup location: $BACKUP_DIR"
echo ""
echo "Contents:"
ls -la "$BACKUP_DIR"
echo ""
log_warning "IMPORTANT REMINDERS:"
echo "1. Verify .p12 files are in the backup folder"
echo "2. Store the backup securely (USB drive, encrypted cloud, etc.)"
echo "3. Remember your .p12 passwords!"
echo "4. These private keys CANNOT be recovered from Apple"
echo ""

# Check if any .p12 files were exported
P12_COUNT=$(ls -1 "$BACKUP_DIR"/*.p12 2>/dev/null | wc -l | tr -d ' ')
if [[ "$P12_COUNT" -eq 0 ]]; then
    log_error "WARNING: No .p12 files found in backup folder!"
    log_error "Did you export your certificates from Keychain Access?"
else
    log_success "Found $P12_COUNT .p12 certificate file(s)"
fi
