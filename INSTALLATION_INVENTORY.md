# Terminal Environment Inventory

Generated: 2026-01-16

This document contains a complete inventory of all terminal installations discovered on your system.

---

## Xcode

| Property | Value |
|----------|-------|
| Version | Xcode 26.2 |
| Build | 17C52 |
| Location | /Applications/Xcode.app |
| Developer Path | /Applications/Xcode.app/Contents/Developer |

### Code Signing Certificates

| Type | Identity | Team ID |
|------|----------|---------|
| Development | Apple Development: Jason Kihlstadius | P5TVX6Y8T3 |
| Distribution | Apple Distribution: Jason Kihlstadius | D33FTL28LK |

**Fingerprints:**
- Development: `8D9698EB8492975C1E34B37E2A6B04833F26BBB7`
- Distribution: `47A9A2756D890C46C99CC94352A31B8EE45F5895`

⚠️ **IMPORTANT:** Run `backup_xcode_signing.sh` to export these certificates before wiping your machine. The private keys cannot be recovered from Apple.

---

## Homebrew Packages

### Tapped Repositories
| Repository |
|------------|
| stripe/stripe-cli |

### Installed Formulas (112 total)

**Primary Tools (explicitly installed):**
| Package | Description |
|---------|-------------|
| cocoapods | iOS dependency manager |
| docker-compose | Docker orchestration tool |
| exiftool | Image metadata tool |
| ffmpeg | Video/audio processing |
| fnm | Fast Node Manager |
| gemini-cli | Google Gemini CLI |
| gh | GitHub CLI |
| node | Node.js runtime |
| stripe | Stripe CLI |
| tesseract | OCR engine |
| testdisk | Data recovery tool |
| universal-ctags | Code tagging |
| watchman | File watching service |
| xcodegen | Xcode project generator |
| python@3.14 | Python interpreter |
| ruby | Ruby interpreter |

**Dependencies (auto-installed):**
aom, aribb24, boost, brotli, c-ares, ca-certificates, cairo, cjson, dav1d, double-conversion, edencommon, fb303, fbthrift, fizz, flac, fmt, folly, fontconfig, freetype, frei0r, fribidi, gdk-pixbuf, gettext, gflags, giflib, glib, glog, gmp, gnutls, graphite2, harfbuzz, highway, icu4c@78, imath, jansson, jpeg-turbo, jpeg-xl, lame, leptonica, libarchive, libass, libb2, libbluray, libdeflate, libevent, libidn2, libmicrohttpd, libnghttp2, libnghttp3, libngtcp2, libogg, libpng, librist, librsvg, libsamplerate, libsndfile, libsodium, libsoxr, libssh, libtasn1, libtiff, libudfread, libunibreak, libunistring, libuv, libvidstab, libvmaf, libvorbis, libvpx, libx11, libxau, libxcb, libxdmcp, libxext, libxrender, libyaml, little-cms2, lz4, lzo, mbedtls@3, mpdecimal, mpg123, nettle, opencore-amr, openexr, openjpeg, openjph, openssl@3, opus, p11-kit, pango, pcre2, pixman, rav1e, readline, rubberband, sdl2, simdjson, snappy, speex, sqlite, srt, svt-av1, theora, unbound, uvwasi, wangle, webp, x264, x265, xorgproto, xvid, xxhash, xz, zeromq, zimg, zstd

### Installed Casks (5 total)
| Cask | Description |
|------|-------------|
| docker-desktop | Docker Desktop application |
| gstreamer-runtime | GStreamer multimedia framework |
| ngrok | Secure tunneling service |
| vscodium | VS Code without telemetry |
| wine-stable | Windows compatibility layer |

---

## Node.js Environment

| Property | Value |
|----------|-------|
| Location | /opt/homebrew/bin/node |
| Version | v25.2.1 |
| Install Method | Homebrew |

### Global npm Packages
| Package | Version |
|---------|---------|
| @anthropic-ai/claude-code | 2.1.11 |
| @railway/cli | 4.25.1 |
| convex | 1.29.2 |
| npm | 11.6.2 |
| vercel | 49.1.1 |
| yarn | 1.22.22 |

### Package Managers
| Manager | Status |
|---------|--------|
| npm | Installed (v11.6.2) |
| yarn | Installed (v1.22.22) |
| pnpm | Not installed |
| nvm | Not installed |

---

## Python Environment

| Property | Value |
|----------|-------|
| Location | /opt/homebrew/bin/python3 |
| Version | Python 3.14.2 |
| Install Method | Homebrew |

### Installed pip Packages
| Package | Version |
|---------|---------|
| pip | 25.3 |
| pywatchman | 3.0.0 |
| wheel | 0.45.1 |

### Python Tools
| Tool | Status |
|------|--------|
| pyenv | Not installed |
| pipx | Not installed |
| conda | Not installed |

---

## Ruby Environment

| Property | Value |
|----------|-------|
| Location | /usr/bin/ruby |
| Version | ruby 2.6.10p210 |
| Type | System Ruby (macOS default) |

### Non-Default Gems
| Gem | Version |
|-----|---------|
| nokogiri | 1.13.8 |
| sqlite3 | 1.3.13 |
| libxml-ruby | 3.2.1 |
| CFPropertyList | 2.3.6 |
| mini_portile2 | 2.8.0 |

### Ruby Version Managers
| Tool | Status |
|------|--------|
| rbenv | Not installed |
| rvm | Not installed |

---

## Rust Environment

| Component | Status |
|-----------|--------|
| rustc | Not installed |
| cargo | Not installed |
| rustup | Not installed |

---

## Go Environment

| Component | Status |
|-----------|--------|
| go | Not installed |

---

## Container & Cloud Tools

| Tool | Version | Path |
|------|---------|------|
| Docker | 28.5.1 | /usr/local/bin/docker |
| kubectl | v1.34.1 | /usr/local/bin/kubectl |
| AWS CLI | Not installed | - |
| gcloud | Not installed | - |
| Terraform | Not installed | - |

---

## Shell Configuration

| Property | Value |
|----------|-------|
| Shell | /bin/zsh |
| oh-my-zsh | Not installed |
| Starship | Not installed |
| tmux | Not installed |

### ~/.zshrc Contents
```bash
export PATH="$HOME/.local/bin:$PATH"
```

---

## Git Configuration

| Setting | Value |
|---------|-------|
| user.name | Jason Kihlstadius |
| user.email | bukumentor@gmail.com |

---

## Security Keys

### SSH Keys
- No SSH public keys found in ~/.ssh/

### GPG Keys
| Property | Value |
|----------|-------|
| GPG Path | /usr/local/bin/gpg |
| Key Type | RSA 4096 |
| Key ID | B7A50CE3888472FABFF81E505FF48350943C7597 |
| User ID | JJ <jkihlstad@gmail.com> |
| Created | 2025-12-19 |
| Expires | 2029-12-19 |

---

## Common CLI Tools

### Installed
| Tool | Path |
|------|------|
| vim | /usr/bin/vim |
| curl | /usr/bin/curl |
| jq | /usr/bin/jq |
| gpg | /usr/local/bin/gpg |

### Not Installed
nvim, emacs, wget, yq, fzf, ripgrep, fd, bat, exa, htop, tldr, tree

---

## Summary Statistics

| Category | Count |
|----------|-------|
| Xcode | 26.2 |
| Homebrew Formulas | 112 |
| Homebrew Casks | 5 |
| npm Global Packages | 6 (including Claude Code) |
| pip Packages | 3 |
| Ruby Gems (non-default) | 5 |
| Container Tools | 2 (Docker, kubectl) |
