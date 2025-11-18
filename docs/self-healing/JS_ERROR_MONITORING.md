# JavaScript Error Monitoring System

> **Automatically detect, log, and alert on JavaScript errors across your entire infrastructure**

## 🎯 Overview

This system provides **two-layer JavaScript error detection**:

1. **Template Validation** (Pre-deployment)
   - Scans templates for JavaScript syntax errors
   - Catches issues before they reach production
   - Runs automatically every 30 minutes

2. **Runtime Monitoring** (Production)
   - Captures real JavaScript errors from user browsers
   - Aggregates errors and sends alerts
   - Runs automatically every 15 minutes

## 🚀 Quick Start

### 1. Deploy the Monitoring System

```bash
cd /home/jbyrd/miraclemax-infrastructure/ansible
ansible-playbook playbooks/deploy-js-monitoring.yml
```

### 2. Add Flask Endpoints to Your Apps

Add this to `story-stages/src/app.py` and `passgo/src/app.py`:

```python
import json
import logging
from datetime import datetime

# Configure JS error logging
js_error_logger = logging.getLogger('js_errors')
js_error_handler = logging.FileHandler('/var/log/js-runtime-errors/{app_name}_errors.log')
js_error_handler.setFormatter(logging.Formatter('%(asctime)s - %(message)s'))
js_error_logger.addHandler(js_error_handler)
js_error_logger.setLevel(logging.INFO)

@app.route('/api/log-js-error', methods=['POST'])
def log_js_error():
    """Endpoint to receive JavaScript errors from frontend"""
    try:
        data = request.get_json()
        errors = data.get('errors', [])
        
        for error in errors:
            js_error_logger.error(json.dumps(error))
        
        return jsonify({'status': 'ok', 'received': len(errors)}), 200
    except Exception as e:
        app.logger.error(f"Failed to log JS error: {e}")
        return jsonify({'status': 'error', 'message': str(e)}), 500
```

### 3. Add Error Logger to Your Templates

Add this to the `<head>` section of your base templates:

**For story-stages (`templates/base.html` or `dashboard.html`):**
```html
<script src="{{ url_for('static', filename='js/error-logger.js') }}"></script>
```

**For passgo:**
```html
<script src="{{ url_for('static', filename='js/error-logger.js') }}"></script>
```

### 4. Create Static JS Directory (if needed)

```bash
ssh jbyrd@miraclemax.local "mkdir -p /home/jbyrd/story-stages/static/js"
ssh jbyrd@miraclemax.local "mkdir -p /home/jbyrd/passgo/static/js"
```

### 5. Restart Your Applications

```bash
ssh jbyrd@miraclemax.local "sudo systemctl restart story-stages passgo"
```

## 📊 Monitoring Features

### Template Validation
- **Checks for:**
  - Unescaped quotes in JavaScript strings
  - Mismatched braces in `<script>` blocks
  - Common syntax errors
  
- **Schedule:** Every 30 minutes
- **Alerts:** Email when errors detected

### Runtime Monitoring
- **Captures:**
  - Uncaught exceptions
  - Unhandled promise rejections
  - Console errors
  
- **Threshold:** Alerts after 3 errors in 60 minutes
- **Schedule:** Checks every 15 minutes

## 🛠️ Manual Commands

### Run Validation Manually
```bash
ssh jbyrd@miraclemax.local "sudo /usr/local/bin/js-validator.sh"
```

### Check Runtime Errors
```bash
ssh jbyrd@miraclemax.local "sudo /usr/local/bin/runtime-error-monitor.sh"
```

### View Validation Logs
```bash
ssh jbyrd@miraclemax.local "sudo journalctl -u js-validation.service -f"
```

### View Runtime Monitor Logs
```bash
ssh jbyrd@miraclemax.local "sudo journalctl -u js-runtime-monitor.service -f"
```

### Check Error Logs
```bash
# Story Stages errors
ssh jbyrd@miraclemax.local "sudo tail -f /var/log/js-runtime-errors/story-stages_errors.log"

# PassGo errors
ssh jbyrd@miraclemax.local "sudo tail -f /var/log/js-runtime-errors/passgo_errors.log"

# Validation errors
ssh jbyrd@miraclemax.local "sudo tail -f /var/log/js-validation/errors.log"
```

### Check Timer Status
```bash
ssh jbyrd@miraclemax.local "systemctl list-timers | grep -E '(js-validation|js-runtime-monitor)'"
```

## 📧 Email Alerts

You'll receive email alerts for:
- ✉️ Template validation failures (immediate)
- ✉️ Runtime errors exceeding threshold (max 1/hour)

**Cooldown:** 1 hour between similar alerts to prevent spam

## 🔧 Configuration

Edit `/home/jbyrd/miraclemax-infrastructure/ansible/roles/js_error_monitoring/defaults/main.yml`:

```yaml
# Email settings
owner_email: jimmykbyrd@gmail.com

# Schedules (cron format)
validation_schedule: "*/30 * * * *"  # Every 30 minutes
runtime_check_schedule: "*/15 * * * *"  # Every 15 minutes

# Thresholds
max_errors_before_alert: 3
error_lookback_minutes: 60
```

After changes, redeploy:
```bash
ansible-playbook playbooks/deploy-js-monitoring.yml
```

## 🧪 Testing

### Test Template Validation
1. Introduce a syntax error in a template
2. Run: `sudo /usr/local/bin/js-validator.sh`
3. Check for email alert

### Test Runtime Monitoring
1. Add this to a page to trigger an error:
```html
<script>
    throw new Error('Test error for monitoring');
</script>
```
2. Visit the page
3. Wait 15 minutes or run: `sudo /usr/local/bin/runtime-error-monitor.sh`
4. Check for email alert

## 📈 Integration with Self-Healing

This system integrates with your existing self-healing infrastructure:
- Uses same email configuration
- Follows ansai workflows (config-as-code)
- Systemd-based scheduling
- Comprehensive logging

## 🎯 Benefits

✅ **Proactive Detection** - Catch errors before users report them  
✅ **Automated Alerts** - Know immediately when something breaks  
✅ **Production Monitoring** - See real errors from real users  
✅ **Template Safety** - Validate before deployment  
✅ **Zero Maintenance** - Fully automated, runs in background  

## 📝 Troubleshooting

### Validator not running?
```bash
ssh jbyrd@miraclemax.local "systemctl status js-validation.timer"
ssh jbyrd@miraclemax.local "sudo systemctl start js-validation.timer"
```

### Monitor not running?
```bash
ssh jbyrd@miraclemax.local "systemctl status js-runtime-monitor.timer"
ssh jbyrd@miraclemax.local "sudo systemctl start js-runtime-monitor.timer"
```

### Not receiving emails?
- Check SMTP settings in `defaults/main.yml`
- Test email: `sudo /usr/local/bin/js-validator.sh`
- Check logs: `sudo journalctl -u js-validation.service`

---

**Your JavaScript is now under constant surveillance! 🔍🛡️**

