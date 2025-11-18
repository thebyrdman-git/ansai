#!/bin/bash
# ANSAI Self-Healing - Master Test Runner
# Runs all self-healing component tests

set -e

echo "╔════════════════════════════════════════════════════════╗"
echo "║     ANSAI Self-Healing Test Suite - Full Run          ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

# Configuration
TEST_HOST="${1:-miraclemax.local}"
TEST_EMAIL="${2:-jimmykbyrd@gmail.com}"
TEST_APP="${3:-story-stages}"

echo "🎯 Test Configuration:"
echo "  Host: $TEST_HOST"
echo "  Email: $TEST_EMAIL"
echo "  Test App: $TEST_APP"
echo ""

# Test results tracking
TESTS_PASSED=0
TESTS_FAILED=0
TESTS_WARNED=0

# Function to run test and track results
run_test() {
    local test_name="$1"
    local test_script="$2"
    
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "  Running: $test_name"
    echo "════════════════════════════════════════════════════════"
    echo ""
    
    if ./$test_script "$TEST_APP" "$TEST_HOST" "$TEST_EMAIL"; then
        echo ""
        echo "✅ $test_name: PASSED"
        ((TESTS_PASSED++))
    else
        echo ""
        echo "❌ $test_name: FAILED"
        ((TESTS_FAILED++))
    fi
}

# Pre-flight checks
echo "🔍 Pre-flight Checks"
echo "════════════════════════════════════════════════════════"

# Check SSH connectivity
echo "  Testing SSH connection to $TEST_HOST..."
if ssh -q jbyrd@$TEST_HOST "exit" 2>/dev/null; then
    echo "  ✅ SSH connection successful"
else
    echo "  ❌ Cannot connect to $TEST_HOST via SSH"
    exit 1
fi

# Check if test scripts exist
SCRIPT_COUNT=$(ls -1 test-*.sh 2>/dev/null | wc -l)
echo "  Found $SCRIPT_COUNT test scripts"
echo ""

# Run all tests
echo "🚀 Running Test Suite"
echo "════════════════════════════════════════════════════════"
echo ""

# Test 1: Universal Service Healing
run_test "Universal Service Healing" "test-service-healing.sh"

# Test 2: JavaScript Error Monitoring
run_test "JavaScript Error Monitoring" "test-js-monitoring.sh"

# Test 3: CSS Error Monitoring
run_test "CSS Error Monitoring" "test-css-monitoring.sh"

# Test 4: External Monitoring
run_test "Healthchecks.io External Monitoring" "test-healthchecks.sh"

# Final Summary
echo ""
echo "╔════════════════════════════════════════════════════════╗"
echo "║              TEST SUITE SUMMARY                         ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""
echo "📊 Results:"
echo "  ✅ Tests Passed:  $TESTS_PASSED"
echo "  ❌ Tests Failed:  $TESTS_FAILED"
echo ""

if [ $TESTS_FAILED -eq 0 ]; then
    echo "🎉 ALL TESTS PASSED!"
    echo ""
    echo "✅ Your ANSAI Self-Healing infrastructure is fully operational"
    echo ""
    echo "📦 Next Steps:"
    echo "  1. Review any warnings from individual tests"
    echo "  2. Check your email for test alerts"
    echo "  3. Monitor services for 24 hours"
    echo "  4. Ready to package and deploy!"
    echo ""
    exit 0
else
    echo "⚠️  SOME TESTS FAILED"
    echo ""
    echo "📋 Action Items:"
    echo "  1. Review failed test output above"
    echo "  2. Check service logs on $TEST_HOST"
    echo "  3. Verify Ansible deployment completed"
    echo "  4. Re-run individual tests after fixes"
    echo ""
    exit 1
fi

