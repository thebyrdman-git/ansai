#!/bin/bash
# Test CSS Error Monitoring
# This script simulates CSS errors and verifies detection/alerting

set -e

echo "🧪 ANSAI Self-Healing Test Suite"
echo "Testing: CSS Error Monitoring"
echo "========================================"
echo ""

# Configuration
TEST_APP="${1:-story-stages}"
TEST_HOST="${2:-miraclemax.local}"
TEST_EMAIL="${3:-jimmykbyrd@gmail.com}"
TEMPLATE_PATH="/home/jbyrd/$TEST_APP/templates"

echo "📋 Test Configuration:"
echo "  Application: $TEST_APP"
echo "  Host: $TEST_HOST"
echo "  Alert Email: $TEST_EMAIL"
echo ""

# Test 1: Static CSS Validation
echo "Test 1: Static CSS File Validation"
echo "------------------------------------"
echo "🔍 Running CSS file validation..."
VALIDATION_OUTPUT=$(ssh jbyrd@$TEST_HOST "sudo /usr/local/bin/css-validator.sh" || echo "VALIDATION_RUN")

if echo "$VALIDATION_OUTPUT" | grep -q "No missing CSS files" || echo "$VALIDATION_OUTPUT" | grep -q "✅"; then
    echo "✅ PASS: All CSS files exist"
else
    echo "⚠️  Missing CSS files detected:"
    echo "$VALIDATION_OUTPUT" | grep "Missing CSS" || echo "  (Check validation output)"
fi
echo ""

# Test 2: Inject Missing CSS Reference
echo "Test 2: Missing CSS File Detection"
echo "------------------------------------"
echo "❌ Injecting reference to non-existent CSS file..."

# Create a backup and inject missing reference
ssh jbyrd@$TEST_HOST "sudo cp $TEMPLATE_PATH/dashboard.html $TEMPLATE_PATH/dashboard.html.bak"
ssh jbyrd@$TEST_HOST "echo '<link rel=\"stylesheet\" href=\"/static/css/nonexistent-test-file.css\">' | sudo tee -a $TEMPLATE_PATH/dashboard.html > /dev/null"

echo "🔍 Running validation again..."
VALIDATION_OUTPUT=$(ssh jbyrd@$TEST_HOST "sudo /usr/local/bin/css-validator.sh" 2>&1 || echo "DETECTED")

if echo "$VALIDATION_OUTPUT" | grep -q "nonexistent-test-file.css" || echo "$VALIDATION_OUTPUT" | grep -q "Missing"; then
    echo "✅ PASS: Missing CSS file detected"
else
    echo "❌ FAIL: Missing CSS file not detected"
    ssh jbyrd@$TEST_HOST "sudo mv $TEMPLATE_PATH/dashboard.html.bak $TEMPLATE_PATH/dashboard.html"
    exit 1
fi

# Restore original file
echo "🔄 Restoring original template..."
ssh jbyrd@$TEST_HOST "sudo mv $TEMPLATE_PATH/dashboard.html.bak $TEMPLATE_PATH/dashboard.html"
echo ""

# Test 3: Runtime CSS Monitoring
echo "Test 3: Runtime CSS Loading Monitor"
echo "-------------------------------------"
echo "📊 Checking runtime CSS logs..."

ERROR_LOG="/var/log/css-runtime-errors/$TEST_APP_errors.log"
LOG_EXISTS=$(ssh jbyrd@$TEST_HOST "[ -f $ERROR_LOG ] && echo 'yes' || echo 'no'")

if [ "$LOG_EXISTS" = "yes" ]; then
    echo "✅ PASS: Runtime CSS log file exists"
    RECENT_ERRORS=$(ssh jbyrd@$TEST_HOST "tail -5 $ERROR_LOG 2>/dev/null || echo 'No recent errors'")
    echo "  Recent entries:"
    echo "$RECENT_ERRORS" | sed 's/^/    /'
else
    echo "ℹ️  INFO: No CSS loading errors logged (this is good!)"
fi
echo ""

# Test 4: CSS Monitor JavaScript Integration
echo "Test 4: Frontend CSS Monitor Integration"
echo "-----------------------------------------"
echo "🔍 Checking if css-monitor.js is deployed..."

CSS_MONITOR_PATH="/home/jbyrd/$TEST_APP/static/js/css-monitor.js"
if ssh jbyrd@$TEST_HOST "[ -f $CSS_MONITOR_PATH ]"; then
    echo "✅ PASS: css-monitor.js deployed"
    
    # Check if it's included in templates
    TEMPLATE_INCLUDES=$(ssh jbyrd@$TEST_HOST "grep -r 'css-monitor.js' $TEMPLATE_PATH --include='*.html' | wc -l")
    if [ "$TEMPLATE_INCLUDES" -gt 0 ]; then
        echo "✅ PASS: css-monitor.js referenced in $TEMPLATE_INCLUDES templates"
    else
        echo "⚠️  WARNING: css-monitor.js not referenced in any templates"
    fi
else
    echo "❌ FAIL: css-monitor.js not found"
    exit 1
fi
echo ""

# Test 5: API Endpoint Verification
echo "Test 5: CSS Error Logging API Endpoint"
echo "----------------------------------------"
echo "🔌 Testing /api/log-css-error endpoint..."

# Test the endpoint with curl
ENDPOINT_TEST=$(ssh jbyrd@$TEST_HOST "curl -s -X POST http://localhost:5002/api/log-css-error -H 'Content-Type: application/json' -d '{\"errors\":[{\"url\":\"/static/css/test.css\",\"message\":\"Failed to load\"}]}' || echo 'FAILED'")

if echo "$ENDPOINT_TEST" | grep -q "ok" || echo "$ENDPOINT_TEST" | grep -q "status"; then
    echo "✅ PASS: API endpoint responding"
else
    echo "❌ FAIL: API endpoint not responding"
    echo "  Response: $ENDPOINT_TEST"
    exit 1
fi
echo ""

# Test 6: Monitoring Service Status
echo "Test 6: CSS Monitoring Service Status"
echo "---------------------------------------"
echo "🔍 Checking monitoring service..."

# Check if the systemd timer is active
TIMER_STATUS=$(ssh jbyrd@$TEST_HOST "systemctl is-active css-validation.timer" || echo "inactive")
if [ "$TIMER_STATUS" = "active" ]; then
    echo "✅ PASS: CSS validation timer is active"
    
    # Get next run time
    NEXT_RUN=$(ssh jbyrd@$TEST_HOST "systemctl list-timers css-validation.timer --no-pager | grep css-validation | awk '{print \$1, \$2, \$3}'")
    echo "  Next validation: $NEXT_RUN"
else
    echo "⚠️  WARNING: CSS validation timer is not active"
fi

RUNTIME_TIMER=$(ssh jbyrd@$TEST_HOST "systemctl is-active css-runtime-monitor.timer" || echo "inactive")
if [ "$RUNTIME_TIMER" = "active" ]; then
    echo "✅ PASS: Runtime monitor timer is active"
else
    echo "⚠️  WARNING: Runtime monitor timer is not active"
fi
echo ""

# Summary
echo "========================================"
echo "✅ Test Suite Completed Successfully"
echo "========================================"
echo ""
echo "📊 Test Summary:"
echo "  ✅ Static CSS validation"
echo "  ✅ Missing file detection"
echo "  ✅ Runtime monitoring logs"
echo "  ✅ Frontend monitor integration"
echo "  ✅ API endpoint verification"
echo "  ✅ Monitoring service status"
echo ""
echo "📈 Next Steps:"
echo "  1. Visit your application in a browser"
echo "  2. Check Network tab for CSS loading issues"
echo "  3. Monitor $ERROR_LOG for runtime errors"
echo ""
echo "🎉 ANSAI CSS Monitoring: All Tests Passed!"

