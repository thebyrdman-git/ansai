# ANSAI Video Tutorial Scripts

**Ready-to-record scripts for demos and tutorials.**

Perfect for:
- Your Friday talk
- YouTube tutorials
- Launch marketing
- Community contributions

---

## 🎬 Video 1: ANSAI Quick Start (5 minutes)

**Goal:** Show how easy it is to get started with ANSAI

### Script

**[0:00 - 0:30] Introduction**

> "Hi! I'm going to show you ANSAI - AI-powered automation infrastructure.
>
> ANSAI is Ansible plus AI. It transforms traditional automation into intelligent automation.
>
> Without AI, it's just scripts. With ANSAI, your infrastructure actually thinks.
>
> Let me show you how easy it is to get started."

**[0:30 - 1:00] Installation**

> "First, installation is a single command."

```bash
curl -sSL https://ansai.dev/install.sh | bash
```

> "The installer checks prerequisites, sets up your PATH, and offers to install AI backends like LiteLLM or Fabric.
>
> I'll choose LiteLLM for multi-model support."

*[Show installer output, select option 1 for LiteLLM]*

**[1:00 - 2:00] AI Backend Setup**

> "Now I need to set up the AI backend. I'll use OpenAI, but ANSAI also supports Claude, Groq, or local models like Ollama."

```bash
export OPENAI_API_KEY="your-key"
litellm --config ~/.config/ansai/litellm_config.yaml --port 4000 &
```

> "LiteLLM acts as a proxy. It can route to the cheapest model, implement fallbacks, and track costs. Pretty cool."

*[Show health check]*

```bash
curl http://localhost:4000/health
```

**[2:00 - 3:30] First AI Analysis**

> "Let's test it with log analysis. I'll create a simple error log."

```bash
echo "ERROR: Connection refused on port 5432
ERROR: Database connection timeout
WARNING: High memory usage
ERROR: Cannot connect to database" > test.log
```

> "Now let's see what the AI thinks."

```bash
ansai-log-analyzer test.log
```

*[Show AI analysis output]*

> "Look at that! The AI identified:
> - Root cause: Database connection issues
> - Pattern: Multiple connection errors
> - Recommendation: Check if PostgreSQL is running on port 5432
>
> It's not just grepping for 'ERROR'. It's actually analyzing and making connections."

**[3:30 - 4:30] Deploy to Server**

> "Now let's deploy AI-powered monitoring to a real server. First, I configure my inventory."

```bash
cat > inventory/hosts.yml << 'EOF'
all:
  children:
    servers:
      hosts:
        my-server:
          ansible_host: 192.168.1.100
          ansible_user: jbyrd
EOF
```

> "Now I deploy with one command."

```bash
ansible-playbook playbooks/deploy-ai-powered-monitoring.yml
```

*[Show playbook running, highlight key steps]*

> "This deploys:
> - Universal self-healing for services
> - AI-powered root cause analysis
> - Email alerts with diagnostics
> - Automatic remediation"

**[4:30 - 5:00] Wrap Up**

> "That's it! In 5 minutes we:
> - Installed ANSAI
> - Set up AI
> - Analyzed logs intelligently
> - Deployed to a real server
>
> Your infrastructure is now thinking, not just executing.
>
> Check out ansai.dev for more examples. Thanks for watching!"

---

## 🎬 Video 2: AI Root Cause Analysis Demo (8 minutes)

**Goal:** Show AI identifying root causes in a real incident

### Script

**[0:00 - 0:45] Setup the Scenario**

> "I'm going to simulate a production incident and show you how ANSAI's AI finds the root cause.
>
> The scenario: Our web API is slow. Users are complaining. Let's investigate."

*[Show a web app with slow response times]*

**[0:45 - 2:00] Collect Logs**

> "First, I grab the logs from our API service."

```bash
journalctl -u web-api.service --since "30 minutes ago" > api-logs.txt
```

> "Let's take a quick look."

*[cat the logs, scroll through - show it's overwhelming]*

> "Over 5,000 lines. Lots of noise. This would take me hours to analyze manually.
>
> Let's see what the AI finds."

**[2:00 - 4:00] AI Analysis**

```bash
ansai-log-analyzer --service web-api --since "30 minutes ago" --format text
```

*[Show AI analyzing]*

> "The AI is reading all the logs, identifying patterns, and correlating events. Let's see what it found."

*[Show AI output]*

> "Wow. Look at this:
>
> **Root Cause:** Database connection pool exhausted
>
> **Contributing Factors:**
> - Traffic spike: 300% above baseline
> - Connection pool: 100/100 (maxed out)
> - No connection timeout configured
>
> **Trigger:** Marketing campaign launched at 2:30 PM
>
> The AI not only found the immediate cause - connection pool exhaustion - but it traced it back to the marketing campaign and identified configuration gaps.
>
> This is what I mean by intelligent automation. It's not just showing errors. It's explaining WHY."

**[4:00 - 5:30] AI Recommendations**

> "But it doesn't stop there. Look at the recommendations:
>
> **Immediate:**
> 1. Increase connection pool from 100 to 200
> 2. Add connection timeout (30 seconds)
> 3. Implement rate limiting
>
> **Long-term:**
> 1. Add connection pool monitoring
> 2. Auto-scaling based on utilization
> 3. Coordinate with marketing for high-traffic events
>
> This is actionable. I can fix this right now."

**[5:30 - 6:30] Apply Fix**

> "Let me apply the immediate fix."

*[Edit database config, increase pool size]*

```yaml
# database.yml
connection_pool:
  min: 10
  max: 200  # Increased from 100
  timeout: 30  # Added timeout
```

```bash
ansible-playbook playbooks/update-db-config.yml
```

*[Show service restart, check metrics]*

**[6:30 - 7:30] Generate Incident Report**

> "Now let's document this incident. I'll use ANSAI's AI incident reporter."

```bash
ansai-incident-report --interactive
```

*[Fill in the prompts]*

> "Service: web-api
> Start time: 2:30 PM
> Severity: high
> Impact: API latency increased 7x
> Root cause: Connection pool exhausted
> Template: postmortem"

*[Show AI generating the report]*

> "And just like that, I have a complete post-mortem with timeline, root cause analysis, action items, and lessons learned.
>
> This would normally take me an hour to write. AI did it in 30 seconds."

**[7:30 - 8:00] Wrap Up**

> "So that's AI root cause analysis with ANSAI:
> - Found the root cause in seconds (not hours)
> - Explained WHY it happened
> - Provided actionable recommendations
> - Generated a complete post-mortem
>
> This is what intelligent infrastructure looks like.
>
> Links in the description. Thanks for watching!"

---

## 🎬 Video 3: Safe Deployments with AI (6 minutes)

**Goal:** Show AI catching deployment issues before production

### Script

**[0:00 - 0:30] Introduction**

> "Ever deployed something to production and immediately regretted it?
>
> Let me show you how ANSAI uses AI to catch issues BEFORE they hit production.
>
> This is ansai-deploy-safe - your AI safety reviewer."

**[0:30 - 1:30] The Deployment**

> "Here's a Kubernetes deployment I want to push to production."

*[Show deployment.yaml]*

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  replicas: 3
  template:
    spec:
      containers:
      - name: app
        image: myapp:latest
        ports:
        - containerPort: 8080
```

> "Looks fine, right? Let's see what the AI thinks."

**[1:30 - 3:30] AI Safety Analysis**

```bash
ansai-deploy-safe --type kubernetes --env production --strict deployment.yaml
```

*[Show AI analyzing]*

> "The AI is checking:
> - Security vulnerabilities
> - Resource limits
> - Configuration risks
> - Production readiness
> - Best practices
>
> And here are the results..."

*[Show AI output]*

> "Whoa. The AI found some serious issues:
>
> **CRITICAL:**
> - No resource limits (can crash the node)
> - Missing readiness probe (traffic to unhealthy pods)
> - Using 'latest' tag (breaks rollbacks)
> - No monitoring configured (blind deployment)
>
> **Overall Assessment: HIGH RISK - NO GO**
>
> If I had deployed this, I would have had problems. The AI just saved me from a production incident."

**[3:30 - 5:00] Fix the Issues**

> "Let me fix these issues based on the AI's recommendations."

*[Edit deployment.yaml]*

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
  annotations:
    prometheus.io/scrape: "true"  # AI recommended
spec:
  replicas: 3
  template:
    spec:
      containers:
      - name: app
        image: myapp:v1.2.3  # Specific tag
        ports:
        - containerPort: 8080
        resources:  # AI recommended
          requests:
            memory: "512Mi"
            cpu: "250m"
          limits:
            memory: "1Gi"
            cpu: "500m"
        readinessProbe:  # AI required
          httpGet:
            path: /health/ready
            port: 8080
          initialDelaySeconds: 5
          periodSeconds: 10
```

> "Now let's check again."

**[5:00 - 5:30] Recheck**

```bash
ansai-deploy-safe --type kubernetes --env production --strict deployment.yaml
```

*[Show new output]*

> "**Overall Assessment: LOW RISK - GO**
>
> All checks passed! This is safe to deploy."

**[5:30 - 6:00] Wrap Up**

> "That's AI-powered deployment safety:
> - Caught 4 critical issues before production
> - Provided specific fixes
> - Validated the corrected deployment
>
> This is like having an SRE reviewing every deployment. But it's instant, consistent, and never gets tired.
>
> Check out ansai.dev. Thanks for watching!"

---

## 🎬 Bonus: Your Friday Talk - "ANSAI: Ansible + AI" (15 minutes)

**Goal:** Comprehensive demo for technical audience

### Structure

**[0-2 min] The Problem**
- Traditional automation: Static, reactive, dumb
- You write the rules, it follows blindly
- When things break, you read logs manually
- Configuration is guesswork
- *"We've had intelligent humans for thousands of years. Intelligent infrastructure? That's new."*

**[2-4 min] The Solution: AI Layer**
- ANSAI = Ansible + AI
- Same proven patterns (Ansible Galaxy)
- New intelligence layer (LLMs)
- Not replacing humans, augmenting automation
- *"If Ansible is the hands, AI is the brain."*

**[4-7 min] Demo 1: AI Log Analysis**
- Show real logs from miraclemax
- Traditional: grep, find, manual correlation
- ANSAI: AI finds root cause in seconds
- Explain the "why", not just "what"

**[7-10 min] Demo 2: Galaxy + ANSAI**
- Show popular Ansible Galaxy role (nginx, postgres)
- "This works great. But what if it was smart?"
- Add ANSAI AI enhancement
- Show AI optimization, predictions, recommendations

**[10-13 min] Demo 3: Production Safety**
- Show deployment manifest
- AI safety check catches issues
- Fix issues
- "This just prevented a production incident"

**[13-15 min] The Future**
- Infrastructure that thinks
- Proactive, not reactive
- Learning from experience
- Community-driven patterns + AI intelligence
- *"This is what the next 10 years of ops looks like."*

**Q&A Tips:**
- "Isn't this expensive?" → Show Groq/local models
- "What about hallucinations?" → Validation layers, confidence scores
- "How is this different from X?" → AI as intelligence layer, not replacement
- "Can I use my own models?" → Yes! LiteLLM supports any OpenAI-compatible API

---

## 📝 Recording Tips

### Before Recording

**Environment Setup:**
- ✅ Clean terminal (clear history)
- ✅ Increase font size (24pt minimum)
- ✅ Hide sensitive info (API keys, IPs)
- ✅ Test all commands work
- ✅ Prepare "worst case" backups

**Audio:**
- ✅ Use external microphone (not laptop mic)
- ✅ Record in quiet room
- ✅ Test audio levels
- ✅ Have water nearby

**Screen:**
- ✅ 1920x1080 minimum resolution
- ✅ Hide notifications
- ✅ Clean desktop
- ✅ Close unnecessary apps

### During Recording

**Pacing:**
- Speak clearly and slowly
- Pause between commands
- Let AI output fully display
- Don't rush through errors

**Engagement:**
- Make eye contact with camera
- Use hand gestures (if on camera)
- Emphasize key points
- Show enthusiasm!

**Demo Flow:**
- Show the problem first
- Then show the solution
- Explain what's happening
- Highlight impressive results

### After Recording

**Editing:**
- Cut long waits
- Add text overlays for commands
- Zoom in on important output
- Add chapter markers

**Publishing:**
- Catchy title with keywords
- Detailed description
- Links to ansai.dev
- Timestamps in description
- Tags: ANSAI, AI, Ansible, DevOps, SRE

---

## 🎯 Key Messages to Emphasize

**1. AI Makes Automation Intelligent**
> "Traditional automation follows rules. ANSAI understands context."

**2. Built on Proven Patterns**
> "ANSAI doesn't replace Ansible Galaxy. It enhances it with AI."

**3. Real Results, Not Hype**
> "62% cost savings. 71% latency reduction. 95% faster query performance. These are real numbers from real infrastructure."

**4. Easy to Get Started**
> "One-line install. 5-minute quick start. Deploy AI-powered automation today."

**5. Community-Driven**
> "ANSAI is what you build with it. Share your workflows. Learn from others."

---

## 📚 Resources to Mention

- **Website:** ansai.dev
- **GitHub:** github.com/thebyrdman-git/ansai
- **Docs:** ansai.dev/GETTING_STARTED
- **Examples:** ansai.dev/examples
- **Community:** github.com/thebyrdman-git/ansai/discussions

---

**Good luck with your recording!** 🎬
**These scripts are templates - make them your own!** 🚀

**Part of the ANSAI Framework**
Learn more: https://ansai.dev
