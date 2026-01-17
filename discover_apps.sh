#!/bin/bash

#===============================================================================
# APPLICATION DISCOVERY SCRIPT
#
# This script discovers all non-Apple applications installed on your Mac
# and generates an apps_inventory.json with download links where available.
#
# Run this BEFORE wiping your machine to create a restore list.
#===============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_FILE="$SCRIPT_DIR/apps_inventory.json"

echo "=============================================="
echo "  Application Discovery Script"
echo "=============================================="
echo ""

#===============================================================================
# Known Apple standard apps (to exclude)
#===============================================================================
APPLE_APPS="App Store.app|Automator.app|Books.app|Calculator.app|Calendar.app|Chess.app|Contacts.app|Dictionary.app|FaceTime.app|Freeform.app|Find My.app|Font Book.app|Home.app|Image Capture.app|Keynote.app|Launchpad.app|Mail.app|Maps.app|Messages.app|Mission Control.app|Music.app|News.app|Notes.app|Numbers.app|Pages.app|Photo Booth.app|Photos.app|Podcasts.app|Preview.app|QuickTime Player.app|Reminders.app|Safari.app|Shortcuts.app|Siri.app|Stickies.app|Stocks.app|System Preferences.app|System Settings.app|TextEdit.app|Time Machine.app|TV.app|Utilities|Voice Memos.app|Weather.app|iPhone Mirroring.app|Passwords.app"

#===============================================================================
# Get download link for known apps
#===============================================================================
get_download_link() {
    local app_name="$1"
    case "$app_name" in
        "Docker.app") echo "brew install --cask docker" ;;
        "VSCodium.app") echo "brew install --cask vscodium" ;;
        "Wine Stable.app") echo "brew install --cask wine-stable" ;;
        "Ableton Live 12 Suite.app") echo "https://www.ableton.com/en/shop/live/" ;;
        "Arcade.app") echo "https://output.com/products/arcade" ;;
        "Disk Drill.app") echo "https://www.cleverfiles.com/disk-drill.html" ;;
        "GPG Keychain.app") echo "https://gpgtools.org/" ;;
        "kdenlive.app") echo "https://kdenlive.org/en/download/" ;;
        "Malwarebytes.app") echo "https://www.malwarebytes.com/mac-download" ;;
        "Output Creator.app") echo "https://output.com/" ;;
        "qbittorrent.app") echo "https://www.qbittorrent.org/download" ;;
        "Steam.app") echo "https://store.steampowered.com/about/" ;;
        "Tor Browser.app") echo "https://www.torproject.org/download/" ;;
        "Trilian.app") echo "https://www.spectrasonics.net/products/trilian/" ;;
        "zoom.us.app") echo "https://zoom.us/download" ;;
        "Xcode.app") echo "mas install 497799835" ;;
        "Adobe Creative Cloud") echo "https://www.adobe.com/creativecloud/desktop-app.html" ;;
        "Adobe Media Encoder 2025") echo "https://www.adobe.com/products/media-encoder.html" ;;
        "Adobe Premiere Pro 2025") echo "https://www.adobe.com/products/premiere.html" ;;
        "Liftoff.app") echo "https://sindresorhus.com/liftoff" ;;
        "Wineskin") echo "https://github.com/Gcenx/WineskinServer" ;;
        "iZotope") echo "https://www.izotope.com/en/shop.html" ;;
        *) echo "" ;;
    esac
}

#===============================================================================
# Check if app is Apple standard
#===============================================================================
is_apple_app() {
    local app_name="$1"
    echo "$app_name" | grep -qE "^($APPLE_APPS)$"
}

#===============================================================================
# Get bundle identifier
#===============================================================================
get_bundle_id() {
    local app_path="$1"
    if [[ -f "$app_path/Contents/Info.plist" ]]; then
        defaults read "$app_path/Contents/Info.plist" CFBundleIdentifier 2>/dev/null || echo "unknown"
    else
        echo "unknown"
    fi
}

#===============================================================================
# Check if app is from Mac App Store
#===============================================================================
is_mas_app() {
    local app_path="$1"
    [[ -f "$app_path/Contents/_MASReceipt/receipt" ]]
}

#===============================================================================
# Get Homebrew cask name if available
#===============================================================================
get_brew_source() {
    local app_name="$1"
    case "$app_name" in
        "Docker.app") echo "homebrew_cask" ;;
        "VSCodium.app") echo "homebrew_cask" ;;
        "Wine Stable.app") echo "homebrew_cask" ;;
        *) echo "" ;;
    esac
}

#===============================================================================
# Main discovery
#===============================================================================
log_info "Scanning /Applications..."

# Start JSON
cat > "$OUTPUT_FILE" << EOF
{
  "generated": "$(date -Iseconds)",
  "machine": "$(hostname)",
  "apps": [
EOF

first_entry=true
app_count=0
mas_count=0
brew_count=0
manual_count=0
user_count=0

# Scan /Applications
for app_path in /Applications/*; do
    app_name=$(basename "$app_path")

    # Skip Apple standard apps
    if is_apple_app "$app_name"; then
        continue
    fi

    # Skip if it's not a directory
    if [[ ! -d "$app_path" ]]; then
        continue
    fi

    # Get app info
    bundle_id="unknown"
    if [[ "$app_name" == *.app ]]; then
        bundle_id=$(get_bundle_id "$app_path")
    fi

    # Determine source
    source_type="manual"
    download_link=$(get_download_link "$app_name")

    if [[ "$app_name" == *.app ]] && is_mas_app "$app_path"; then
        source_type="mac_app_store"
        ((mas_count++))
        if [[ -z "$download_link" ]]; then
            download_link="Search Mac App Store for: $app_name"
        fi
    elif [[ -n "$(get_brew_source "$app_name")" ]]; then
        source_type="homebrew_cask"
        ((brew_count++))
    else
        ((manual_count++))
    fi

    # Add comma if not first entry
    if [[ "$first_entry" == true ]]; then
        first_entry=false
    else
        echo "," >> "$OUTPUT_FILE"
    fi

    ((app_count++))

    # Escape special characters for JSON
    escaped_path=$(echo "$app_path" | sed 's/"/\\"/g')
    escaped_name=$(echo "$app_name" | sed 's/"/\\"/g')
    escaped_download=$(echo "$download_link" | sed 's/"/\\"/g')

    # Write JSON entry
    cat >> "$OUTPUT_FILE" << EOF
    {
      "name": "$escaped_name",
      "bundle_id": "$bundle_id",
      "source": "$source_type",
      "download": "$escaped_download",
      "path": "$escaped_path"
    }
EOF

    log_info "Found: $app_name ($source_type)"
done

# Scan ~/Applications if exists
if [[ -d "$HOME/Applications" ]]; then
    log_info "Scanning ~/Applications..."

    for app_path in "$HOME/Applications"/*; do
        [[ -e "$app_path" ]] || continue
        app_name=$(basename "$app_path")

        if [[ ! -d "$app_path" ]]; then
            continue
        fi

        bundle_id="unknown"
        if [[ "$app_name" == *.app ]]; then
            bundle_id=$(get_bundle_id "$app_path")
        fi

        download_link=$(get_download_link "$app_name")

        if [[ "$first_entry" == true ]]; then
            first_entry=false
        else
            echo "," >> "$OUTPUT_FILE"
        fi

        ((app_count++))
        ((user_count++))

        escaped_path=$(echo "$app_path" | sed 's/"/\\"/g')
        escaped_name=$(echo "$app_name" | sed 's/"/\\"/g')
        escaped_download=$(echo "$download_link" | sed 's/"/\\"/g')

        cat >> "$OUTPUT_FILE" << EOF
    {
      "name": "$escaped_name",
      "bundle_id": "$bundle_id",
      "source": "user_applications",
      "download": "$escaped_download",
      "path": "$escaped_path"
    }
EOF

        log_info "Found: $app_name (user_applications)"
    done
fi

# Close JSON
echo "" >> "$OUTPUT_FILE"
echo "  ]" >> "$OUTPUT_FILE"
echo "}" >> "$OUTPUT_FILE"

echo ""
log_success "App inventory saved to: $OUTPUT_FILE"
echo ""

# Generate summary
log_info "Summary:"
echo ""
echo "Total apps discovered: $app_count"
echo "  - Mac App Store: $mas_count"
echo "  - Homebrew Cask: $brew_count"
echo "  - Manual Install: $manual_count"
echo "  - User Applications: $user_count"
echo ""
