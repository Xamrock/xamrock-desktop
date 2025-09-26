#!/bin/bash

# Setup script for Xamrock Homebrew tap repository
# This script helps set up the homebrew-xamrock repository

set -e

echo "🍺 Setting up Xamrock Homebrew Tap"
echo "=================================="

# Check if we're in the right directory
if [ ! -f "README.md" ] || ! grep -q "Xamrock" README.md; then
    echo "❌ This script should be run from the xamrock-desktop repository root"
    exit 1
fi

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Step 1: Checking prerequisites...${NC}"

# Check if git is available
if ! command -v git &> /dev/null; then
    echo -e "${RED}❌ Git is not installed${NC}"
    exit 1
fi

# Check if brew is available
if ! command -v brew &> /dev/null; then
    echo -e "${YELLOW}⚠️  Homebrew is not installed. Install it from https://brew.sh${NC}"
fi

echo -e "${GREEN}✅ Prerequisites checked${NC}"

echo -e "${YELLOW}Step 2: Repository setup instructions...${NC}"

echo ""
echo "To complete the Homebrew tap setup, follow these steps:"
echo ""
echo "1. Create a new repository on GitHub:"
echo "   - Repository name: homebrew-xamrock"
echo "   - Organization: xamrock"
echo "   - Make it public"
echo ""
echo "2. Clone and setup the tap repository:"
echo "   git clone https://github.com/xamrock/homebrew-xamrock.git"
echo "   cd homebrew-xamrock"
echo ""
echo "3. Copy the tap files:"
echo "   cp -r ../xamrock-desktop/homebrew-xamrock-tap/* ."
echo ""
echo "4. Commit and push:"
echo "   git add ."
echo "   git commit -m \"Initial Homebrew tap for Xamrock\""
echo "   git push origin main"
echo ""
echo "5. Set up repository secrets in GitHub:"
echo "   - Go to Settings > Secrets and variables > Actions"
echo "   - Add HOMEBREW_TAP_TOKEN (personal access token with repo scope)"
echo ""
echo "6. Test the tap locally:"
echo "   brew tap xamrock/homebrew-xamrock"
echo "   brew install --cask xamrock --dry-run"
echo ""

echo -e "${YELLOW}Step 3: Creating initial release...${NC}"

# Check if we have the distribution archive
if [ ! -f "Xamrock-0.1.13.zip" ]; then
    echo "Creating distribution archive..."
    zip -r Xamrock-0.1.13.zip Xamrock.app
fi

# Get SHA256
SHA256=$(shasum -a 256 Xamrock-0.1.13.zip | cut -d ' ' -f 1)
echo "SHA256 for v0.1.13: $SHA256"

echo ""
echo -e "${GREEN}✅ Setup preparation complete!${NC}"
echo ""
echo "Next steps:"
echo "1. Create the homebrew-xamrock repository on GitHub"
echo "2. Upload the Xamrock-0.1.13.zip as a release asset"
echo "3. Set up the tap repository with the files in homebrew-xamrock-tap/"
echo "4. Configure GitHub secrets"
echo "5. Test the installation"
echo ""
echo "Once everything is set up, users can install Xamrock with:"
echo -e "${GREEN}brew tap xamrock/homebrew-xamrock${NC}"
echo -e "${GREEN}brew install --cask xamrock${NC}"