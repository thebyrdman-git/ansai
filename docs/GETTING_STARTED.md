# Getting Started with ANSAI

**From zero to AI-powered automation in 5 minutes.**

---

## 🎯 What You'll Build

By the end of this guide, you'll have:

✅ ANSAI installed and configured
✅ AI backend running (LiteLLM or Fabric)
✅ Your first AI-powered automation deployed
✅ Self-healing services with intelligent diagnostics

**Time required:** 5-10 minutes

---

## 📋 Prerequisites

Before you start, you'll need:

- **Linux or macOS** (Windows via WSL)
- **Python 3.9+** (`python3 --version`)
- **Git** (`git --version`)
- **SSH access** to a server (for deployment)
- **Ansible** (`pip3 install ansible`) – ANSAI uses Ansible playbooks as its automation core
- **At least one AI backend** (OpenAI, Anthropic, Groq, or local Ollama) or plan to run LiteLLM/Fabric

---

## 🚀 Step 1: Install ANSAI (1 minute)

### Quick Install (One-Liner)

```bash
curl -sSL https://ansai.dev/install.sh | bash
```

**Tip:** Run `./prereqs.sh` first to validate Git, Python, pip, curl, SSH, and Ansible before the installer runs. The helper mirrors the installer's checks and exits once everything is ready. macOS users: it installs Homebrew automatically when Ansible is missing so you don’t have to do this manually.

### Installer behavior highlights

- Prompts now accept Enter to proceed with the default answers so you can quickly move through the guided flow.
- The installer runs the prerequisite checker before cloning `~/.ansai`; if something is missing it suggests OS-specific install commands, and on macOS it can install Homebrew + Ansible for you.
- If you prefer to verify prerequisites separately, run `./prereqs.sh` anytime—each check logs the required dependency and, on macOS, bootstraps Homebrew when needed before you rerun the installer.

**Or manual install:**

```bash
# Clone repository
git clone https://github.com/thebyrdman-git/ansai.git ~/.ansai

# Add to PATH
echo 'export PATH="$HOME/.ansai/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Verify installation
ansai-progress-tracker --help
```

**What this does:**
- Clones ANSAI to `~/.ansai`
- Adds ANSAI to your PATH
- Creates config directories
- Checks prerequisites

**✅ You should see:** Welcome message and next steps

---

## 🤖 Step 2: Set Up AI Backend (2 minutes)

**ANSAI requires AI to be useful.** Choose your AI backend:

### Option A: LiteLLM (Multi-Model Routing) ⭐ Recommended

**Best for:** Cost optimization, multi-provider setup

```bash
# Install LiteLLM
pip3 install 'litellm[proxy]'

# Create config
mkdir -p ~/.config/ansai
cat > ~/.config/ansai/litellm_config.yaml << 'EOF'
model_list:
  - model_name: gpt-4o
    litellm_params:
      model: openai/gpt-4o
      api_key: os.environ/OPENAI_API_KEY
      max_tokens: 4096
EOF

# Set API key
export OPENAI_API_KEY="your-api-key-here"

# Start LiteLLM proxy
litellm --config ~/.config/ansai/litellm_config.yaml --port 4000 &
```

**Verify it's working:**
```bash
curl http://localhost:4000/health
# Should return: {"status":"healthy"}
```

### Option B: Fabric (Text Processing Patterns)

**Best for:** Log analysis, text transformation
### Install commands per AI backend

| Backend | Command | Notes |
| --- | --- | --- |
| LiteLLM | `pip3 install 'litellm[proxy]'` | Multi-model proxy (OpenAI, Claude, Groq, local). |
| Fabric | `go install github.com/danielmiessler/fabric/cmd/fabric@latest` | Go-based text-processing engine. |
| OpenAI | `export OPENAI_API_KEY="sk-..."` | Use with LiteLLM or Fabric to call OpenAI models. |
| Anthropic | `export ANTHROPIC_API_KEY="sk-..."` | Configure LiteLLM to route to Claude. |
| Groq | `export GROQ_API_KEY="key..."` | Configure LiteLLM with Groq API endpoint. |
| Ollama | `curl -fsSL https://ollama.ai/install.sh | sh` | Local models, no API key required; configure LiteLLM with `local-llama3`. |


```bash
# Install Fabric (Go binary)
# macOS:
brew install fabric-ai

# Linux (requires Go):
go install github.com/danielmiessler/fabric@latest

# Set up patterns
fabric --setup

# Test it
echo "This is a test log entry" | fabric -p summarize
```

### Option C: Local Ollama (No API Key Required)

**Best for:** Privacy, no costs, offline use

```bash
# Install Ollama
curl -fsSL https://ollama.ai/install.sh | sh

# Pull a model
ollama pull llama3

# Configure LiteLLM to use Ollama
cat > ~/.config/ansai/litellm_config.yaml << 'EOF'
model_list:
  - model_name: local-llama3
    litellm_params:
      model: ollama/llama3
      api_base: http://localhost:11434
      api_key: "sk-ollama"  # Dummy key
EOF

# Start LiteLLM
litellm --config ~/.config/ansai/litellm_config.yaml --port 4000 &
```

**✅ You should see:** AI backend running at http://localhost:4000

### Getting an OpenAI API Key

1. Sign into [https://platform.openai.com](https://platform.openai.com) (create an account if you don't have one).
2. Navigate to **API Keys** and click **Create new secret key**.
3. Copy the generated key and store it securely. Then export it:

```bash
export OPENAI_API_KEY="sk-..."
```

4. To persist it, add the export line to your shell profile (`~/.bashrc`/`~/.zshrc`) or include it in `~/.ansai/orchestrators/ansible/playbooks/vars/your-vars.yml` so automation picks it up automatically.

Refer to https://platform.openai.com/account/api-keys for additional management options.

---

## ⚙️ Step 3: Configure Environment (1 minute)

```bash
# Set your email for alerts
export ANSAI_ADMIN_EMAIL="your-email@example.com"

# Configure SMTP (Gmail example)
export ANSAI_SMTP_SERVER="smtp.gmail.com"
export ANSAI_SMTP_PORT="587"
export ANSAI_SMTP_USER="your-email@gmail.com"
export ANSAI_SMTP_PASSWORD="your-app-password"

# Save to your shell profile
cat >> ~/.bashrc << 'EOF'
# ANSAI Configuration
export ANSAI_ADMIN_EMAIL="your-email@example.com"
export ANSAI_SMTP_SERVER="smtp.gmail.com"
export ANSAI_SMTP_PORT="587"
export ANSAI_SMTP_USER="your-email@gmail.com"
export ANSAI_SMTP_PASSWORD="your-app-password"
EOF
```

**📧 Gmail Users:**
- Use an [App Password](https://support.google.com/accounts/answer/185833), not your regular password
- Enable 2FA first, then generate app password

**✅ You should see:** No errors when exporting variables

---

## 🎯 Step 4: Configure Your Target Server (1 minute)

```bash
# Create Ansible inventory
cat > ~/.ansai/orchestrators/ansible/inventory/hosts.yml << 'EOF'
all:
  children:
    servers:
      hosts:
        my-server:
          ansible_host: 192.168.1.100  # Your server IP
          ansible_user: your-username   # Your SSH user
          ansible_become: true
          ansible_python_interpreter: /usr/bin/python3
EOF
```

**Test SSH connectivity:**
```bash
cd ~/.ansai/orchestrators/ansible
ansible all -i inventory/hosts.yml -m ping
```

**✅ You should see:** `"ping": "pong"` response

---

## 🚀 Step 5: Deploy AI-Powered Monitoring (1 minute)

```bash
cd ~/.ansai/orchestrators/ansible

# Deploy to your server
ansible-playbook playbooks/deploy-ai-powered-monitoring.yml -i inventory/hosts.yml

# Watch the magic happen...
```

**What this deploys:**
- ✅ Universal self-healing for systemd services
- ✅ AI-powered root cause analysis
- ✅ Email alerts with diagnostics
- ✅ Automatic remediation for common failures

**✅ You should see:**
```
╔════════════════════════════════════════════════════════════╗
║  ✅ AI-Powered Monitoring Deployed Successfully!          ║
╚════════════════════════════════════════════════════════════╝
```

---

## 🧪 Step 6: Test It! (1 minute)

### Test 1: Trigger Self-Healing

```bash
# SSH to your server
ssh your-username@192.168.1.100

# Stop a monitored service
sudo systemctl stop sshd

# Watch self-healing in action
sudo tail -f /var/log/self-heal/sshd.log
```

**What happens:**
1. Service stops
2. ANSAI detects failure
3. AI analyzes logs for root cause
4. Service auto-restarts
5. You receive email with diagnostic report

### Test 2: Check Status Dashboard

```bash
# View comprehensive status
sudo /usr/local/bin/testserver-status.sh
```

**You'll see:**
```
╔══════════════════════════════════════════════════════════╗
║           System Health Status - testserver              ║
╚══════════════════════════════════════════════════════════╝

🟢 sshd              Active since 2025-11-18 (self-healed)
🟢 cron              Active since 2025-11-15

System Overview:
  CPU Load: 0.25
  Memory: 45%
  Disk: 60%
```

### Test 3: Review Email Alert

Check your email (ANSAI_ADMIN_EMAIL). You should receive:

```
Subject: [ANSAI] Service Healed: sshd on my-server

🤖 AI Root Cause Analysis:
Primary: Service stopped manually via systemctl
Contributing: None detected
Correlation: No related service failures

✅ Remediation Taken:
1. Restarted service (successful)
2. Verified port 22 accessibility
3. Validated configuration files

📊 Current Status: HEALTHY
Next healing window: Immediate (on failure)

💡 Recommendations:
- Service healthy, no action needed
- Monitor for repeated manual stops
```

**✅ Success!** You now have AI-powered self-healing infrastructure.

---

## 🎉 What You Just Built

Congratulations! You now have:

### 🤖 AI-Powered Automation
- Not just "restart on failure"
- Root cause analysis using LLMs
- Intelligent event correlation
- Predictive failure detection

### 🛡️ Self-Healing Infrastructure
- Automatic service recovery
- Port conflict resolution
- Configuration validation
- Database connectivity checks

### 📧 Intelligent Alerts
- Detailed diagnostic emails
- AI-analyzed root causes
- Remediation explanations
- Prevention recommendations

### 📊 Visibility & Control
- Real-time status dashboard
- Comprehensive logging
- Healing history tracking
- Manual override capability

---

## 🚀 Next Steps

### 1. Customize Your Deployment

**Add more services to monitor:**

Edit `~/.ansai/orchestrators/ansible/playbooks/deploy-ai-powered-monitoring.yml`:

```yaml
monitored_services:
  - name: "nginx"
    description: "Web server"
    critical: true
  - name: "postgresql"
    description: "Database"
    critical: true
  - name: "redis"
    description: "Cache"
    critical: false
```

Re-deploy:
```bash
ansible-playbook playbooks/deploy-ai-powered-monitoring.yml -i inventory/hosts.yml
```

### 2. Add More Monitoring

**Deploy complete monitoring stack:**

```bash
# JavaScript error monitoring for web apps
ansible-playbook playbooks/deploy-js-monitoring.yml

# CSS error monitoring
ansible-playbook playbooks/deploy-css-monitoring.yml

# External monitoring (Healthchecks.io)
export HEALTHCHECK_ENABLED=true
export HEALTHCHECK_PING_URL="https://hc-ping.com/your-uuid"
ansible-playbook playbooks/deploy-healthchecks.yml
```

**See:** [Complete Monitoring Stack Guide](self-healing/COMPLETE_MONITORING_STACK.md)

### 3. Integrate with Your IDE

**Using Cursor IDE?**

Set up AI-powered automation in your editor:

```bash
# Auto-generate .cursorrules on context switch
ansai-context-switch work

# Analyze logs from Cursor terminal
journalctl -u myapp | ansai-fabric logs

# Natural language ops
# In Cursor: "Why is CPU high?"
```

**See:** [Cursor IDE Integration Guide](integrations/CURSOR_IDE.md)

### 4. Explore Example Workflows

```bash
# Context management
ansai-context-switch personal

# Progress tracking
ansai-progress-tracker

# Secrets management
ansai-vault-read myapp/prod/api-keys

# AI log analysis
ansai-fabric logs < /var/log/syslog
```

**See:** `~/.ansai/examples/workflows/`

### 5. Build Your Own

**ANSAI is a framework, not a product.**

Create your own building blocks:
- Custom Ansible roles
- AI-powered workflows
- Monitoring patterns
- Automation scripts

**Share what you build:** https://github.com/thebyrdman-git/ansai/discussions

---

## 📚 Learn More

### Documentation
- **Full Docs:** https://ansai.dev
- **Self-Healing:** https://ansai.dev/self-healing/
- **Integrations:** https://ansai.dev/integrations/
- **Community:** https://github.com/thebyrdman-git/ansai/discussions

### Example Use Cases
- [JavaScript Error Monitoring](self-healing/JS_ERROR_MONITORING.md)
- [CSS Error Monitoring](self-healing/CSS_ERROR_MONITORING.md)
- [External Health Checks](self-healing/HEALTHCHECKS_SETUP.md)
- [Complete Monitoring Stack](self-healing/COMPLETE_MONITORING_STACK.md)

### Community
- **Show & Tell:** Share your builds
- **Ideas:** Request features
- **Q&A:** Get help

**Join:** https://github.com/thebyrdman-git/ansai/discussions

---

## 🆘 Troubleshooting

### Issue: LiteLLM not starting

**Solution:**
```bash
# Check if port 4000 is in use
lsof -i :4000

# Kill existing process
kill -9 $(lsof -t -i :4000)

# Restart LiteLLM
litellm --config ~/.config/ansai/litellm_config.yaml --port 4000
```

### Issue: Ansible playbook fails with "Permission denied"

**Solution:**
```bash
# Test SSH connection
ssh your-username@192.168.1.100

# Verify sudo access
ssh your-username@192.168.1.100 "sudo whoami"
# Should return: root

# Check ansible.cfg
cat ~/.ansai/orchestrators/ansible/ansible.cfg
```

### Issue: No email alerts received

**Solution:**
```bash
# Test SMTP configuration
python3 << 'EOF'
import smtplib
from email.mime.text import MIMEText
import os

msg = MIMEText("Test from ANSAI")
msg['Subject'] = "ANSAI Test Email"
msg['From'] = os.environ['ANSAI_SMTP_USER']
msg['To'] = os.environ['ANSAI_ADMIN_EMAIL']

with smtplib.SMTP(os.environ['ANSAI_SMTP_SERVER'], int(os.environ['ANSAI_SMTP_PORT'])) as server:
    server.starttls()
    server.login(os.environ['ANSAI_SMTP_USER'], os.environ['ANSAI_SMTP_PASSWORD'])
    server.send_message(msg)
print("✅ Email sent successfully!")
EOF
```

### Issue: Services not healing

**Solution:**
```bash
# Check self-healing logs
sudo tail -f /var/log/self-heal/*.log

# Verify systemd OnFailure hooks
systemctl show sshd | grep OnFailure

# Manually trigger healing
sudo systemctl start sshd-self-heal.service

# Check email delivery
sudo journalctl -u sshd-self-heal.service
```

**More help:** https://ansai.dev/TROUBLESHOOTING/

---

## 💡 Pro Tips

1. **Start with one service:** Monitor sshd first, then expand
2. **Test self-healing manually:** Stop services to verify behavior
3. **Use local models first:** Ollama for testing, cloud for production
4. **Set up external monitoring:** Healthchecks.io catches server-down scenarios
5. **Integrate with your IDE:** Makes AI automation part of your workflow

---

## 🎯 Quick Reference

```bash
# Installation
curl -sSL https://ansai.dev/install.sh | bash

# Start AI backend
litellm --config ~/.config/ansai/litellm_config.yaml --port 4000 &

# Deploy monitoring
cd ~/.ansai/orchestrators/ansible
ansible-playbook playbooks/deploy-ai-powered-monitoring.yml -i inventory/hosts.yml

# Check status
ssh your-server "sudo /usr/local/bin/testserver-status.sh"

# View logs
ssh your-server "sudo tail -f /var/log/self-heal/*.log"

# Test self-healing
ssh your-server "sudo systemctl stop sshd"
```

---

**Welcome to ANSAI!** 🚀
**AI-powered automation starts now.**

**Questions?** https://github.com/thebyrdman-git/ansai/discussions
