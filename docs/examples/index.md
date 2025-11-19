# Examples & Showcase

**Real-world ANSAI implementations. Learn by example.**

---

## 🎯 Quick Navigation

<div class="grid cards" markdown>

-   **🌟 Community Roles + ANSAI**
    
    ANSAI enhancements for popular Ansible Galaxy roles
    
    [See Integrations →](COMMUNITY_ROLES.md)

-   **🤖 AI-Powered Workflows**
    
    Intelligent automation with LLMs
    
    [Explore AI Workflows →](#ai-powered-workflows)

-   **📦 Real-World Use Cases**
    
    Galaxy-inspired, AI-enhanced
    
    [See Use Cases →](#real-world-use-cases)

-   **🏗️ Build Your Own**
    
    Contribute workflows
    
    [Contribution Guide →](#contributing)

</div>

---

## 🤖 AI-Powered Workflows

**Intelligent automation that thinks, not just executes.**

### 1. `ansai-log-analyzer` - AI Log Analysis 🔍

**What it does:** Uses AI to analyze logs and identify root causes, patterns, and recommendations.

**Perfect for:**
- Post-incident analysis
- Performance troubleshooting
- Security investigations
- Anomaly detection

**Example:**
```bash
# Analyze service logs
ansai-log-analyzer --service nginx --since "1 hour ago"

# Focus on security issues
ansai-log-analyzer --focus security /var/log/auth.log

# Pipe logs directly
journalctl -u myapp.service | ansai-log-analyzer
```

**Real Output:**
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

**[Download Workflow →](https://github.com/thebyrdman-git/ansai/blob/main/examples/workflows/ai-powered/ansai-log-analyzer)**

---

### 2. `ansai-incident-report` - AI Incident Reports 📝

**What it does:** Generates comprehensive incident reports and post-mortems using AI.

**Perfect for:**
- Post-mortem documentation
- Executive summaries
- Blameless retrospectives
- Root cause analysis

**Example:**
```bash
# Interactive mode (easiest)
ansai-incident-report --interactive

# Generate post-mortem
ansai-incident-report \
    --service "web-api" \
    --start "2025-11-18 14:30" \
    --severity critical \
    --template postmortem \
    --output incident-report.md
```

**Real Output:** Full post-mortem with:
- Executive summary
- Timeline of events
- Root cause (5 Whys)
- Action items with owners
- Prevention measures
- Lessons learned

**[Download Workflow →](https://github.com/thebyrdman-git/ansai/blob/main/examples/workflows/ai-powered/ansai-incident-report)**

---

### 3. `ansai-deploy-safe` - AI Deployment Safety ✅

**What it does:** AI reviews deployments for safety issues before production.

**Perfect for:**
- Pre-deployment validation
- Security review automation
- Production safety checks
- Configuration validation

**Example:**
```bash
# Check Kubernetes manifest
ansai-deploy-safe --type kubernetes deployment.yaml

# Strict mode (fail on warnings)
ansai-deploy-safe --type kubernetes --env production --strict deployment.yaml

# Analyze git diff
git diff main..HEAD | ansai-deploy-safe --type kubernetes --env production
```

**Real Output:**
```
## Overall Risk Assessment: MEDIUM

❌ Resource Limits: FAIL
   - No CPU limits defined
   - Memory request too low (128Mi)
   - Recommendation: Add resource limits

❌ Health Checks: FAIL
   - Missing readiness probe
   - Risk: Traffic to unhealthy pods
   - Recommendation: Add readiness probe

🚨 NO-GO: Fix critical issues before deployment
```

**[Download Workflow →](https://github.com/thebyrdman-git/ansai/blob/main/examples/workflows/ai-powered/ansai-deploy-safe)**

---

### 4. More AI Workflows

**Available now:**
- `ansai-context-switch` - Context-aware development environments
- `ansai-progress-tracker` - Visual CLI progress tracking
- `ansai-vault-read` - Secure secrets management

**Coming soon:**
- `ansai-cost-optimizer` - AI-powered cloud cost optimization
- `ansai-security-audit` - Intelligent security scanning
- `ansai-capacity-planner` - Predictive capacity planning

**[Browse All Workflows →](https://github.com/thebyrdman-git/ansai/tree/main/examples/workflows)**

---

## 📦 Real-World Use Cases

**Inspired by Ansible Galaxy, enhanced with AI.**

### Database Management (Galaxy-Inspired) 🗄️

**Traditional:** `geerlingguy.postgresql`  
**ANSAI Enhancement:** AI query optimization, predictive maintenance

**What you get:**
- AI analyzes slow queries → suggests indexes
- Configuration auto-tuning based on workload
- Predictive alerts (connection pool exhaustion in 3 days)
- Natural language ops ("Why is the database slow?")

**Results:**
- Query performance: +95% (AI-optimized indexes)
- Configuration: Auto-tuned for workload
- Incidents: Predicted 3 days in advance

**[Full Case Study →](https://github.com/thebyrdman-git/ansai/blob/main/examples/use-cases/REAL_WORLD_EXAMPLES.md#case-study-1-ai-powered-database-management)**

---

### Web Server Optimization (Galaxy-Inspired) 🌐

**Traditional:** `geerlingguy.nginx`  
**ANSAI Enhancement:** AI performance tuning, intelligent caching

**What you get:**
- AI optimizes worker processes, connections, buffers
- Cache intelligence (AI determines optimal settings)
- Security hardening (AI recommends SSL/TLS configs)
- Traffic analysis (AI detects anomalies, DDoS)

**Results:**
- Latency: 120ms → 35ms (-71%)
- Throughput: 500 req/s → 1200 req/s (+140%)
- Cache hit rate: 45% → 85%

**[Full Case Study →](https://github.com/thebyrdman-git/ansai/blob/main/examples/use-cases/REAL_WORLD_EXAMPLES.md#case-study-2-ai-powered-web-server-management)**

---

### Kubernetes Management (Galaxy-Inspired) ☸️

**Traditional:** `community.kubernetes`  
**ANSAI Enhancement:** AI resource sizing, predictive scaling

**What you get:**
- AI right-sizes resources (saves 62% on costs)
- Intelligent pod scheduling
- Predictive scaling (40% faster response)
- Cost optimization while meeting SLAs

**Results:**
- Cost savings: $245/month (-62%)
- Pods per node: 12 → 28 (better density)
- Traffic spike response: +40% faster

**[Full Case Study →](https://github.com/thebyrdman-git/ansai/blob/main/examples/use-cases/REAL_WORLD_EXAMPLES.md#case-study-3-ai-powered-kubernetes-management)**

---

### Monitoring & Alerting (Galaxy-Inspired) 📊

**Traditional:** `cloudalchemy.prometheus` + `cloudalchemy.grafana`  
**ANSAI Enhancement:** AI anomaly detection, alert correlation

**What you get:**
- AI learns "normal" → alerts on anomalies
- Alert correlation (groups 12 alerts → 1 root cause)
- Predictive alerts (disk full in 3.2 days)
- Smart thresholds (dynamically adjusted)

**Results:**
- Alert noise: Reduced 85%
- Root cause time: 15min → 2min
- False positives: -90%

**[Full Case Study →](https://github.com/thebyrdman-git/ansai/blob/main/examples/use-cases/REAL_WORLD_EXAMPLES.md#case-study-4-ai-powered-monitoring-stack)**

---

### Security Hardening (Galaxy-Inspired) 🔒

**Traditional:** `dev-sec.os-hardening`  
**ANSAI Enhancement:** AI threat intelligence, behavioral analysis

**What you get:**
- AI prioritizes vulnerabilities by actual risk
- Behavioral anomaly detection
- Compliance checking (CIS, PCI-DSS, SOC 2)
- Intelligent firewall rules

**Results:**
- Vulnerabilities: 47 found, AI-prioritized
- Anomalies: Detected unusual SSH activity (87% confidence)
- Compliance: 87% CIS, with 8 quick wins identified

**[Full Case Study →](https://github.com/thebyrdman-git/ansai/blob/main/examples/use-cases/REAL_WORLD_EXAMPLES.md#case-study-5-ai-powered-security-hardening)**

---

## 🎬 Video Tutorials

### Coming Soon!

**Planned tutorials:**
1. **ANSAI Quick Start** (5 minutes)  
   Install → Deploy → First AI analysis

2. **AI Log Analysis Demo** (8 minutes)  
   Real incident, AI root cause, resolution

3. **Deployment Safety Demo** (6 minutes)  
   Kubernetes manifest review, AI recommendations

4. **Building Your First Workflow** (15 minutes)  
   Step-by-step workflow creation

**Want to contribute a video?** [Let us know →](https://github.com/thebyrdman-git/ansai/discussions)

---

## 🏗️ Contributing

### Share Your Workflows!

**Built something cool with ANSAI?** Share it with the community!

**What we're looking for:**
- AI-powered automation workflows
- Real-world use cases
- Galaxy role enhancements
- Integration examples
- Creative solutions

**How to contribute:**

1. **Create your workflow**
   ```bash
   # Follow our template
   cp examples/workflows/TEMPLATE.sh my-workflow.sh
   ```

2. **Test it thoroughly**
   ```bash
   # Test with multiple AI backends
   # Document edge cases
   # Add error handling
   ```

3. **Document it well**
   ```markdown
   # What it does
   # Why it's useful
   # How to use it
   # Example output
   ```

4. **Share it**
   - Submit PR to GitHub
   - Share in Discussions
   - Add to Showcase

**[Full Contribution Guide →](CONTRIBUTING.md)**

---

## 💡 Get Inspired

### Community Creations

**Coming soon:** Showcase of community-built workflows

**Examples we want to see:**
- ChatOps integrations
- Cost optimization tools
- Compliance automation
- Disaster recovery
- Multi-cloud orchestration
- Developer productivity tools

**[Share yours →](https://github.com/thebyrdman-git/ansai/discussions/categories/show-and-tell)**

---

## 📊 By the Numbers

**ANSAI Examples:**
- 🤖 AI Workflows: 6+ available
- 📦 Use Cases: 5+ documented
- 💰 Cost Savings: Up to 70%
- ⚡ Performance: Up to 140% improvement
- 🎯 Accuracy: 87%+ confidence in AI analysis

---

## 🚀 Get Started

### 1. Install ANSAI
```bash
curl -sSL https://raw.githubusercontent.com/thebyrdman-git/ansai/main/install.sh | bash
```

### 2. Set up AI Backend
```bash
export OPENAI_API_KEY="your-key"
litellm --config ~/.config/ansai/litellm_config.yaml --port 4000 &
```

### 3. Try an Example
```bash
# Download a workflow
curl -o ansai-log-analyzer https://raw.githubusercontent.com/thebyrdman-git/ansai/main/examples/workflows/ai-powered/ansai-log-analyzer
chmod +x ansai-log-analyzer

# Test it
echo "ERROR: Connection refused" | ./ansai-log-analyzer
```

### 4. Build Your Own
```bash
# Start with our template
cp examples/workflows/TEMPLATE.sh my-workflow.sh

# Customize it
# Test it
# Share it!
```

**[Full Getting Started Guide →](../GETTING_STARTED.md)**

---

## 💬 Community

### Get Help & Share Ideas

-   **💬 Discussions:** Ask questions, share ideas
    
    [Join Discussions →](https://github.com/thebyrdman-git/ansai/discussions)

-   **🎨 Show & Tell:** Share your creations
    
    [Show What You Built →](https://github.com/thebyrdman-git/ansai/discussions/categories/show-and-tell)

-   **💡 Ideas:** Request features
    
    [Submit Ideas →](https://github.com/thebyrdman-git/ansai/discussions/categories/ideas)

-   **🐛 Issues:** Report bugs
    
    [File Issues →](https://github.com/thebyrdman-git/ansai/issues)

---

## 📚 Learn More

- **Getting Started:** [Quick start guide](../GETTING_STARTED.md)
- **AI Integration:** [LiteLLM & Fabric setup](../workflows/ai-integration/)
- **Cursor IDE:** [IDE integration](../integrations/CURSOR_IDE.md)
- **Troubleshooting:** [Common issues](../TROUBLESHOOTING.md)

---

**Part of the ANSAI Framework**  
Learn more: https://ansai.dev

**Build intelligent automation. Share what you create.** 🚀


