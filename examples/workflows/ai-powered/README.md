# AI-Powered Workflows

**Intelligent automation workflows powered by LLMs.**

These workflows demonstrate ANSAI's core value: **AI makes automation intelligent, not just automated.**

---

## 🤖 Available Workflows

### 1. `ansai-log-analyzer` - AI Log Analysis

**What it does:** Analyzes logs using AI to find root causes, anomalies, and actionable insights.

**Use cases:**
- Post-mortem analysis
- Real-time anomaly detection
- Performance troubleshooting
- Security incident investigation

**Example:**
```bash
# Analyze service logs
ansai-log-analyzer --service nginx --since "1 hour ago"

# Focus on security
ansai-log-analyzer --focus security /var/log/auth.log

# Pipe logs directly
journalctl -u myapp.service | ansai-log-analyzer
```

**AI Features:**
- Root cause identification
- Pattern recognition
- Event correlation
- Severity assessment
- Actionable recommendations

**Output:**
```
✅ Analysis Complete

## Root Cause Analysis

Primary Issue: Database connection pool exhausted
- Connection pool: 100/100 (100% utilization)
- Peak traffic: 15:30-15:45 (300% above baseline)
- Trigger: Marketing campaign launch

Contributing Factors:
- No connection timeout configured
- Missing rate limiting
- Insufficient pool size for peak load

## Recommendations

Immediate:
1. Increase connection pool to 200
2. Add connection timeout (30s)
3. Implement rate limiting

Long-term:
1. Add connection pool monitoring
2. Auto-scaling based on pool utilization
3. Load testing for marketing campaigns
```

---

### 2. `ansai-incident-report` - AI Incident Reports

**What it does:** Generates comprehensive incident reports and post-mortems using AI.

**Use cases:**
- Post-mortem documentation
- Executive summaries
- Technical analysis
- Blameless retrospectives

**Example:**
```bash
# Interactive mode (recommended)
ansai-incident-report --interactive

# Command line
ansai-incident-report \
    --service "web-api" \
    --start "2025-11-18 14:30" \
    --end "2025-11-18 15:45" \
    --severity critical \
    --impact "API unavailable for 75 minutes" \
    --template postmortem \
    --output incident-2025-11-18.md

# Quick executive summary
ansai-incident-report --service "database" --template executive
```

**Report Types:**
- **postmortem**: Full post-mortem with timeline, root cause, action items
- **executive**: High-level summary for leadership
- **technical**: Detailed technical analysis

**AI Features:**
- Root cause analysis (5 Whys methodology)
- Timeline reconstruction
- Action item generation
- Prevention recommendations
- Communication templates

**Output Example:**
```markdown
# Incident Post-Mortem: API Outage

## Executive Summary

On November 18, 2025, our web API experienced a 75-minute outage from 
14:30 to 15:45 UTC, affecting approximately 10,000 users. The root cause 
was database connection pool exhaustion triggered by a traffic spike from 
a marketing campaign. The incident was resolved by restarting services 
and increasing the connection pool size.

## Impact Assessment

- Duration: 75 minutes
- Users Affected: ~10,000 (15% of daily active users)
- Revenue Impact: $5,000 (estimated)
- Customer Tickets: 127 support tickets filed

## Timeline

**14:30** - Marketing campaign launched, traffic increased 300%
**14:32** - API latency increased from 100ms to 5s
**14:35** - First alerts triggered
**14:40** - On-call engineer paged
**14:45** - Root cause identified (connection pool exhaustion)
**14:50** - Emergency restart initiated
**14:55** - Services restored, traffic recovering
**15:00** - Connection pool increased from 100 to 200
**15:15** - All metrics returned to normal
**15:45** - Incident declared resolved

## Root Cause Analysis

Why was the API unavailable?
→ Database connections were exhausted

Why were connections exhausted?
→ Traffic spike exceeded connection pool capacity

Why didn't we have enough capacity?
→ Connection pool sized for average load, not peak

Why wasn't peak load accounted for?
→ Marketing campaign not coordinated with engineering

Why wasn't there coordination?
→ No process for high-impact campaign review

**Root Cause:** Insufficient cross-team coordination for high-impact events

## Action Items

| Action | Owner | Deadline | Priority |
|--------|-------|----------|----------|
| Increase connection pool to 500 | DevOps | 2025-11-19 | P0 |
| Add connection pool monitoring | SRE | 2025-11-22 | P0 |
| Implement auto-scaling | Backend | 2025-11-25 | P1 |
| Create campaign review process | Product | 2025-11-30 | P1 |
| Load test marketing scenarios | QA | 2025-12-01 | P2 |

## Lessons Learned

**What Went Well:**
- Fast detection (5 minutes)
- Clear communication
- Effective debugging

**What Went Wrong:**
- No capacity planning for campaign
- Missing rate limiting
- Insufficient monitoring

## Prevention Measures

1. **Process**: Require engineering review for high-impact campaigns
2. **Technical**: Implement auto-scaling for connection pools
3. **Monitoring**: Add alerts for pool utilization >70%
4. **Testing**: Include marketing scenarios in load tests
```

---

### 3. `ansai-deploy-safe` - AI Deployment Safety

**What it does:** Reviews deployments for safety issues before they go live.

**Use cases:**
- Pre-deployment validation
- Production safety checks
- Security review automation
- Configuration validation

**Example:**
```bash
# Check Kubernetes manifest
ansai-deploy-safe --type kubernetes deployment.yaml

# Check for production
ansai-deploy-safe --type kubernetes --env production deployment.yaml

# Strict mode (fail on any warnings)
ansai-deploy-safe --type kubernetes --env production --strict deployment.yaml

# Analyze git diff
git diff main..HEAD | ansai-deploy-safe --type kubernetes --env production
```

**Safety Checks:**
- Security vulnerabilities
- Resource limits (CPU, memory)
- Configuration risks
- Best practice violations
- Production-specific risks
- Rollback plan validation
- Health check configuration
- Monitoring/alerting presence

**AI Features:**
- Context-aware analysis
- Risk assessment
- Remediation suggestions
- Impact prediction
- Similar incident warnings

**Output Example:**
```
✅ Safety Analysis Complete

## Overall Risk Assessment: MEDIUM

## Security Analysis

✅ **Secrets Management**: PASS
   - Using Kubernetes secrets (not hardcoded)
   - Secrets mounted as volumes

⚠️  **Image Security**: WARNING
   - Using 'latest' tag (not recommended for production)
   - No image digest specified
   - Recommendation: Use specific version tags (e.g., 'v1.2.3')

✅ **Network Policies**: PASS
   - Network policies defined
   - Ingress/egress rules appropriate

## Resource Management

❌ **Resource Limits**: FAIL
   - No CPU limits defined
   - Memory request too low (128Mi) for typical workload
   - Risk: Potential resource exhaustion, node instability
   - Recommendation:
     ```yaml
     resources:
       requests:
         memory: "512Mi"
         cpu: "250m"
       limits:
         memory: "1Gi"
         cpu: "500m"
     ```

✅ **Scaling**: PASS
   - HPA configured (2-10 replicas)
   - Appropriate scaling metrics

## Production Readiness

❌ **Health Checks**: FAIL
   - Liveness probe defined
   - Readiness probe MISSING
   - Risk: Traffic routed to unhealthy pods
   - Recommendation:
     ```yaml
     readinessProbe:
       httpGet:
         path: /health/ready
         port: 8080
       initialDelaySeconds: 5
       periodSeconds: 10
     ```

⚠️  **Rollback Strategy**: WARNING
   - Using RollingUpdate (good)
   - maxUnavailable: 1 (may cause downtime under load)
   - Recommendation: Set maxUnavailable: 0, maxSurge: 1

❌ **Monitoring**: FAIL
   - No Prometheus annotations
   - No logging configuration
   - Risk: Blind deployment, difficult debugging
   - Recommendation: Add monitoring annotations

## Go/No-Go Recommendation

**🚨 NO-GO**: Critical issues must be addressed before production deployment

**Required fixes:**
1. Add resource limits (CPU, memory)
2. Add readiness probe
3. Add monitoring annotations
4. Use specific image tags (not 'latest')

**After fixes**, re-run analysis with:
```bash
ansai-deploy-safe --type kubernetes --env production deployment.yaml
```
```

---

## 🚀 Getting Started

### Prerequisites

1. **Install ANSAI**:
```bash
curl -sSL https://raw.githubusercontent.com/thebyrdman-git/ansai/main/install.sh | bash
```

2. **Start AI Backend** (LiteLLM):
```bash
# Set API key
export OPENAI_API_KEY="your-key-here"

# Start LiteLLM proxy
litellm --config ~/.config/ansai/litellm_config.yaml --port 4000 &

# Verify
curl http://localhost:4000/health
```

3. **Add workflows to PATH** (already done by installer):
```bash
export PATH="$HOME/.ansai/bin:$PATH"
```

### Quick Test

```bash
# Test log analyzer
echo "ERROR: Connection refused on port 5432" | ansai-log-analyzer

# Test incident report (interactive)
ansai-incident-report --interactive

# Test deployment safety
cat > test-deployment.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: test-app
spec:
  replicas: 2
  template:
    spec:
      containers:
      - name: app
        image: myapp:latest
EOF

ansai-deploy-safe --type kubernetes test-deployment.yaml
```

---

## 💡 Use Case Examples

### Scenario 1: Production Incident Response

```bash
# 1. During incident: Quick log analysis
ansai-log-analyzer --service web-api --since "30 minutes ago" --focus errors

# 2. After incident: Generate report
ansai-incident-report \
    --service "web-api" \
    --start "2025-11-18 14:30" \
    --severity critical \
    --impact "API degraded, 50% error rate" \
    --template postmortem \
    --output postmortem.md

# 3. Share with team
cat postmortem.md | mail -s "Post-Mortem: API Incident" team@example.com
```

### Scenario 2: Safe Deployments

```bash
# 1. Before deployment: Safety check
ansai-deploy-safe --type kubernetes --env production --strict deployment.yaml

# 2. If passed: Deploy
kubectl apply -f deployment.yaml

# 3. If failed: Fix issues and re-check
# (AI provides specific recommendations)
```

### Scenario 3: Daily Operations

```bash
# Morning: Check for overnight issues
ansai-log-analyzer --service all --since "last night" > morning-report.txt

# Deployment: Pre-deploy check
git diff main..HEAD | ansai-deploy-safe --type kubernetes --env production

# Incident: Quick analysis
journalctl -u myapp.service -n 500 | ansai-log-analyzer --focus performance
```

---

## 🎯 Best Practices

### 1. Always Run Safety Checks

```bash
# Add to CI/CD pipeline
- name: AI Safety Check
  run: |
    ansai-deploy-safe --type kubernetes --env production --strict deployment.yaml
    if [ $? -ne 0 ]; then
      echo "Deployment blocked by safety check"
      exit 1
    fi
```

### 2. Automate Incident Reports

```bash
# Post-incident hook
#!/bin/bash
SERVICE="$1"
SEVERITY="$2"

ansai-incident-report \
    --service "$SERVICE" \
    --severity "$SEVERITY" \
    --template executive \
    --output "incident-$(date +%Y%m%d-%H%M).md"
```

### 3. Regular Log Analysis

```bash
# Daily cron job
0 9 * * * ansai-log-analyzer --service critical-app --since "24 hours ago" | mail -s "Daily Log Analysis" ops@example.com
```

### 4. Cost Optimization

```bash
# Use cheaper models for routine tasks
export ANSAI_AI_MODEL="groq/llama3-8b-8192"  # Fast and cheap

# Use GPT-4 for critical analysis
ansai-deploy-safe --model gpt-4o --type kubernetes --env production deployment.yaml
```

---

## 🔧 Configuration

### Environment Variables

```bash
# AI Backend
export LITELLM_URL="http://localhost:4000"
export ANSAI_AI_MODEL="gpt-4o"  # Default model

# Workflow-specific
export ANSAI_LOG_CONTEXT="100"  # Lines of context for log analysis
export ANSAI_REPORTS_DIR="$HOME/.ansai/incident-reports"
```

### LiteLLM Configuration

**For cost optimization**, configure multiple models:

```yaml
# ~/.config/ansai/litellm_config.yaml
model_list:
  # Fast, cheap for routine tasks
  - model_name: groq-llama3
    litellm_params:
      model: groq/llama3-8b-8192
      api_key: os.environ/GROQ_API_KEY

  # Best quality for critical analysis
  - model_name: gpt-4o
    litellm_params:
      model: openai/gpt-4o
      api_key: os.environ/OPENAI_API_KEY
```

**Route by task:**
```bash
# Routine log analysis
ANSAI_AI_MODEL="groq-llama3" ansai-log-analyzer ...

# Critical deployment
ANSAI_AI_MODEL="gpt-4o" ansai-deploy-safe --strict ...
```

---

## 📊 Cost Optimization

**Estimated costs (per analysis):**

| Workflow | Model | Cost | Speed |
|----------|-------|------|-------|
| Log Analyzer | Groq Llama3 | $0.0001 | ~1s |
| Log Analyzer | GPT-4o | $0.03 | ~3s |
| Incident Report | GPT-4o | $0.05 | ~5s |
| Deploy Safety | GPT-4o | $0.04 | ~4s |

**Tips:**
1. Use Groq for routine analysis (100x cheaper)
2. Use GPT-4 for production safety checks
3. Use local Ollama for development (free)
4. Cache results for repeated analysis

---

## 🤝 Contributing

Have an AI-powered workflow idea? **Share it!**

1. Create your workflow following the template
2. Add comprehensive help text
3. Document use cases
4. Test with multiple AI backends
5. Submit PR or discussion

**[Contribute →](https://github.com/thebyrdman-git/ansai/discussions)**

---

## 📚 Learn More

- **Full Docs:** https://ansai.dev
- **Getting Started:** https://ansai.dev/GETTING_STARTED/
- **AI Integration:** https://ansai.dev/examples/workflows/ai-integration/
- **Cursor IDE:** https://ansai.dev/integrations/CURSOR_IDE/

---

**Part of the ANSAI Framework**  
Learn more: https://ansai.dev

**These workflows demonstrate why ANSAI exists:**  
**AI makes automation intelligent, not just automated.** 🚀

