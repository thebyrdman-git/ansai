# AI Integration - ANSAI's Core Differentiation

## Why AI Integration Matters

**Without AI, it's just Ansible.** These workflows show how AI transforms basic automation into intelligent infrastructure.

---

## 🤖 Available AI Workflows

### 1. LiteLLM Multi-Model Proxy (`ansai-litellm-proxy`)
**Purpose:** Route requests across multiple LLM providers with automatic fallback and cost optimization.

**What It Does:**
- OpenAI, Anthropic, Groq, local Ollama support
- Intelligent model selection based on task
- Automatic failover if a model is down
- Cost tracking and budget limits
- Request caching

**Use Cases:**
- Cost-optimized LLM access (use cheap models when possible)
- High availability (automatic fallback)
- Multi-cloud LLM strategy
- Local + cloud hybrid setups

**[See ansai-litellm-proxy](#litellm-proxy)**

### 2. Fabric AI Text Processing (`ansai-fabric`)
**Purpose:** AI-powered text analysis, summarization, and transformation using proven patterns.

**What It Does:**
- Analyze logs for root causes
- Summarize long documents
- Extract key information
- Redact sensitive data
- Explain complex concepts

**Use Cases:**
- AI-powered log analysis
- Automatic incident summarization
- Documentation generation
- Data sanitization
- Knowledge extraction

**[See ansai-fabric](#fabric-patterns)**

---

## 🚀 Quick Start

### Prerequisites

```bash
# 1. Install LiteLLM
pip install 'litellm[proxy]'

# 2. Install Fabric (optional, for text processing)
pip install fabric-ai

# 3. Set up API keys
export OPENAI_API_KEY="your-key"
# Or: ANTHROPIC_API_KEY, GROQ_API_KEY
# Or: Install Ollama for local models (no API key needed)
```

### Start Using AI

```bash
# Clone ANSAI
git clone https://github.com/thebyrdman-git/ansai.git
cd ansai/examples/workflows/ai-integration

# Make scripts executable
chmod +x ansai-*

# Start LiteLLM proxy
./ansai-litellm-proxy

# In another terminal, use AI for log analysis
cat /var/log/app.log | ./ansai-fabric logs
```

---

## 📖 Workflow Documentation

### LiteLLM Proxy

**Installation:**
```bash
pip install 'litellm[proxy]'
```

**Configuration:**
Create `~/.config/litellm/config.yaml`:
```yaml
model_list:
  - model_name: gpt-4
    litellm_params:
      model: gpt-4
      api_key: os.environ/OPENAI_API_KEY
  
  - model_name: claude
    litellm_params:
      model: claude-3-opus-20240229
      api_key: os.environ/ANTHROPIC_API_KEY
  
  - model_name: local-llama
    litellm_params:
      model: ollama/llama2
      api_base: http://localhost:11434
```

**Usage:**
```bash
# Start proxy
ansai-litellm-proxy

# Use from any OpenAI-compatible client
curl http://localhost:4000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt-4",
    "messages": [{"role": "user", "content": "Analyze this log"}]
  }'
```

**[Full LiteLLM Documentation →](https://docs.litellm.ai)**

---

### Fabric Patterns

**Installation:**
```bash
pip install fabric-ai
```

**Usage Examples:**

```bash
# Analyze logs for root causes
cat /var/log/app.log | ansai-fabric analyze

# Summarize a long document
ansai-fabric summarize < report.txt

# Extract key points
cat meeting-notes.txt | ansai-fabric extract

# Explain an error
echo "SegmentationFault: Core dumped" | ansai-fabric explain

# Redact sensitive data
cat customer-data.txt | ansai-fabric redact > sanitized.txt
```

**[Full Fabric Documentation →](https://github.com/danielmiessler/fabric)**

---

## 💡 Real-World AI Use Cases

### 1. AI-Powered Root Cause Analysis

**Traditional:**
```bash
# Service failed
systemctl restart myapp.service
# Why? Who knows.
```

**With ANSAI AI:**
```bash
# Service failed
journalctl -u myapp.service | ansai-fabric logs

# AI Output:
# Root Cause: Database connection timeout (10.0.1.5:5432)
# Contributing Factors:
#   - DB CPU at 95% for 15 minutes
#   - 50% increase in connections from new feature
#   - Connection pool exhausted (max 100, current 100)
# Recommendations:
#   1. Scale DB vertically or add read replica
#   2. Increase connection pool size to 200
#   3. Add rate limiting to new endpoint
```

### 2. Cost-Optimized LLM Routing

**Problem:** Using GPT-4 for everything costs $$$.

**Solution with LiteLLM:**
```python
# Automatic routing based on task complexity
response = litellm.completion(
    model="gpt-4",  # Tries GPT-4 first
    fallback_models=["gpt-3.5-turbo", "ollama/llama2"],  # Falls back if needed
    messages=[{"role": "user", "content": query}]
)
```

**Result:** 70% cost savings by using cheaper models when possible.

### 3. Natural Language Operations

**Traditional:**
```bash
# Complex command to find errors
journalctl -u myservice.service --since "1 hour ago" | grep ERROR | less
```

**With ANSAI AI:**
```bash
# Natural language
echo "Show me errors from myservice in the last hour" | ansai-fabric explain
```

### 4. Intelligent Log Analysis

**Traditional:** Manual grep, thousands of lines  
**With ANSAI AI:** AI reads logs, finds patterns, correlates events

```bash
# Analyze all logs from last 24 hours
journalctl --since "24 hours ago" | ansai-fabric logs

# AI Output:
# Detected Patterns:
#   - Memory leak in worker process (linear growth)
#   - Correlated with cron job at 02:00
#   - Will reach OOM in ~6 hours
# Recommended Actions:
#   - Restart worker process now
#   - Investigate cron job memory usage
#   - Add memory limits to worker
```

---

## 🔧 Integration with ANSAI Workflows

### Self-Healing with AI

```yaml
# ansible playbook
- name: Service failed - use AI for root cause
  when: service_failed
  shell: |
    journalctl -u {{ service_name }} | ansai-fabric logs > /tmp/root-cause.txt
    cat /tmp/root-cause.txt | mail -s "AI Root Cause: {{ service_name }}" admin@example.com
```

### Context-Aware Automation

```bash
# Hook: After switching context, use AI to analyze current state
# ~/.config/ansai/hooks/post-switch-work.sh
journalctl --since "1 hour ago" | ansai-fabric analyze > ~/.ansai-context-report.txt
```

### Monitoring with AI

```bash
# Instead of static thresholds, use AI to detect anomalies
while true; do
  metrics=$(curl -s http://localhost:9090/metrics)
  echo "$metrics" | ansai-fabric analyze-patterns
  sleep 300
done
```

---

## 🎯 Best Practices

### 1. Use Local Models for Sensitive Data

```yaml
# config.yaml - use local Ollama for sensitive logs
model_list:
  - model_name: log-analyzer
    litellm_params:
      model: ollama/llama2
      api_base: http://localhost:11434  # Stays on your server
```

### 2. Cost Optimization

```python
# Use cheap models for simple tasks
simple_tasks = ["summarize", "translate"]
complex_tasks = ["analyze", "reasoning"]

model = "gpt-3.5-turbo" if task in simple_tasks else "gpt-4"
```

### 3. Caching for Repeated Queries

```yaml
# LiteLLM config
cache:
  type: redis
  host: localhost
  port: 6379
```

### 4. Budget Limits

```yaml
# LiteLLM config
litellm_settings:
  max_budget: 100.0  # $100/month
  budget_duration: 30d
```

---

## 📊 Cost Comparison

| Scenario | Traditional | ANSAI AI | Savings |
|----------|------------|----------|---------|
| Log Analysis | Manual (hours) | AI (seconds) | Time |
| Root Cause | Guesswork | AI analysis | Accuracy |
| LLM Costs | GPT-4 only | Smart routing | 70% |
| Incident Response | Reactive | Predictive | Downtime |

---

## 🔐 Security & Privacy

### Data Handling

**For Sensitive Data:**
- Use local Ollama models (no data leaves your server)
- Or use on-premise LLM deployments
- Enable audit logging in LiteLLM

**For Non-Sensitive Data:**
- Cloud LLMs (OpenAI, Anthropic) are fine
- Cost-effective and high quality

### Example: Privacy-First Configuration

```yaml
# Only local models for production logs
model_list:
  - model_name: prod-analyzer
    litellm_params:
      model: ollama/llama2
      api_base: http://localhost:11434

# Cloud models only for documentation/public data
  - model_name: docs-generator
    litellm_params:
      model: gpt-4
      api_key: os.environ/OPENAI_API_KEY
```

---

## 🚀 What's Next

1. **Try the examples** - Start with log analysis
2. **Customize models** - Configure for your use case
3. **Integrate with workflows** - Add AI to your Ansible playbooks
4. **Share your patterns** - Contribute AI workflows to ANSAI

---

## 📚 Additional Resources

- **LiteLLM Docs:** https://docs.litellm.ai
- **Fabric Patterns:** https://github.com/danielmiessler/fabric
- **Ollama (Local):** https://ollama.ai
- **ANSAI Community:** https://github.com/thebyrdman-git/ansai/discussions

---

**Part of the ANSAI Framework**  
Learn more: https://ansai.dev

**Remember:** Without AI, it's just Ansible. With ANSAI, it thinks. 🧠

