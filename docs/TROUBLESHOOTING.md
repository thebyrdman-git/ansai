# Troubleshooting Guide

Common issues and solutions for ANSAI installation and deployment.

---

## 📋 Quick Diagnostics

Before diving into specific issues, run these diagnostic commands:

```bash
# Check ANSAI installation
which ansai-progress-tracker
echo $ANSAI_DIR

# Check AI backend
curl http://localhost:4000/health  # LiteLLM
fabric --version  # Fabric

# Check Ansible
ansible --version
ansible all -i ~/.ansai/orchestrators/ansible/inventory/hosts.yml -m ping

# Check systemd on target server
ssh your-server "systemctl --version"
```

---

## 🔧 Installation Issues

### Issue: "command not found: ansai-*"

**Cause:** ANSAI not in PATH

**Solution:**
```bash
# Add to PATH manually
export PATH="$HOME/.ansai/bin:$PATH"

# Make permanent
echo 'export PATH="$HOME/.ansai/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Verify
which ansai-progress-tracker
```

### Issue: Installation script fails with "git: command not found"

**Cause:** Git not installed

**Solution:**
```bash
# Ubuntu/Debian
sudo apt update && sudo apt install -y git

# Fedora/RHEL
sudo dnf install -y git

# macOS
brew install git

# Verify
git --version
```

### Issue: "Python 3 not found"

**Cause:** Python 3 not installed or not in PATH

**Solution:**
```bash
# Ubuntu/Debian
sudo apt install -y python3 python3-pip

# Fedora/RHEL
sudo dnf install -y python3 python3-pip

# macOS
brew install python3

# Verify
python3 --version
pip3 --version
```

### Issue: Installation script fails with "Permission denied"

**Cause:** Insufficient permissions to create directories

**Solution:**
```bash
# Ensure HOME is writable
ls -ld $HOME

# If using sudo (don't!), install as regular user:
curl -sSL https://raw.githubusercontent.com/thebyrdman-git/ansai/main/install.sh | bash

# If .ansai directory has wrong permissions
chmod -R u+rwX ~/.ansai
```

---

## 🤖 AI Backend Issues

### Issue: LiteLLM not starting

**Symptoms:**
```bash
curl http://localhost:4000/health
# curl: (7) Failed to connect to localhost port 4000: Connection refused
```

**Solution 1: Check if port is in use**
```bash
# Find process using port 4000
lsof -i :4000

# Kill existing process
kill -9 $(lsof -t -i :4000)

# Restart LiteLLM
litellm --config ~/.config/ansai/litellm_config.yaml --port 4000
```

**Solution 2: Check config file**
```bash
# Verify config exists
cat ~/.config/ansai/litellm_config.yaml

# Test config syntax
python3 << 'EOF'
import yaml
with open('/home/$USER/.config/ansai/litellm_config.yaml') as f:
    config = yaml.safe_load(f)
    print("✅ Config valid:", config)
EOF
```

**Solution 3: Check API keys**
```bash
# Verify API keys are set
echo $OPENAI_API_KEY
echo $ANTHROPIC_API_KEY

# Test API key
curl https://api.openai.com/v1/models \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  | jq '.data[0].id'
# Should return a model name
```

**Solution 4: Run in foreground for debugging**
```bash
# Run without background process
litellm --config ~/.config/ansai/litellm_config.yaml --port 4000 --debug

# Watch for errors
```

### Issue: Fabric not installed or not found

**Symptoms:**
```bash
fabric --version
# bash: fabric: command not found
```

**Solution:**
```bash
# Install with pipx (recommended)
pip3 install --user pipx
pipx ensurepath
pipx install fabric-ai

# Or with pip
pip3 install --user fabric-ai

# Verify
fabric --version

# Set up patterns
fabric --setup
```

### Issue: "API key invalid" errors

**Symptoms:**
```
litellm.exceptions.AuthenticationError: OpenAI: Invalid API key
```

**Solution:**
```bash
# Verify API key format
echo $OPENAI_API_KEY | wc -c
# OpenAI keys should be ~51 characters

# Test API key directly
curl https://api.openai.com/v1/models \
  -H "Authorization: Bearer $OPENAI_API_KEY"

# If invalid, generate new key:
# OpenAI: https://platform.openai.com/api-keys
# Anthropic: https://console.anthropic.com/settings/keys
# Groq: https://console.groq.com/keys
```

### Issue: Local Ollama models not working

**Symptoms:**
```
litellm.exceptions.APIConnectionError: ollama: Connection refused
```

**Solution:**
```bash
# Check if Ollama is running
ps aux | grep ollama

# Start Ollama
ollama serve &

# Pull a model
ollama pull llama3

# Test directly
ollama run llama3 "Hello"

# Verify LiteLLM can connect
curl http://localhost:11434/api/tags
```

---

## 📡 Ansible Issues

### Issue: "provided hosts list is empty"

**Symptoms:**
```
[WARNING]: provided hosts list is empty, only localhost is available
```

**Solution:**
```bash
# Check inventory file exists
cat ~/.ansai/orchestrators/ansible/inventory/hosts.yml

# Verify syntax
ansible-inventory -i ~/.ansai/orchestrators/ansible/inventory/hosts.yml --list

# Example correct inventory:
cat > ~/.ansai/orchestrators/ansible/inventory/hosts.yml << 'EOF'
all:
  children:
    servers:
      hosts:
        my-server:
          ansible_host: 192.168.1.100
          ansible_user: your-username
          ansible_become: true
EOF
```

### Issue: "role 'universal_self_heal' was not found"

**Symptoms:**
```
ERROR! the role 'universal_self_heal' was not found
```

**Solution:**
```bash
# Check roles directory exists
ls -la ~/.ansai/orchestrators/ansible/roles/

# Should see:
# - universal_self_heal/
# - js_error_monitoring/
# - css_error_monitoring/
# - healthchecks_monitoring/

# If missing, reinstall ANSAI
cd ~/.ansai
git pull origin main

# Verify roles exist
ls -la orchestrators/ansible/roles/
```

### Issue: "Permission denied" or "Authentication failed"

**Symptoms:**
```
UNREACHABLE! => {"msg": "Failed to connect to the host via ssh: Permission denied (publickey,password)"}
```

**Solution 1: Test SSH connection**
```bash
# Test manual SSH
ssh your-username@192.168.1.100

# If password prompt, add SSH key:
ssh-copy-id your-username@192.168.1.100
```

**Solution 2: Verify inventory settings**
```yaml
# In hosts.yml, ensure correct user
all:
  children:
    servers:
      hosts:
        my-server:
          ansible_host: 192.168.1.100
          ansible_user: your-username  # Must match SSH user
          ansible_ssh_private_key_file: ~/.ssh/id_rsa  # If using key
```

**Solution 3: Check sudo access**
```bash
# Test sudo on target
ssh your-username@192.168.1.100 "sudo whoami"
# Should return: root

# If password required, add to inventory:
ansible_become: true
ansible_become_method: sudo
ansible_become_password: "your-sudo-password"  # Not recommended, use NOPASSWD in sudoers
```

### Issue: Ansible playbook fails with "Module not found"

**Symptoms:**
```
ERROR! couldn't resolve module/action 'community.general.xyz'
```

**Solution:**
```bash
# Install missing Ansible collections
ansible-galaxy collection install community.general
ansible-galaxy collection install ansible.posix

# Verify installed
ansible-galaxy collection list
```

---

## 📧 Email Alert Issues

### Issue: No email alerts received

**Symptoms:**
- Self-healing works, but no emails

**Solution 1: Test email configuration**
```bash
# Test SMTP settings
python3 << 'EOF'
import smtplib
from email.mime.text import MIMEText
import os

msg = MIMEText("Test from ANSAI")
msg['Subject'] = "ANSAI Test Email"
msg['From'] = os.environ.get('ANSAI_SMTP_USER', 'test@example.com')
msg['To'] = os.environ.get('ANSAI_ADMIN_EMAIL', 'admin@example.com')

try:
    with smtplib.SMTP(os.environ['ANSAI_SMTP_SERVER'], int(os.environ['ANSAI_SMTP_PORT'])) as server:
        server.set_debuglevel(1)  # Show debug output
        server.starttls()
        server.login(os.environ['ANSAI_SMTP_USER'], os.environ['ANSAI_SMTP_PASSWORD'])
        server.send_message(msg)
    print("✅ Email sent successfully!")
except Exception as e:
    print(f"❌ Email failed: {e}")
EOF
```

**Solution 2: Check environment variables**
```bash
# Verify all required vars are set
echo "Email: $ANSAI_ADMIN_EMAIL"
echo "SMTP Server: $ANSAI_SMTP_SERVER"
echo "SMTP Port: $ANSAI_SMTP_PORT"
echo "SMTP User: $ANSAI_SMTP_USER"
echo "SMTP Password: ${ANSAI_SMTP_PASSWORD:0:5}..."  # Show first 5 chars

# If any are blank, set them
export ANSAI_ADMIN_EMAIL="your-email@example.com"
export ANSAI_SMTP_SERVER="smtp.gmail.com"
export ANSAI_SMTP_PORT="587"
export ANSAI_SMTP_USER="your-email@gmail.com"
export ANSAI_SMTP_PASSWORD="your-app-password"
```

**Solution 3: Gmail-specific issues**
```bash
# For Gmail, use App Password (not your regular password)
# 1. Enable 2FA: https://myaccount.google.com/security
# 2. Generate App Password: https://myaccount.google.com/apppasswords
# 3. Use the 16-character app password

export ANSAI_SMTP_PASSWORD="xxxx xxxx xxxx xxxx"  # App password

# Verify with test script above
```

**Solution 4: Check firewall**
```bash
# Ensure port 587 (SMTP) is open
sudo firewall-cmd --list-ports

# Add if needed
sudo firewall-cmd --permanent --add-port=587/tcp
sudo firewall-cmd --reload

# Or test from server
ssh your-server "telnet smtp.gmail.com 587"
```

### Issue: Emails sent but not received

**Symptoms:**
- No errors in logs
- Emails don't arrive

**Solution 1: Check spam folder**
- Look in spam/junk folder
- Add `noreply@your-server` to contacts

**Solution 2: Check email logs on server**
```bash
ssh your-server "sudo journalctl -u '*self-heal*' | grep -i email"
ssh your-server "sudo tail -f /var/log/maillog"  # If using system mail
```

**Solution 3: Verify From address**
```bash
# Some SMTP servers require From address to match authenticated user
# Check self-healing script:
ssh your-server "sudo cat /usr/local/bin/universal-self-heal.sh | grep 'From:'"
```

---

## 🛡️ Self-Healing Issues

### Issue: Services not healing automatically

**Symptoms:**
- Service stops
- Doesn't restart
- No email received

**Solution 1: Check OnFailure hooks**
```bash
# Verify systemd OnFailure is configured
ssh your-server "systemctl show sshd | grep OnFailure"
# Should show: OnFailure=sshd-self-heal.service

# If missing, redeploy
ansible-playbook playbooks/deploy-ai-powered-monitoring.yml
```

**Solution 2: Check self-healing service**
```bash
# Verify self-heal service exists
ssh your-server "systemctl list-units | grep self-heal"

# Check self-heal service status
ssh your-server "systemctl status sshd-self-heal.service"

# View logs
ssh your-server "sudo journalctl -u sshd-self-heal.service"
```

**Solution 3: Manually trigger self-healing**
```bash
# Stop service to trigger healing
ssh your-server "sudo systemctl stop sshd"

# Watch logs in real-time
ssh your-server "sudo tail -f /var/log/self-heal/sshd.log"

# Should see:
# - Failure detected
# - AI analysis attempt
# - Remediation steps
# - Email sent
```

**Solution 4: Check permissions**
```bash
# Self-healing script must be executable
ssh your-server "ls -la /usr/local/bin/universal-self-heal.sh"
# Should show: -rwxr-xr-x

# Log directory must be writable
ssh your-server "ls -ld /var/log/self-heal"
# Should show: drwxr-xr-x
```

### Issue: Self-healing logs show "AI analysis failed"

**Symptoms:**
```
[ERROR] AI analysis failed: Connection refused
```

**Solution:**
```bash
# AI backend (LiteLLM) must be accessible from target server
# Test connectivity from server:
ssh your-server "curl http://your-litellm-host:4000/health"

# If connection refused:
# 1. Start LiteLLM on accessible host
# 2. Update litellm_url in playbook vars
# 3. Ensure firewall allows port 4000
# 4. Redeploy monitoring
```

---

## 🏥 Health Check Issues

### Issue: Healthchecks.io not receiving pings

**Symptoms:**
- Dead man's switch triggering
- No pings showing on Healthchecks.io dashboard

**Solution 1: Verify ping URL**
```bash
# Check configured ping URL
ssh your-server "sudo cat /etc/default/healthcheck-heartbeat | grep PING_URL"

# Test ping manually
ssh your-server "curl -fsS https://hc-ping.com/your-uuid"
# Should return: OK
```

**Solution 2: Check cron job**
```bash
# Verify cron is running heartbeat
ssh your-server "sudo crontab -l | grep heartbeat"
# Should show: */5 * * * * /usr/local/bin/miraclemax-heartbeat.sh

# Check cron logs
ssh your-server "sudo journalctl -u cron | grep heartbeat"
```

**Solution 3: Check network connectivity**
```bash
# Ensure server can reach Healthchecks.io
ssh your-server "ping -c 1 hc-ping.com"

# Check proxy/firewall
ssh your-server "curl -v https://hc-ping.com/your-uuid"
```

---

## 💻 System Compatibility Issues

### Issue: "systemd not found" error

**Cause:** Target system doesn't use systemd

**Solution:**
ANSAI currently requires systemd for service management.

**Supported systems:**
- Ubuntu 16.04+
- Debian 9+
- Fedora 18+
- RHEL/CentOS 7+
- Arch Linux

**Not supported:**
- Systems using SysV init
- BSD systems (FreeBSD, OpenBSD)
- macOS (for target servers)

### Issue: Python version incompatibility

**Symptoms:**
```
SyntaxError: invalid syntax (f-strings)
```

**Solution:**
```bash
# ANSAI requires Python 3.9+
python3 --version

# Upgrade if needed (Ubuntu example)
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update
sudo apt install python3.11

# Update Ansible inventory
ansible_python_interpreter: /usr/bin/python3.11
```

---

## 🔍 Debugging Tips

### Enable Verbose Logging

```bash
# Ansible verbose mode
ansible-playbook playbooks/deploy-ai-powered-monitoring.yml -vvv

# LiteLLM debug mode
litellm --config ~/.config/ansai/litellm_config.yaml --debug

# Systemd service debug
ssh your-server "sudo systemctl --no-pager status sshd-self-heal.service"
```

### Check All Logs

```bash
# Self-healing logs
ssh your-server "sudo tail -f /var/log/self-heal/*.log"

# Systemd journal
ssh your-server "sudo journalctl -f"

# Healthcheck logs
ssh your-server "sudo tail -f /var/log/healthcheck-heartbeat.log"

# Service-specific logs
ssh your-server "sudo journalctl -u sshd -f"
```

### Test Each Component Individually

```bash
# 1. Test SSH
ssh your-server "echo 'SSH works'"

# 2. Test Ansible
ansible all -i inventory/hosts.yml -m ping

# 3. Test AI backend
curl http://localhost:4000/health

# 4. Test email
# (use Python script from Email section above)

# 5. Test self-healing manually
ssh your-server "sudo /usr/local/bin/universal-self-heal.sh sshd"
```

---

## 📚 Common Error Messages

### "UNREACHABLE! => Connection refused"
**Solution:** Check SSH connectivity, firewall, target server IP

### "ERROR! the role 'X' was not found"
**Solution:** Check `roles_path` in ansible.cfg, reinstall ANSAI

### "ModuleNotFoundError: No module named 'litellm'"
**Solution:** `pip3 install 'litellm[proxy]'`

### "Authentication failed" (LiteLLM)
**Solution:** Check API keys, verify they're valid and have correct permissions

### "Failed to send email: SMTP AUTH extension not supported"
**Solution:** Use port 587 with STARTTLS, not port 25 or 465

### "Service failed to start: Permission denied"
**Solution:** Ensure `ansible_become: true` in inventory, check sudo access

---

## 🆘 Still Having Issues?

### 1. Check Documentation
- **Full Docs:** https://ansai.dev
- **Getting Started:** https://ansai.dev/GETTING_STARTED/
- **Self-Healing:** https://ansai.dev/self-healing/

### 2. Search GitHub Issues
https://github.com/thebyrdman-git/ansai/issues

### 3. Ask the Community
https://github.com/thebyrdman-git/ansai/discussions/categories/q-a

### 4. File a Bug Report
https://github.com/thebyrdman-git/ansai/issues/new

**When reporting issues, include:**
- ANSAI version (`git rev-parse HEAD` in `~/.ansai`)
- OS and version (`cat /etc/os-release`)
- Python version (`python3 --version`)
- Ansible version (`ansible --version`)
- AI backend (LiteLLM, Fabric, Ollama)
- Full error message and logs
- Steps to reproduce

---

**Part of the ANSAI Framework**  
Learn more: https://ansai.dev

