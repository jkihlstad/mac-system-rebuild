#!/bin/bash

#===============================================================================
# TERMINAL ENVIRONMENT REBUILD SCRIPT
# Generated: 2026-01-16
#
# This script will reinstall all your terminal tools and configurations
# Run this on a fresh macOS system to restore your development environment
#===============================================================================

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Check if running on macOS
if [[ "$(uname)" != "Darwin" ]]; then
    log_error "This script is designed for macOS only"
    exit 1
fi

echo "=============================================="
echo "  Terminal Environment Rebuild Script"
echo "=============================================="
echo ""

#===============================================================================
# SECTION 1: XCODE COMMAND LINE TOOLS
#===============================================================================
log_info "Checking Xcode Command Line Tools..."

if ! xcode-select -p &>/dev/null; then
    log_info "Installing Xcode Command Line Tools..."
    xcode-select --install
    echo "Please complete the Xcode installation and run this script again."
    exit 0
else
    log_success "Xcode Command Line Tools already installed"
fi

#===============================================================================
# SECTION 2: HOMEBREW
#===============================================================================
log_info "Checking Homebrew..."

if ! command -v brew &>/dev/null; then
    log_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for Apple Silicon
    if [[ $(uname -m) == "arm64" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    log_success "Homebrew already installed"
fi

# Update Homebrew
log_info "Updating Homebrew..."
brew update

#===============================================================================
# SECTION 3: HOMEBREW TAPS
#===============================================================================
log_info "Adding Homebrew taps..."

BREW_TAPS=(
    "stripe/stripe-cli"
)

for tap in "${BREW_TAPS[@]}"; do
    log_info "Tapping $tap..."
    brew tap "$tap" || log_warning "Failed to tap $tap"
done

log_success "Homebrew taps configured"

#===============================================================================
# SECTION 4: HOMEBREW FORMULAS (Core packages you explicitly use)
#===============================================================================
log_info "Installing Homebrew formulas..."

# These are the primary tools - dependencies will be installed automatically
BREW_FORMULAS=(
    # Development tools
    "node"              # Node.js runtime
    "fnm"               # Fast Node Manager
    "gh"                # GitHub CLI
    "watchman"          # File watching service (for React Native, etc.)
    "universal-ctags"   # Code tagging for editors
    "mas"               # Mac App Store CLI (for installing Xcode)

    # Media/Processing
    "ffmpeg"            # Video/audio processing
    "tesseract"         # OCR engine
    "exiftool"          # Image metadata

    # iOS/macOS Development
    "cocoapods"         # iOS dependency manager
    "xcodegen"          # Xcode project generator

    # CLI Tools
    "stripe"            # Stripe CLI
    "gemini-cli"        # Google Gemini CLI

    # Utilities
    "testdisk"          # Data recovery
    "docker-compose"    # Docker orchestration

    # Python (will install latest)
    "python@3.14"

    # Ruby (will install latest)
    "ruby"
)

for formula in "${BREW_FORMULAS[@]}"; do
    log_info "Installing $formula..."
    brew install "$formula" || log_warning "Failed to install $formula"
done

log_success "Homebrew formulas installed"

#===============================================================================
# SECTION 5: HOMEBREW CASKS (GUI Applications)
#===============================================================================
log_info "Installing Homebrew casks..."

BREW_CASKS=(
    "docker-desktop"      # Docker Desktop
    "gstreamer-runtime"   # GStreamer multimedia framework
    "ngrok"               # Secure tunnels
    "vscodium"            # VS Code without telemetry
    "wine-stable"         # Windows compatibility layer
)

for cask in "${BREW_CASKS[@]}"; do
    log_info "Installing $cask..."
    brew install --cask "$cask" || log_warning "Failed to install $cask"
done

log_success "Homebrew casks installed"

#===============================================================================
# SECTION 6: XCODE (Full Installation)
#===============================================================================
log_info "Checking Xcode installation..."

if ! command -v xcodebuild &>/dev/null || [[ ! -d "/Applications/Xcode.app" ]]; then
    log_info "Installing Xcode from Mac App Store..."
    log_info "This may take a while - Xcode is a large download..."

    # Xcode App Store ID is 497799835
    mas install 497799835 || {
        log_warning "Failed to install Xcode via mas"
        log_warning "Please install Xcode manually from the App Store"
        log_warning "Or download from: https://developer.apple.com/xcode/"
    }

    # Accept Xcode license
    if [[ -d "/Applications/Xcode.app" ]]; then
        log_info "Accepting Xcode license..."
        sudo xcodebuild -license accept || log_warning "Could not accept Xcode license automatically"

        # Install additional components
        log_info "Installing Xcode additional components..."
        sudo xcodebuild -runFirstLaunch || log_warning "Could not run first launch"
    fi
else
    log_success "Xcode already installed"
    xcodebuild -version | head -1
fi

#===============================================================================
# SECTION 7: NODE.JS GLOBAL PACKAGES
#===============================================================================
log_info "Installing Node.js global packages..."

NPM_GLOBALS=(
    "@anthropic-ai/claude-code"  # Claude Code CLI (AI coding assistant)
    "@railway/cli"               # Railway deployment CLI
    "convex"                     # Convex backend platform
    "vercel"                     # Vercel deployment CLI
    "yarn"                       # Yarn package manager
)

for package in "${NPM_GLOBALS[@]}"; do
    log_info "Installing npm package: $package..."
    npm install -g "$package" || log_warning "Failed to install $package"
done

log_success "Node.js global packages installed"

#===============================================================================
# SECTION 8: PYTHON PACKAGES
#===============================================================================
log_info "Installing Python packages..."

PIP_PACKAGES=(
    "pywatchman"    # Python Watchman client
)

for package in "${PIP_PACKAGES[@]}"; do
    log_info "Installing pip package: $package..."
    pip3 install "$package" || log_warning "Failed to install $package"
done

log_success "Python packages installed"

#===============================================================================
# SECTION 9: RUBY GEMS (Non-default gems)
#===============================================================================
log_info "Installing Ruby gems..."

RUBY_GEMS=(
    "nokogiri"        # XML/HTML parser
    "sqlite3"         # SQLite database adapter
)

for gem in "${RUBY_GEMS[@]}"; do
    log_info "Installing gem: $gem..."
    gem install "$gem" || log_warning "Failed to install $gem"
done

log_success "Ruby gems installed"

#===============================================================================
# SECTION 10: SHELL CONFIGURATION
#===============================================================================
log_info "Setting up shell configuration..."

# Create ~/.local/bin if it doesn't exist
mkdir -p "$HOME/.local/bin"

# Setup .zshrc
ZSHRC_CONTENT='export PATH="$HOME/.local/bin:$PATH"'

if [[ -f "$HOME/.zshrc" ]]; then
    if ! grep -q '.local/bin' "$HOME/.zshrc"; then
        echo "$ZSHRC_CONTENT" >> "$HOME/.zshrc"
        log_success "Updated .zshrc with PATH"
    else
        log_info ".zshrc already configured"
    fi
else
    echo "$ZSHRC_CONTENT" > "$HOME/.zshrc"
    log_success "Created .zshrc"
fi

log_success "Shell configuration complete"

#===============================================================================
# SECTION 11: GIT CONFIGURATION
#===============================================================================
log_info "Setting up Git configuration..."

# Git configuration - UPDATE THESE WITH YOUR DETAILS
git config --global user.name "Jason Kihlstadius"
git config --global user.email "bukumentor@gmail.com"

log_success "Git configured"

#===============================================================================
# SECTION 12: POST-INSTALLATION NOTES
#===============================================================================
echo ""
echo "=============================================="
echo "  Installation Complete!"
echo "=============================================="
echo ""
log_info "Post-installation notes:"
echo ""
echo "1. Xcode: Open Xcode and complete any remaining setup"
echo "2. XCODE SIGNING: Import your .p12 certificate files (double-click them)"
echo "   - Sign into Apple Developer account in Xcode → Settings → Accounts"
echo "   - See RESTORE_INSTRUCTIONS.md in your backup folder"
echo "3. Docker Desktop: Open the app and complete setup"
echo "4. Claude Code: Run 'claude' and authenticate with your Anthropic account"
echo "5. GPG Keys: You'll need to regenerate or import your GPG keys"
echo "6. SSH Keys: Generate new SSH keys with: ssh-keygen -t ed25519"
echo "7. Restart your terminal or run: source ~/.zshrc"
echo ""
echo "=============================================="
echo ""
log_success "Your terminal environment has been rebuilt!"
