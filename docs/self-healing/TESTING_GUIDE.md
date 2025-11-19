# 🧪 ANSAI Self-Healing Testing Guide

## Overview

This guide covers comprehensive testing of all ANSAI Self-Healing components before packaging and distribution.

## Testing Philosophy

ANSAI follows the **test-as-code** principle:

- ✅ **Automated**: Tests run without manual intervention
- ✅ **Repeatable**: Same results every time
- ✅ **Comprehensive**: Cover all failure scenarios
- ✅ **Self-documenting**: Tests explain what they verify

## Quick Start

### Run All Tests

```bash
cd ~/ansai/orchestrators/ansible/tests
./run-all-tests.sh miraclemax.local jimmykbyrd@gmail.com story-stages
```

### Run Individual Tests

```bash
# Test universal service healing
./test-service-healing.sh passgo miraclemax.local jimmykbyrd@gmail.com

# Test JavaScript monitoring
./test-js-monitoring.sh story-stages miraclemax.local jimmykbyrd@gmail.com

# Test CSS monitoring
./test-css-monitoring.sh story-stages miraclemax.local jimmykbyrd@gmail.com

# Test Healthchecks.io integration
./test-healthchecks.sh miraclemax.local YOUR_HEALTHCHECK_URL
```

## Test Components

### 1. Universal Service Healing Tests

**What it tests:**
- Service restart automation
- Email alert delivery
- Log verification
- Post-healing health checks
- Exponential backoff handling

**Expected results:**
- Service automatically restarts after failure
- Email alert received within 30 seconds
- Detailed recovery logs generated
- Service remains healthy after restart
- Rapid failures handled with backoff

**Duration:** ~2 minutes

### 2. JavaScript Error Monitoring Tests

**What it tests:**
- Static syntax validation
- Syntax error detection
- Runtime error logging
- Alert threshold mechanism
- Frontend error logger integration
- API endpoint verification

**Expected results:**
- Syntax errors detected in templates
- Runtime errors captured from browser
- Alerts sent when threshold exceeded
- error-logger.js deployed and active
- API endpoint responding correctly

**Duration:** ~3 minutes

### 3. CSS Error Monitoring Tests

**What it tests:**
- Static CSS file validation
- Missing file detection
- Runtime CSS loading monitoring
- Frontend CSS monitor integration
- API endpoint verification
- Monitoring service status

**Expected results:**
- Missing CSS files detected
- Runtime loading failures captured
- css-monitor.js deployed and active
- API endpoint responding correctly
- Monitoring timers active

**Duration:** ~2 minutes

### 4. Healthchecks.io External Monitoring Tests

**What it tests:**
- Heartbeat script deployment
- Cron job configuration
- Manual heartbeat ping
- Heartbeat log verification
- Service status reporting
- Failure detection
- Dashboard verification
- Alert notification configuration

**Expected results:**
- Heartbeat sent successfully
- Cron job running every 5 minutes
- Service failures detected and reported
- Healthchecks.io dashboard shows "Up"
- Email notifications configured

**Duration:** ~5 minutes (includes manual verification)

## Test Failure Scenarios

### Service Healing Test Failures

**Symptom:** Service doesn't restart automatically

**Troubleshooting:**
1. Check if OnFailure hook is configured:
   ```bash
   systemctl cat passgo.service | grep OnFailure
   ```

2. Verify self-healing script exists:
   ```bash
   ls -la /usr/local/bin/universal-self-heal.sh
   ```

3. Check self-healing service logs:
   ```bash
   sudo journalctl -u passgo-self-heal.service -n 50
   ```

**Symptom:** No email alert received

**Troubleshooting:**
1. Check SMTP configuration in Ansible vars
2. Verify email credentials are correct
3. Check for SMTP errors in logs:
   ```bash
   sudo journalctl -u passgo-self-heal.service | grep "SMTP\|email"
   ```

### JavaScript Monitoring Test Failures

**Symptom:** Syntax errors not detected

**Troubleshooting:**
1. Verify js-beautify is installed:
   ```bash
   which js-beautify
   ```

2. Run validator manually:
   ```bash
   sudo /usr/local/bin/js-validator.sh
   ```

3. Check validator logs:
   ```bash
   sudo cat /var/log/js-validation.log
   ```

**Symptom:** Runtime errors not captured

**Troubleshooting:**
1. Verify error-logger.js exists:
   ```bash
   ls -la /var/www/story-stages/static/js/error-logger.js
   ```

2. Check if templates include error-logger.js:
   ```bash
   grep -r "error-logger.js" /var/www/story-stages/templates/
   ```

3. Test API endpoint:
   ```bash
   curl -X POST http://localhost:5002/api/log-js-error \
     -H 'Content-Type: application/json' \
     -d '{"errors":[{"message":"test"}]}'
   ```

### CSS Monitoring Test Failures

**Symptom:** Missing CSS files not detected

**Troubleshooting:**
1. Run CSS validator manually:
   ```bash
   sudo /usr/local/bin/css-validator.sh
   ```

2. Check static file paths:
   ```bash
   ls -la /var/www/story-stages/static/css/
   ```

**Symptom:** Runtime monitoring not working

**Troubleshooting:**
1. Verify css-monitor.js exists and is included
2. Check CSS error logs:
   ```bash
   sudo tail -f /var/log/css-runtime-errors/story-stages_errors.log
   ```

### Healthchecks.io Test Failures

**Symptom:** Heartbeat not reaching Healthchecks.io

**Troubleshooting:**
1. Verify ping URL is correct:
   ```bash
   grep "HEALTHCHECK_URL" /usr/local/bin/miraclemax-heartbeat.sh
   ```

2. Test heartbeat manually:
   ```bash
   /usr/local/bin/miraclemax-heartbeat.sh
   ```

3. Check for network issues:
   ```bash
   curl -I https://hc-ping.com
   ```

## Pre-Packaging Checklist

Before packaging for GitHub distribution, ensure:

- [ ] All tests pass on clean system
- [ ] Email alerts working correctly
- [ ] Logs are generated properly
- [ ] Documentation is complete
- [ ] Ansible variables have examples
- [ ] Sensitive data removed from examples
- [ ] LICENSE file included
- [ ] CONTRIBUTING.md present
- [ ] README.md comprehensive

## Continuous Testing

### Set Up Test Environment

For ongoing development, set up a dedicated test environment:

```bash
# Create test VM or container
# Install base system
# Deploy self-healing components
# Run tests after each change
```

### Automated Testing in CI/CD

See GitHub Actions workflow in `.github/workflows/test-self-healing.yml` for automated testing on every commit.

## Test Coverage

Current test coverage:

| Component | Static Tests | Runtime Tests | Integration Tests | Coverage |
|-----------|--------------|---------------|-------------------|----------|
| Universal Self-Healing | ✅ | ✅ | ✅ | 100% |
| JS Error Monitoring | ✅ | ✅ | ✅ | 100% |
| CSS Error Monitoring | ✅ | ✅ | ✅ | 100% |
| External Monitoring | ✅ | ✅ | ✅ | 100% |
| System Admin (Future) | 🚧 | 🚧 | 🚧 | 0% |

## Contributing Tests

When adding new self-healing components, create corresponding test scripts:

1. **Copy existing test template**
   ```bash
   cp test-service-healing.sh test-new-component.sh
   ```

2. **Modify for new component**
   - Update test descriptions
   - Add component-specific checks
   - Verify error conditions
   - Test remediation actions

3. **Add to master test runner**
   ```bash
   vim run-all-tests.sh
   # Add: run_test "New Component" "test-new-component.sh"
   ```

4. **Document expected behavior**
   - Add to this testing guide
   - Include troubleshooting steps
   - Provide example output

## Best Practices

### Test Isolation

- Each test should be independent
- Clean up test artifacts after run
- Restore original state on failure

### Test Timing

- Allow sufficient time for async operations
- Use appropriate sleep intervals
- Account for exponential backoff

### Test Reporting

- Clear pass/fail indicators
- Detailed error messages
- Actionable troubleshooting steps

### Test Maintenance

- Update tests when code changes
- Keep test scripts version-controlled
- Review test failures promptly

---

**Following ANSAI Everything-as-Code Philosophy** 🚀

*Test early, test often, test automatically.*

