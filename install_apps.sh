#!/bin/bash

#===============================================================================
# APPLICATION INSTALL SCRIPT
#
# This script installs applications from the apps_inventory.json
# Run this AFTER running rebuild_terminal.sh on your new machine.
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

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INVENTORY_FILE="$SCRIPT_DIR/apps_inventory.json"

echo "=============================================="
echo "  Application Install Script"
echo "=============================================="
echo ""

if [[ ! -f "$INVENTORY_FILE" ]]; then
    log_error "apps_inventory.json not found!"
    log_error "Run discover_apps.sh first on your old machine."
    exit 1
fi

# Check for jq
if ! command -v jq &>/dev/null; then
    log_info "Installing jq for JSON parsing..."
    brew install jq
fi

#===============================================================================
# Install Homebrew Cask Apps
#===============================================================================
echo ""
echo "=============================================="
echo "  HOMEBREW CASK APPS (Automatic)"
echo "=============================================="
echo ""

log_info "Installing apps available via Homebrew Cask..."

# Docker
if jq -e '.apps[] | select(.name == "Docker.app")' "$INVENTORY_FILE" &>/dev/null; then
    log_info "Installing Docker Desktop..."
    brew install --cask docker || log_warning "Docker may already be installed"
fi

# VSCodium
if jq -e '.apps[] | select(.name == "VSCodium.app")' "$INVENTORY_FILE" &>/dev/null; then
    log_info "Installing VSCodium..."
    brew install --cask vscodium || log_warning "VSCodium may already be installed"
fi

# Wine
if jq -e '.apps[] | select(.name == "Wine Stable.app")' "$INVENTORY_FILE" &>/dev/null; then
    log_info "Installing Wine..."
    brew install --cask wine-stable || log_warning "Wine may already be installed"
fi

# Additional Homebrew casks that might be useful
OPTIONAL_CASKS=(
    "qbittorrent:qbittorrent.app"
    "kdenlive:kdenlive.app"
    "gpg-suite:GPG Keychain.app"
    "steam:Steam.app"
    "zoom:zoom.us.app"
    "tor-browser:Tor Browser.app"
)

for cask_mapping in "${OPTIONAL_CASKS[@]}"; do
    cask_name="${cask_mapping%%:*}"
    app_name="${cask_mapping##*:}"

    if jq -e ".apps[] | select(.name == \"$app_name\")" "$INVENTORY_FILE" &>/dev/null; then
        log_info "Installing $app_name via Homebrew..."
        brew install --cask "$cask_name" 2>/dev/null || log_warning "$cask_name may need manual install"
    fi
done

log_success "Homebrew cask apps installed"

#===============================================================================
# Mac App Store Apps
#===============================================================================
echo ""
echo "=============================================="
echo "  MAC APP STORE APPS"
echo "=============================================="
echo ""

# Check for mas (Mac App Store CLI)
if ! command -v mas &>/dev/null; then
    log_info "Installing mas (Mac App Store CLI)..."
    brew install mas
fi

log_info "You need to sign into the Mac App Store first."
log_info "Opening App Store..."
open -a "App Store"
echo ""
read -p "Press Enter after signing into the App Store..."

# Xcode
if jq -e '.apps[] | select(.name == "Xcode.app")' "$INVENTORY_FILE" &>/dev/null; then
    log_info "Installing Xcode from Mac App Store..."
    log_warning "This is a large download and may take a while..."
    mas install 497799835 || log_warning "Xcode install failed - try manually from App Store"
fi

# Pages (if was installed)
if jq -e '.apps[] | select(.name == "Pages.app")' "$INVENTORY_FILE" &>/dev/null; then
    log_info "Installing Pages..."
    mas install 409201541 || log_warning "Pages install failed"
fi

log_success "Mac App Store apps processed"

#===============================================================================
# Manual Install Apps - Show Instructions
#===============================================================================
echo ""
echo "=============================================="
echo "  MANUAL INSTALL REQUIRED"
echo "=============================================="
echo ""
log_warning "The following apps require manual download and installation:"
echo ""

# Extract manual apps and show download links
jq -r '.apps[] | select(.source == "manual") | "  \(.name)\n    → \(.download)\n"' "$INVENTORY_FILE"

echo ""
echo "=============================================="
echo "  OPENING DOWNLOAD PAGES"
echo "=============================================="
echo ""
log_info "Opening download pages in your browser..."

# Open download URLs for manual apps
declare -A DIRECT_URLS=(
    ["Ableton Live 12 Suite.app"]="https://www.ableton.com/en/shop/live/"
    ["Arcade.app"]="https://output.com/products/arcade"
    ["Disk Drill.app"]="https://www.cleverfiles.com/disk-drill.html"
    ["GPG Keychain.app"]="https://gpgtools.org/"
    ["Malwarebytes.app"]="https://www.malwarebytes.com/mac-download"
    ["Output Creator.app"]="https://output.com/"
    ["Trilian.app"]="https://www.spectrasonics.net/products/trilian/"
    ["Adobe Creative Cloud"]="https://www.adobe.com/creativecloud/desktop-app.html"
)

for app_name in "${!DIRECT_URLS[@]}"; do
    if jq -e ".apps[] | select(.name == \"$app_name\")" "$INVENTORY_FILE" &>/dev/null; then
        url="${DIRECT_URLS[$app_name]}"
        log_info "Opening: $app_name"
        open "$url" 2>/dev/null || true
        sleep 1
    fi
done

#===============================================================================
# Summary
#===============================================================================
echo ""
echo "=============================================="
echo "  Installation Summary"
echo "=============================================="
echo ""
log_success "Automatic installations complete!"
echo ""
log_info "Manual steps remaining:"
echo "  1. Download and install apps from the opened browser tabs"
echo "  2. Sign into your accounts (Adobe, Steam, etc.)"
echo "  3. Restore any license keys or activate subscriptions"
echo "  4. For audio plugins (iZotope, Spectrasonics), use their installers"
echo ""
log_info "Apps requiring licenses/subscriptions:"
echo "  - Ableton Live 12 Suite (music production)"
echo "  - Adobe Creative Cloud (Premiere, Media Encoder)"
echo "  - Trilian (bass virtual instrument)"
echo "  - Arcade (loop/sample plugin)"
echo "  - iZotope plugins (audio processing)"
echo ""
