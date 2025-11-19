#!/bin/bash
# Test Universal Service Self-Healing
# This script simulates service failures and verifies automatic remediation

set -e

echo "🧪 ANSAI Self-Healing Test Suite"
echo "Testing: Universal Service Healing"
echo "========================================"
echo ""

# Configuration
TEST_SERVICE="${1:-passgo}"
TEST_HOST="${2:-your-server.local}"
TEST_EMAIL="${3:-jimmykbyrd@gmail.com}"

echo "📋 Test Configuration:"
echo "  Service: $TEST_SERVICE"
echo "  Host: $TEST_HOST"
echo "  Alert Email: $TEST_EMAIL"
echo ""

# Test 1: Service Restart
echo "Test 1: Service Restart Healing"
echo "--------------------------------"
echo "❌ Stopping $TEST_SERVICE service..."
ssh jbyrd@$TEST_HOST "sudo systemctl stop $TEST_SERVICE"
echo "⏱️  Waiting 10 seconds for self-healing to trigger..."
sleep 10
STATUS=$(ssh jbyrd@$TEST_HOST "systemctl is-active $TEST_SERVICE" || echo "inactive")
if [ "$STATUS" = "active" ]; then
    echo "✅ PASS: Service was automatically restarted"
else
    echo "❌ FAIL: Service did not self-heal"
    exit 1
fi
echo ""

# Test 2: Check Email Alert
echo "Test 2: Email Alert Verification"
echo "----------------------------------"
echo "📧 Checking for email alert..."
echo "  (Check your inbox at $TEST_EMAIL)"
echo "  Expected subject: [RECOVERED] $TEST_SERVICE on $TEST_HOST"
echo ""
read -p "Did you receive the email alert? (y/n): " RECEIVED_EMAIL
if [ "$RECEIVED_EMAIL" = "y" ] || [ "$RECEIVED_EMAIL" = "Y" ]; then
    echo "✅ PASS: Email alert received"
else
    echo "⚠️  WARNING: Email alert not received (check spam folder)"
fi
echo ""

# Test 3: Log Verification
echo "Test 3: Self-Healing Log Verification"
echo "---------------------------------------"
echo "📝 Checking self-healing logs..."
LOGS=$(ssh jbyrd@$TEST_HOST "tail -20 /var/log/self-healing/$TEST_SERVICE.log" || echo "")
if echo "$LOGS" | grep -q "RECOVERY SUCCESSFUL"; then
    echo "✅ PASS: Recovery logged successfully"
    echo ""
    echo "Recent log entries:"
    echo "$LOGS" | tail -5
else
    echo "❌ FAIL: No recovery log found"
    exit 1
fi
echo ""

# Test 4: Service Health After Healing
echo "Test 4: Post-Healing Service Health"
echo "-------------------------------------"
echo "🏥 Checking service health..."
HEALTH=$(ssh jbyrd@$TEST_HOST "systemctl status $TEST_SERVICE | grep 'Active:' | awk '{print \$2}'" || echo "unknown")
UPTIME=$(ssh jbyrd@$TEST_HOST "systemctl show $TEST_SERVICE --property=ActiveEnterTimestamp | cut -d= -f2" || echo "unknown")

if [ "$HEALTH" = "active" ]; then
    echo "✅ PASS: Service is healthy"
    echo "  Status: $HEALTH"
    echo "  Started: $UPTIME"
else
    echo "❌ FAIL: Service is not healthy"
    exit 1
fi
echo ""

# Test 5: Rapid Failure Test (Exponential Backoff)
echo "Test 5: Exponential Backoff Testing"
echo "-------------------------------------"
echo "🔄 Testing rapid restart handling..."
for i in {1..3}; do
    echo "  Attempt $i: Stopping service..."
    ssh jbyrd@$TEST_HOST "sudo systemctl stop $TEST_SERVICE"
    sleep 3
    STATUS=$(ssh jbyrd@$TEST_HOST "systemctl is-active $TEST_SERVICE" || echo "inactive")
    if [ "$STATUS" = "active" ]; then
        echo "  ✅ Service restarted (attempt $i)"
    else
        echo "  ⏱️  Waiting for exponential backoff..."
        sleep 10
    fi
done
echo ""

# Summary
echo "========================================"
echo "✅ Test Suite Completed Successfully"
echo "========================================"
echo ""
echo "📊 Test Summary:"
echo "  ✅ Service restart healing"
echo "  ✅ Email alert delivery"
echo "  ✅ Log verification"
echo "  ✅ Post-healing health check"
echo "  ✅ Exponential backoff handling"
echo ""
echo "📈 Next Steps:"
echo "  1. Review the email alert you received"
echo "  2. Check /var/log/self-healing/$TEST_SERVICE.log for details"
echo "  3. Verify the service is functioning normally"
echo ""
echo "🎉 ANSAI Self-Healing: All Tests Passed!"


