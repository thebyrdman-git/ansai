# CSS Error Monitoring System

> **Automatically detect, log, and alert on CSS errors across your entire infrastructure**

## 🎯 Overview

This system provides **two-layer CSS error detection**:

1. **Template & Syntax Validation** (Pre-deployment)
   - Scans templates for missing CSS file references
   - Validates CSS syntax (braces, colors, properties)
   - Catches issues before they reach production
   - Runs automatically every 30 minutes

2. **Runtime Monitoring** (Production)
   - Captures real CSS errors from user browsers
   - Detects 404s, CORS errors, font failures
   - Monitors background image loading
   - Runs automatically every 15 minutes

## 🚀 Quick Start

### 1. Deploy the Monitoring System

```bash
cd /home/jbyrd/miraclemax-infrastructure/ansible
ansible-playbook playbooks/deploy-css-monitoring.yml
```

### 2. Add Flask Endpoint to Your Apps

Add this to `story-stages/src/app.py` and `passgo/src/app.py`:

```python
# CSS error logging endpoint
css_error_logger = logging.getLogger('css_errors')
css_error_handler = logging.FileHandler('/var/log/css-runtime-errors/{app_name}_errors.log')
css_error_handler.setFormatter(logging.Formatter('%(asctime)s - %(message)s'))
css_error_logger.addHandler(css_error_handler)
css_error_logger.setLevel(logging.INFO)

@app.route('/api/log-css-error', methods=['POST'])
def log_css_error():
    """Endpoint to receive CSS errors from frontend"""
    try:
        data = request.get_json()
        errors = data.get('errors', [])
        
        for error in errors:
            css_error_logger.error(json.dumps(error))
        
        return jsonify({'status': 'ok', 'received': len(errors)}), 200
    except Exception as e:
        logger.error(f"Failed to log CSS error: {e}")
        return jsonify({'status': 'error', 'message': str(e)}), 500
```

### 3. Add CSS Monitor to Your Templates

Add this to the `<head>` section of your templates:

```html
<script src="/static/js/css-monitor.js"></script>
```

### 4. Restart Your Applications

```bash
ssh jbyrd@miraclemax.local "sudo systemctl restart story-stages passgo"
```

## 📊 Monitoring Features

### Template Validation
- **Checks for:**
  - Missing CSS files referenced in templates
  - Mismatched braces in inline `<style>` blocks
  - Broken CSS file references
  
- **Schedule:** Every 30 minutes
- **Alerts:** Email when errors detected

### CSS Syntax Validation
- **Checks for:**
  - Mismatched braces in CSS files
  - Missing semicolons
  - Invalid color values
  - Syntax errors
  
- **Schedule:** Every 30 minutes
- **Alerts:** Email when errors detected

### Runtime Monitoring
- **Captures:**
  - Failed CSS file loads (404 errors)
  - CORS errors with external stylesheets
  - Font loading failures
  - Broken background images
  
- **Threshold:** Alerts after 3 errors in 60 minutes
- **Schedule:** Checks every 15 minutes

## 🛠️ Manual Commands

### Run CSS Validation Manually
```bash
ssh jbyrd@miraclemax.local "sudo /usr/local/bin/css-validator.sh"
```

### Check Runtime CSS Errors
```bash
ssh jbyrd@miraclemax.local "sudo /usr/local/bin/runtime-css-monitor.sh"
```

### View Validation Logs
```bash
ssh jbyrd@miraclemax.local "sudo journalctl -u css-validation.service -f"
```

### View Runtime Monitor Logs
```bash
ssh jbyrd@miraclemax.local "sudo journalctl -u css-runtime-monitor.service -f"
```

### Check Error Logs
```bash
# Story Stages CSS errors
ssh jbyrd@miraclemax.local "sudo tail -f /var/log/css-runtime-errors/story-stages_errors.log"

# PassGo CSS errors
ssh jbyrd@miraclemax.local "sudo tail -f /var/log/css-runtime-errors/passgo_errors.log"

# CSS validation errors
ssh jbyrd@miraclemax.local "sudo tail -f /var/log/css-validation/errors.log"
```

### Check Timer Status
```bash
ssh jbyrd@miraclemax.local "systemctl list-timers | grep -E '(css-validation|css-runtime-monitor)'"
```

## 📧 Email Alerts

You'll receive email alerts for:
- ✉️ Missing CSS files in templates (immediate)
- ✉️ CSS syntax errors (immediate)
- ✉️ Runtime CSS errors exceeding threshold (max 1/hour)

**Cooldown:** 1 hour between similar alerts to prevent spam

## 🔧 Configuration

Edit `/home/jbyrd/miraclemax-infrastructure/ansible/roles/css_error_monitoring/defaults/main.yml`:

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
ansible-playbook playbooks/deploy-css-monitoring.yml
```

## 🧪 Testing

### Test Template Validation
1. Add a reference to a non-existent CSS file in a template:
```html
<link rel="stylesheet" href="/static/css/nonexistent.css">
```
2. Run: `sudo /usr/local/bin/css-validator.sh`
3. Check for email alert

### Test Runtime Monitoring
1. Visit your site with browser console open (F12)
2. Check for any CSS load failures
3. Wait 15 minutes or run: `sudo /usr/local/bin/runtime-css-monitor.sh`
4. Check for email alert

## 📈 Integration with Self-Healing

This system integrates with your existing self-healing infrastructure:
- Uses same email configuration
- Follows ansai workflows (config-as-code)
- Systemd-based scheduling
- Comprehensive logging

## 🎯 What This Would Have Caught

**Recent Issue:** The `/books` page had a reference to missing `scenes.css`
- ✅ CSS Validator would have detected this **before** you visited the page
- ✅ Email alert sent immediately
- ✅ Specific file and template identified
- ✅ Problem fixed proactively

## 📝 Troubleshooting

### Validator not running?
```bash
ssh jbyrd@miraclemax.local "systemctl status css-validation.timer"
ssh jbyrd@miraclemax.local "sudo systemctl start css-validation.timer"
```

### Monitor not running?
```bash
ssh jbyrd@miraclemax.local "systemctl status css-runtime-monitor.timer"
ssh jbyrd@miraclemax.local "sudo systemctl start css-runtime-monitor.timer"
```

### Not receiving emails?
- Check SMTP settings in `defaults/main.yml`
- Test email: `sudo /usr/local/bin/css-validator.sh`
- Check logs: `sudo journalctl -u css-validation.service`

---

**Your CSS is now under constant surveillance! 🎨🛡️**
