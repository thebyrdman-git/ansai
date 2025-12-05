#!/bin/bash
# Diagnostic script for self-healing system
# Checks if self-healing is properly configured

SERVICE_NAME="${1:-cockpit.socket}"

echo "🔍 Self-Healing Diagnostic for: $SERVICE_NAME"
echo "═══════════════════════════════════════════════════════"
echo ""

# Check if self-heal script exists
HEAL_SCRIPT="/usr/local/bin/self-heal/${SERVICE_NAME}-self-heal.sh"
echo "1. Checking self-heal script..."
if [ -f "$HEAL_SCRIPT" ]; then
    echo "   ✅ Script exists: $HEAL_SCRIPT"
    if [ -x "$HEAL_SCRIPT" ]; then
        echo "   ✅ Script is executable"
    else
        echo "   ❌ Script is NOT executable (run: chmod +x $HEAL_SCRIPT)"
    fi
else
    echo "   ❌ Script missing: $HEAL_SCRIPT"
fi
echo ""

# Check if self-heal service unit exists
HEAL_SERVICE="${SERVICE_NAME}-self-heal.service"
echo "2. Checking self-heal service unit..."
if systemctl list-unit-files | grep -q "^${HEAL_SERVICE}"; then
    echo "   ✅ Service unit exists: $HEAL_SERVICE"
    systemctl status "$HEAL_SERVICE" --no-pager -l | head -5
else
    echo "   ❌ Service unit missing: $HEAL_SERVICE"
fi
echo ""

# Check if drop-in directory exists
DROPIN_DIR="/etc/systemd/system/${SERVICE_NAME}.d"
echo "3. Checking drop-in directory..."
if [ -d "$DROPIN_DIR" ]; then
    echo "   ✅ Drop-in directory exists: $DROPIN_DIR"
    if [ -f "$DROPIN_DIR/self-heal.conf" ]; then
        echo "   ✅ Configuration file exists"
        echo "   Contents:"
        cat "$DROPIN_DIR/self-heal.conf" | sed 's/^/      /'
    else
        echo "   ❌ Configuration file missing: $DROPIN_DIR/self-heal.conf"
    fi
else
    echo "   ❌ Drop-in directory missing: $DROPIN_DIR"
fi
echo ""

# Check OnFailure configuration
echo "4. Checking OnFailure configuration..."
ONFAILURE=$(systemctl show "$SERVICE_NAME" --property=OnFailure --value 2>/dev/null)
if [ -n "$ONFAILURE" ]; then
    echo "   ✅ OnFailure is set: $ONFAILURE"
    if [ "$ONFAILURE" = "${SERVICE_NAME}-self-heal.service" ]; then
        echo "   ✅ OnFailure points to correct service"
    else
        echo "   ⚠️  OnFailure points to: $ONFAILURE (expected: ${SERVICE_NAME}-self-heal.service)"
    fi
else
    echo "   ❌ OnFailure is NOT configured"
    echo "   This means self-healing will NOT trigger automatically!"
fi
echo ""

# Check if main service exists
echo "5. Checking main service unit..."
if systemctl list-unit-files | grep -q "^${SERVICE_NAME}"; then
    echo "   ✅ Service unit exists: $SERVICE_NAME"
    echo "   Current status:"
    systemctl status "$SERVICE_NAME" --no-pager -l | head -10
else
    echo "   ⚠️  Service unit not found: $SERVICE_NAME"
    echo "   (This might be normal if it's a socket/timer unit)"
fi
echo ""

# Test manual execution
echo "6. Testing self-heal script (dry run)..."
if [ -f "$HEAL_SCRIPT" ]; then
    echo "   Running script to check syntax..."
    bash -n "$HEAL_SCRIPT" 2>&1
    if [ $? -eq 0 ]; then
        echo "   ✅ Script syntax is valid"
    else
        echo "   ❌ Script has syntax errors"
    fi
else
    echo "   ⏭️  Skipping (script not found)"
fi
echo ""

# Summary
echo "═══════════════════════════════════════════════════════"
echo "📋 Summary:"
echo ""

ISSUES=0

[ ! -f "$HEAL_SCRIPT" ] && ISSUES=$((ISSUES + 1)) && echo "❌ Self-heal script missing"
[ ! -x "$HEAL_SCRIPT" ] && ISSUES=$((ISSUES + 1)) && echo "❌ Self-heal script not executable"
[ ! -d "$DROPIN_DIR" ] && ISSUES=$((ISSUES + 1)) && echo "❌ Drop-in directory missing"
[ ! -f "$DROPIN_DIR/self-heal.conf" ] && ISSUES=$((ISSUES + 1)) && echo "❌ OnFailure config file missing"
[ -z "$ONFAILURE" ] && ISSUES=$((ISSUES + 1)) && echo "❌ OnFailure not configured in systemd"

if [ $ISSUES -eq 0 ]; then
    echo "✅ All checks passed! Self-healing should work."
    echo ""
    echo "📝 Important: OnFailure only triggers on ACTUAL FAILURES, not manual stops."
    echo ""
    echo "To test self-healing:"
    echo ""
    echo "  Option 1: Manually trigger the self-heal service:"
    echo "    sudo systemctl start ${HEAL_SERVICE}"
    echo "    sudo journalctl -u ${HEAL_SERVICE} -n 50"
    echo ""
    echo "  Option 2: Cause an actual failure (for socket units, this is harder):"
    echo "    # For socket units, stopping doesn't trigger OnFailure"
    echo "    # You need to cause the service to actually fail"
    echo "    # Or monitor the service the socket activates (e.g., cockpit.service)"
    echo ""
    echo "  Option 3: Check if healing ran:"
    echo "    sudo journalctl -t ${SERVICE_NAME}-self-heal -n 50"
    echo "    sudo journalctl -u ${HEAL_SERVICE} -n 50"
else
    echo "⚠️  Found $ISSUES issue(s). Please fix them and redeploy."
    echo ""
    echo "To fix, redeploy the playbook:"
    echo "  ansible-playbook playbooks/deploy-self-healing.yml \\"
    echo "    -e '{\"monitored_services\": [{\"name\": \"$SERVICE_NAME\", \"port\": 9090, \"critical\": true}]}' \\"
    echo "    -e \"owner_email=your-email@example.com\" \\"
    echo "    -i inventory/hosts.yml"
fi

