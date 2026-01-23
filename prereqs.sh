#!/bin/bash
# Quick prerequisite checker for ANSAI installations

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Running ANSAI prerequisite check..."
bash "$SCRIPT_DIR/install.sh" --check-prereqs
