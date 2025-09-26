# Homebrew Setup for Xamrock

This document outlines the complete setup for making Xamrock available through Homebrew.

## What We've Created

### 1. Distribution Files
- ✅ `Xamrock-0.1.13.zip` - Distribution archive of the current app
- ✅ SHA256 checksum: `807c7678ae725f17d2814f11affb1c85ed07db0bb1570c18bd369f89c25b2fe5`

### 2. GitHub Workflows
- ✅ `.github/workflows/release.yml` - Automated release creation and distribution
- ✅ Triggers on version tags (v*)
- ✅ Creates GitHub releases with ZIP archives
- ✅ Calculates SHA256 checksums automatically
- ✅ Triggers Homebrew tap updates

### 3. Homebrew Cask Formula
- ✅ `homebrew-cask/xamrock.rb` - Local cask formula for testing
- ✅ `homebrew-xamrock-tap/Casks/xamrock.rb` - Production cask formula
- ✅ Includes all required stanzas (version, sha256, url, name, desc, homepage, app)
- ✅ macOS Sonoma+ dependency
- ✅ Proper uninstall cleanup with `zap` stanza

### 4. Homebrew Tap Repository Structure
- ✅ `homebrew-xamrock-tap/` - Complete tap repository structure
- ✅ `homebrew-xamrock-tap/Casks/xamrock.rb` - Main cask formula
- ✅ `homebrew-xamrock-tap/README.md` - Tap documentation
- ✅ `homebrew-xamrock-tap/.github/workflows/update-cask.yml` - Auto-update workflow
- ✅ `homebrew-xamrock-tap/.github/workflows/test-cask.yml` - Testing workflow

### 5. Setup Scripts and Documentation
- ✅ `scripts/setup-homebrew-tap.sh` - Setup automation script
- ✅ Updated `README.md` with installation instructions
- ✅ This setup documentation

## Next Steps (Manual Actions Required)

### 1. Create the Homebrew Tap Repository
```bash
# Create repository on GitHub: xamrock/homebrew-xamrock
git clone https://github.com/xamrock/homebrew-xamrock.git
cd homebrew-xamrock
cp -r ../xamrock-desktop/homebrew-xamrock-tap/* .
git add .
git commit -m "Initial Homebrew tap for Xamrock"
git push origin main
```

### 2. Create Initial GitHub Release
```bash
# Tag and push the current version
git tag 0.1.13
git push origin 0.1.13
```

This will trigger the release workflow and create the first GitHub release with the distribution archive.

### 3. Configure GitHub Secrets
In the `xamrock/xamrock-desktop` repository settings:
- Add `HOMEBREW_TAP_TOKEN` secret (GitHub Personal Access Token with repo scope)

### 4. Test the Installation
```bash
brew tap xamrock/homebrew-xamrock
brew install --cask xamrock --dry-run  # Test without installing
brew install --cask xamrock            # Actual installation
```

### 5. Verify Everything Works
```bash
# Check if app is installed
ls /Applications/Xamrock.app

# Test uninstallation
brew uninstall --cask xamrock

# Test update process (after creating a new release)
brew update
brew upgrade --cask xamrock
```

## User Installation Commands

Once everything is set up, users can install Xamrock with:

```bash
brew tap xamrock/homebrew-xamrock
brew install --cask xamrock
```

## Automated Workflow

The setup enables this automated workflow:

1. **Developer creates a new release**:
   ```bash
   git tag 0.2.0
   git push origin 0.2.0
   ```

2. **GitHub Actions automatically**:
   - Packages the app into a ZIP file
   - Calculates SHA256 checksum
   - Creates GitHub release with the archive
   - Triggers homebrew tap update

3. **Homebrew tap automatically**:
   - Updates the cask formula with new version and checksum
   - Creates a pull request for review
   - (Optionally) auto-merges if configured

4. **Users get updates**:
   ```bash
   brew update
   brew upgrade --cask xamrock
   ```

## File Structure Created

```
xamrock-desktop/
├── .github/workflows/
│   └── release.yml                     # Release automation
├── homebrew-cask/
│   └── xamrock.rb                      # Local testing cask
├── homebrew-xamrock-tap/               # Complete tap repository
│   ├── .github/workflows/
│   │   ├── update-cask.yml            # Auto-update workflow
│   │   └── test-cask.yml              # Testing workflow
│   ├── Casks/
│   │   └── xamrock.rb                 # Production cask formula
│   └── README.md                      # Tap documentation
├── scripts/
│   └── setup-homebrew-tap.sh          # Setup script
├── Xamrock-0.1.13.zip                 # Distribution archive
├── README.md                          # Updated with install instructions
└── HOMEBREW_SETUP.md                  # This documentation
```

The setup is now complete and ready for the manual steps to activate the Homebrew distribution!