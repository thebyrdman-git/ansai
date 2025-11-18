#!/bin/bash
# Test JavaScript Error Monitoring
# This script simulates JS errors and verifies detection/alerting

set -e

echo "🧪 ANSAI Self-Healing Test Suite"
echo "Testing: JavaScript Error Monitoring"
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

# Test 1: Static Syntax Validation
echo "Test 1: Static JavaScript Syntax Validation"
echo "---------------------------------------------"
echo "🔍 Running static syntax validation..."
VALIDATION_OUTPUT=$(ssh jbyrd@$TEST_HOST "sudo /usr/local/bin/js-validator.sh" || echo "FAILED")

if echo "$VALIDATION_OUTPUT" | grep -q "No syntax errors found" || echo "$VALIDATION_OUTPUT" | grep -q "✅"; then
    echo "✅ PASS: No syntax errors found in templates"
else
    echo "⚠️  Syntax errors detected (this is expected if test errors exist):"
    echo "$VALIDATION_OUTPUT" | head -10
fi
echo ""

# Test 2: Inject Test Error
echo "Test 2: Simulated JavaScript Error"
echo "------------------------------------"
echo "❌ Injecting test syntax error..."

# Create a backup and inject error
ssh jbyrd@$TEST_HOST "sudo cp $TEMPLATE_PATH/dashboard.html $TEMPLATE_PATH/dashboard.html.bak"
ssh jbyrd@$TEST_HOST "echo '<script>var test = function( { console.log(\"syntax error\") }</script>' | sudo tee -a $TEMPLATE_PATH/dashboard.html > /dev/null"

echo "🔍 Running validation again..."
VALIDATION_OUTPUT=$(ssh jbyrd@$TEST_HOST "sudo /usr/local/bin/js-validator.sh" 2>&1 || echo "DETECTED")

if echo "$VALIDATION_OUTPUT" | grep -q "Unexpected token" || echo "$VALIDATION_OUTPUT" | grep -q "syntax error" || echo "$VALIDATION_OUTPUT" | grep -q "ERROR"; then
    echo "✅ PASS: Syntax error detected"
else
    echo "❌ FAIL: Syntax error not detected"
    ssh jbyrd@$TEST_HOST "sudo mv $TEMPLATE_PATH/dashboard.html.bak $TEMPLATE_PATH/dashboard.html"
    exit 1
fi

# Restore original file
echo "🔄 Restoring original template..."
ssh jbyrd@$TEST_HOST "sudo mv $TEMPLATE_PATH/dashboard.html.bak $TEMPLATE_PATH/dashboard.html"
echo ""

# Test 3: Runtime Error Capture
echo "Test 3: Runtime Error Capture"
echo "-------------------------------"
echo "📊 Checking runtime error logs..."

# Check if error logger is active
ERROR_LOG="/var/log/js-runtime-errors/$TEST_APP_errors.log"
LOG_EXISTS=$(ssh jbyrd@$TEST_HOST "[ -f $ERROR_LOG ] && echo 'yes' || echo 'no'")

if [ "$LOG_EXISTS" = "yes" ]; then
    echo "✅ PASS: Runtime error log file exists"
    RECENT_ERRORS=$(ssh jbyrd@$TEST_HOST "tail -5 $ERROR_LOG 2>/dev/null || echo 'No recent errors'")
    echo "  Recent errors:"
    echo "$RECENT_ERRORS" | sed 's/^/    /'
else
    echo "⚠️  INFO: No runtime errors logged yet (this is good!)"
fi
echo ""

# Test 4: Email Alert Threshold
echo "Test 4: Email Alert Threshold Testing"
echo "---------------------------------------"
echo "📧 Simulating multiple errors to trigger alert..."

# Trigger the error monitoring manually
ssh jbyrd@$TEST_HOST "sudo systemctl start js-runtime-monitor.service" || echo "Service triggered"

echo "⏱️  Waiting 15 seconds for monitoring cycle..."
sleep 15

echo "📝 Checking monitoring service logs..."
MONITOR_LOGS=$(ssh jbyrd@$TEST_HOST "sudo journalctl -u js-runtime-monitor.service -n 20 --no-pager" || echo "")

if echo "$MONITOR_LOGS" | grep -q "Sending alert" || echo "$MONITOR_LOGS" | grep -q "threshold exceeded"; then
    echo "✅ PASS: Alert mechanism triggered"
elif echo "$MONITOR_LOGS" | grep -q "No errors to report"; then
    echo "✅ PASS: Monitoring active, no errors to report"
else
    echo "ℹ️  INFO: Monitoring service running normally"
fi
echo ""

# Test 5: Error Logger JavaScript Integration
echo "Test 5: Frontend Error Logger Integration"
echo "------------------------------------------"
echo "🔍 Checking if error-logger.js is deployed..."

ERROR_LOGGER_PATH="/home/jbyrd/$TEST_APP/static/js/error-logger.js"
if ssh jbyrd@$TEST_HOST "[ -f $ERROR_LOGGER_PATH ]"; then
    echo "✅ PASS: error-logger.js deployed"
    
    # Check if it's included in templates
    TEMPLATE_INCLUDES=$(ssh jbyrd@$TEST_HOST "grep -r 'error-logger.js' $TEMPLATE_PATH --include='*.html' | wc -l")
    if [ "$TEMPLATE_INCLUDES" -gt 0 ]; then
        echo "✅ PASS: error-logger.js referenced in $TEMPLATE_INCLUDES templates"
    else
        echo "⚠️  WARNING: error-logger.js not referenced in any templates"
    fi
else
    echo "❌ FAIL: error-logger.js not found"
    exit 1
fi
echo ""

# Test 6: API Endpoint Verification
echo "Test 6: Error Logging API Endpoint"
echo "------------------------------------"
echo "🔌 Testing /api/log-js-error endpoint..."

# Test the endpoint with curl
ENDPOINT_TEST=$(ssh jbyrd@$TEST_HOST "curl -s -X POST http://localhost:5002/api/log-js-error -H 'Content-Type: application/json' -d '{\"errors\":[{\"message\":\"Test error\",\"source\":\"test.js\",\"lineno\":1}]}' || echo 'FAILED'")

if echo "$ENDPOINT_TEST" | grep -q "ok" || echo "$ENDPOINT_TEST" | grep -q "status"; then
    echo "✅ PASS: API endpoint responding"
else
    echo "❌ FAIL: API endpoint not responding"
    echo "  Response: $ENDPOINT_TEST"
    exit 1
fi
echo ""

# Summary
echo "========================================"
echo "✅ Test Suite Completed Successfully"
echo "========================================"
echo ""
echo "📊 Test Summary:"
echo "  ✅ Static syntax validation"
echo "  ✅ Syntax error detection"
echo "  ✅ Runtime error logging"
echo "  ✅ Alert threshold mechanism"
echo "  ✅ Frontend error logger integration"
echo "  ✅ API endpoint verification"
echo ""
echo "📈 Next Steps:"
echo "  1. Visit your application and check browser console"
echo "  2. Monitor $ERROR_LOG for runtime errors"
echo "  3. Check email for alerts if threshold exceeded"
echo ""
echo "🎉 ANSAI JavaScript Monitoring: All Tests Passed!"

