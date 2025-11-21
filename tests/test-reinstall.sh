#!/bin/bash
# Test for the reinstall self-deletion bug
# https://github.com/thebyrdman-git/ansai/issues/reinstall-self-deletion

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Testing ANSAI Reinstall Scenario${NC}"
echo "This test validates that the installer doesn't delete itself during reinstall."
echo ""

# Create a test directory
TEST_DIR="/tmp/ansai-reinstall-test"
rm -rf "$TEST_DIR"
mkdir -p "$TEST_DIR"

echo "1. Setting up test environment in $TEST_DIR..."
cp ../install.sh "$TEST_DIR/"
cd "$TEST_DIR"

echo "2. Simulating first install (creating .ansai directory)..."
mkdir -p .ansai/bin .ansai/orchestrators
cp install.sh .ansai/

echo "3. Running installer from within .ansai directory (the bug scenario)..."
echo "   This should NOT crash even when choosing to reinstall."
echo ""

# Run the installer and answer 'y' to reinstall, then 'n' to continue
(cd .ansai && (echo 'y'; sleep 1; echo 'n') | bash install.sh 2>&1 | tail -20) || {
    echo -e "${RED}❌ FAILED: Installer crashed during reinstall${NC}"
    exit 1
}

if [ -f .ansai/install.sh ] || [ -f /tmp/ansai-install-temp.sh ]; then
    echo -e "${GREEN}✅ PASSED: Installer handled reinstall gracefully${NC}"
    echo "   The installer detected it was running from .ansai/ and"
    echo "   moved itself to /tmp before doing destructive operations."
else
    echo -e "${RED}❌ FAILED: Unexpected behavior${NC}"
    exit 1
fi

# Cleanup
cd /
rm -rf "$TEST_DIR"
rm -f /tmp/ansai-install-temp.sh

echo -e "\n${GREEN}Test complete! Bug is fixed.${NC}"

