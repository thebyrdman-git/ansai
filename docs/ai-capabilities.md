# 🤖 AI Capabilities in ANSAI

ANSAI integrates AI throughout the automation stack - not just in your IDE, but in the actual infrastructure automation itself.

## How AI Works in ANSAI

```
┌─────────────────────────────────────────────────────────────┐
│                    ANSAI AI Integration                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Service Fails → Gather Logs → AI Analysis → Healing Action │
│                      ↓                                       │
│              Root Cause Report                               │
│              + Recommendations                               │
│              + Prevention Tips                               │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### What the AI Does

When a service fails, ANSAI's self-healing system:

1. **Gathers diagnostic data** - systemctl status, recent logs, system resources
2. **Sends to AI for analysis** - Groq, OpenAI, Ollama, or any LLM
3. **Gets actionable insights**:
   - **ROOT CAUSE**: Why did this fail?
   - **WHY IT FAILED**: Specific technical details
   - **RECOMMENDED FIX**: Commands to run
   - **PREVENTION**: How to avoid recurrence
4. **Includes analysis in alerts** - Email, webhook, or logs

### Example AI Analysis Output

```
══════════════════════════════════════════════════
🤖 AI-POWERED ROOT CAUSE ANALYSIS
══════════════════════════════════════════════════

1. ROOT CAUSE: The service crashed due to memory exhaustion 
   after a memory leak in the connection pool handler.

2. WHY IT FAILED:
   • Memory usage grew from 256MB to 2GB over 6 hours
   • OOM killer terminated the process (signal 9)
   • No memory limits configured in systemd unit

3. RECOMMENDED FIX:
   sudo systemctl edit myapp.service
   # Add: MemoryMax=1G
   sudo systemctl daemon-reload
   sudo systemctl restart myapp

4. PREVENTION: Set memory limits in the service unit file
   and enable automatic restart on OOM.
```

---

## Setting Up AI

### Option 1: Groq (Recommended - Fast & Free Tier)

```bash
# 1. Get free API key at https://console.groq.com
# 2. Export before running playbooks
export ANSAI_GROQ_API_KEY='gsk_...'

# 3. Deploy with AI enabled
cd ~/.ansai/orchestrators/ansible
ansible-playbook playbooks/deploy-self-healing.yml \
  -i inventory/hosts.yml \
  -e 'monitored_services=[{"name": "nginx", "port": 80}]'
```

**Why Groq?**
- Free tier with generous limits
- Fastest inference (llama-3.1-8b-instant)
- No credit card required

### Option 2: Ollama (100% Local - No API Keys)

```bash
# 1. Install Ollama
curl -fsSL https://ollama.ai/install.sh | sh

# 2. Pull a model
ollama pull llama3

# 3. Configure ANSAI to use Ollama
ansible-playbook playbooks/deploy-self-healing.yml \
  -e "ai_backend=ollama" \
  -e "ollama_url=http://localhost:11434" \
  -e "ollama_model=llama3"
```

**Why Ollama?**
- Completely free and private
- No internet required
- Data never leaves your machine

### Option 3: LiteLLM Proxy (Multi-Model)

```bash
# 1. Start the proxy
ansai-litellm-proxy

# 2. Configure ANSAI to use it
ansible-playbook playbooks/deploy-self-healing.yml \
  -e "ai_backend=litellm" \
  -e "litellm_url=http://localhost:4000"
```

**Why LiteLLM?**
- Use any model (OpenAI, Claude, Groq, Ollama)
- Automatic fallback between providers
- Cost tracking and optimization

---

## AI Tools Included

ANSAI includes several AI-powered CLI tools:

### ansai-litellm-proxy
Multi-model LLM proxy server.

```bash
# Start proxy on port 4000
ansai-litellm-proxy

# Use with any OpenAI-compatible client
curl http://localhost:4000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{"model": "gpt-4", "messages": [{"role": "user", "content": "Hello"}]}'
```

### ansai-log-analyzer
AI-powered log analysis.

```bash
# Analyze recent logs
ansai-log-analyzer /var/log/nginx/error.log

# With time filter
ansai-log-analyzer /var/log/syslog --since "1 hour ago"
```

### ansai-incident-report
Generate AI incident reports from logs.

```bash
# Generate incident report
ansai-incident-report --service nginx --timeframe "2 hours"
```

---

## Testing AI Locally

### Quick Test (No Service Failures Required)

```bash
# Test Groq API directly
curl -X POST "https://api.groq.com/openai/v1/chat/completions" \
  -H "Authorization: Bearer $ANSAI_GROQ_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "llama-3.1-8b-instant",
    "messages": [{"role": "user", "content": "Why might nginx fail to start?"}]
  }'
```

### Simulate a Failure

```bash
# 1. Stop a non-critical service
sudo systemctl stop cockpit.socket

# 2. Watch the self-healing logs
journalctl -t ansai-self-heal -f

# 3. Look for AI analysis in the output
# You should see "🤖 AI-POWERED ROOT CAUSE ANALYSIS"
```

### View Historical AI Analyses

```bash
# All healing events with AI analysis
journalctl -t ansai-self-heal | grep -A 20 "AI-POWERED"

# Recent healing reports
ls -la /tmp/self-heal-*.txt
cat /tmp/self-heal-nginx-*.txt
```

---

## Configuration Reference

### defaults/main.yml Options

```yaml
# AI-Powered Root Cause Analysis
ai_analysis_enabled: true          # Enable/disable AI analysis
ai_backend: groq                   # groq, ollama, litellm, openai

# Groq Configuration (default)
groq_api_key: "{{ lookup('env', 'ANSAI_GROQ_API_KEY') }}"
groq_model: llama-3.1-8b-instant
groq_api_url: https://api.groq.com/openai/v1/chat/completions

# Ollama Configuration (local)
ollama_url: http://localhost:11434
ollama_model: llama3

# LiteLLM Configuration (proxy)
litellm_url: http://localhost:4000
litellm_model: gpt-4
```

### Environment Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `ANSAI_GROQ_API_KEY` | Groq API key | `gsk_abc123...` |
| `OPENAI_API_KEY` | OpenAI API key | `sk-abc123...` |
| `ANTHROPIC_API_KEY` | Claude API key | `sk-ant-...` |

---

## Troubleshooting AI

### "AI analysis unavailable"

```bash
# Check if API key is set
echo $ANSAI_GROQ_API_KEY

# Test API connectivity
curl -s https://api.groq.com/openai/v1/models \
  -H "Authorization: Bearer $ANSAI_GROQ_API_KEY"
```

### "AI Error: rate limit exceeded"

- Groq free tier has rate limits
- Solution: Use Ollama locally or upgrade Groq plan

### AI analysis not appearing in reports

```bash
# Check if AI is enabled in the deployed scripts
grep "AI_ENABLED" /usr/local/bin/self-heal/*.sh

# Should show: AI_ENABLED="true"
```

---

---

## ansai-ask: Interactive AI Assistant

Chat with AI about your infrastructure directly from the command line.

### Basic Usage

```bash
# Ask a question
ansai-ask "why might nginx fail to start?"

# Analyze a log file
ansai-ask --analyze /var/log/nginx/error.log

# Ask about a specific service
ansai-ask --service nginx "why is it using so much memory?"

# Pipe logs for analysis  
journalctl -u myapp --since "1 hour ago" | ansai-ask --stdin "what's causing these errors?"

# Interactive chat mode
ansai-ask --interactive
```

### Backend Selection

```bash
# Auto-detect best available backend
ansai-ask "your question"

# Use specific backend
ansai-ask --backend ollama "your question"
ansai-ask --backend groq "your question"
```

---

## Webhook Alerts (Slack, Discord)

Instead of email, send alerts to Slack, Discord, or any webhook.

### Configuration

```yaml
# In your playbook or defaults/main.yml
alert_method: webhook      # email, webhook, both, none
webhook_url: "https://hooks.slack.com/services/xxx/yyy/zzz"
webhook_format: slack      # slack, discord, generic
```

### Supported Formats

- **Slack** - Rich formatted messages with attachments
- **Discord** - Embed messages with colors and fields
- **Generic** - JSON payload for custom integrations

---

## What's Next

We're actively building more AI capabilities:

- [x] **ansai-ask** - Chat with AI about your infrastructure ✅
- [x] **Ollama support** - Local AI, no API keys ✅
- [x] **Webhook alerts** - Slack, Discord integration ✅
- [ ] **Web Dashboard** - Visual AI insights
- [ ] **Predictive Alerts** - AI predicts failures before they happen
- [ ] **Auto-tuning** - AI optimizes your service configurations

**Have ideas?** [Open a discussion](https://github.com/thebyrdman-git/ansai/discussions) or contribute!

