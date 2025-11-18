# ANSAI Talk - Demo Script & Checklist

## Pre-Talk Setup (Do This Before Friday)

### 1. Verify ANSAI is Running
```bash
# SSH to miraclemax
ssh jbyrd@miraclemax.local

# Check self-healing status
sudo /opt/self-healing/bin/miraclemax-status.sh

# Verify email alerts are working
sudo journalctl -u universal-self-heal@* -n 50
```

### 2. Prepare Demo Environment
```bash
# Ensure you have a test service ready to fail
# books.jbyrd.org is perfect for this

# Test email notifications work
echo "Test email from ANSAI demo prep" | mail -s "ANSAI Demo Test" jimmykbyrd@gmail.com
```

### 3. Have These URLs Ready
- GitHub repo: https://github.com/thebyrdman-git/ansai
- Documentation: https://ansai.dev (or direct GitHub docs)
- Live service to demo: https://books.jbyrd.org

### 4. Prepare Your Environment
- [ ] Have terminal windows pre-sized and arranged
- [ ] Browser tabs ready (GitHub, docs, service URL)
- [ ] Email client open (to show alert)
- [ ] Clear terminal history for clean demo

---

## Demo Flow (15 minutes total)

### Part 1: Show the Problem (2 min)

**Say**: "Let's look at a common scenario. I have a Flask app running in production."

```bash
# Show the running service
systemctl status story-stages.service

# Show it's working
curl https://books.jbyrd.org
```

**Say**: "Now let's simulate a failure - like the database getting locked or the service crashing."

### Part 2: Trigger the Failure (1 min)

```bash
# Option A: Kill the service
sudo systemctl stop story-stages.service

# Option B: Simulate a crash
sudo systemctl kill --signal=SIGKILL story-stages.service

# Option C: Lock the database (more dramatic)
sqlite3 /home/jbyrd/passgo/data/passgo.db ".timeout 0"
# Then in another terminal:
sqlite3 /home/jbyrd/passgo/data/passgo.db "BEGIN EXCLUSIVE; SELECT sleep(3600);"
# Then restart the service to trigger the lock detection
```

**Say**: "Service is down. In the old world, I'd get paged, SSH in, and fix it manually. With ANSAI..."

### Part 3: Show Self-Healing in Action (5 min)

```bash
# Watch the healing happen in real-time
sudo journalctl -u universal-self-heal@story-stages.service -f

# Show detection
# Show diagnosis (checking ports, config, database, etc.)
# Show remediation
# Show service restart
# Show success
```

**Say**: "Notice how it didn't just restart blindly - it diagnosed the root cause, fixed the database lock, THEN restarted."

**Switch to email**:
"And here's what I received - a detailed report explaining exactly what happened and how it was fixed."

**Show email with**:
- Timestamp of failure
- Root cause diagnosis
- Healing steps taken
- Current service status
- All in plain English

### Part 4: Show the Service is Healthy (1 min)

```bash
# Verify service is running
systemctl status story-stages.service

# Test the endpoint
curl https://books.jbyrd.org

# Show in browser
# Click around to prove it's working
```

**Say**: "Total downtime: ~8 seconds. Manual intervention: Zero."

### Part 5: Show the Architecture (3 min)

**Open the GitHub repo**:

```
thebyrdman-git/ansai
├── orchestrators/ansible/
│   ├── roles/
│   │   ├── universal_self_heal/    # Core healing logic
│   │   ├── js_error_monitoring/    # Frontend monitoring
│   │   ├── css_error_monitoring/   # Asset monitoring
│   │   └── healthchecks_monitoring/ # External monitoring
│   └── playbooks/
│       └── deploy-self-healing.yml  # One command deployment
└── docs/
    └── self-healing/                # Complete documentation
```

**Say**: "Everything is Ansible. No proprietary agents. No vendor lock-in. Deploy with one command."

### Part 6: Show How to Get Started (3 min)

**Walk through the quickstart**:

```bash
# 1. Clone the repo
git clone https://github.com/thebyrdman-git/ansai.git
cd ansai

# 2. Configure your services
nano orchestrators/ansible/roles/universal_self_heal/defaults/main.yml

# 3. Deploy
cd orchestrators/ansible
ansible-playbook playbooks/deploy-self-healing.yml

# Done. Your services are now self-healing.
```

**Say**: "That's it. No complex setup. No steep learning curve. If you know Ansible, you're already 80% there."

---

## Key Talking Points

### Why Self-Healing?
- Monitoring tells you WHAT broke (Datadog, Prometheus, etc.)
- Self-healing FIXES it automatically
- Reduces MTTR from hours to seconds
- Cuts on-call burden by 60-80%

### How is ANSAI Different?
- **Intelligent diagnosis**: Checks ports, configs, databases, environment
- **Not just blind restarts**: Fixes root cause first
- **Transparent**: Detailed email reports
- **Production-tested**: Running real workloads
- **Open source**: MIT licensed, no strings

### Technical Highlights
- Built with Ansible (infrastructure-as-code)
- Integrates with systemd (OnFailure hooks)
- Modular architecture (add your own healing strategies)
- 100% test coverage
- External monitoring via Healthchecks.io

### Current Capabilities (v1.0)
- ✅ Universal service healing (any systemd service)
- ✅ JavaScript error monitoring
- ✅ CSS error monitoring
- ✅ Database health checks
- ✅ Port conflict resolution
- ✅ Config validation
- ✅ Email alerting

### Roadmap (v2.0)
- 📋 Disk space management
- 📋 Certificate expiration monitoring
- 📋 Memory leak detection
- 📋 Multi-host support
- 📋 Database maintenance
- 📋 Network connectivity

---

## Backup Demos (If Primary Fails)

### Demo 1: JavaScript Error Monitoring
```bash
# Show error detection in browser
# Open https://books.jbyrd.org
# Trigger a JS error in console
# Show error captured in logs

tail -f /var/log/js-runtime-errors/story-stages_errors.log
```

### Demo 2: Show Monitoring Dashboard
```bash
ssh jbyrd@miraclemax.local
sudo /opt/self-healing/bin/miraclemax-status.sh

# Shows:
# - All monitored services
# - Health status
# - Recent healing activity
# - System stats
```

### Demo 3: Show Test Suite
```bash
cd /home/jbyrd/ansai/orchestrators/ansible/tests
./run-all-tests.sh

# Shows automated testing of all healing scenarios
```

---

## Q&A Preparation

### Expected Questions

**Q: What if the healing fails?**
A: ANSAI sends an email alert with diagnostic info. It won't infinite-loop - there's cooldown logic. You still have your existing monitoring.

**Q: Does it work with [insert service]?**
A: Any systemd service. Flask, Node.js, databases, web servers, custom apps - if systemd manages it, ANSAI can heal it.

**Q: What about Kubernetes?**
A: Currently focused on systemd-based systems. K8s has built-in self-healing. ANSAI fills the gap for VMs, bare metal, and single-host deployments.

**Q: How much overhead?**
A: Minimal. Health checks run only on failure. No constant polling. Resource usage is negligible.

**Q: Can I customize healing strategies?**
A: Absolutely. It's Ansible - just add your own tasks. We provide templates and patterns.

**Q: Does it replace my monitoring?**
A: No, it complements it. Your monitoring detects issues. ANSAI fixes them. Keep both.

**Q: What about security?**
A: Runs as systemd services with limited permissions. Email credentials in encrypted Ansible vault. Open source - audit the code.

**Q: How do I contribute?**
A: GitHub issues and discussions. We're community-driven. Roadmap shaped by user priorities.

---

## Presentation Tips

### Do's
✅ Keep the demo simple and focused
✅ Have a backup plan if demo fails
✅ Show real code, not slides
✅ Be honest about limitations
✅ Encourage questions throughout
✅ Share GitHub URL multiple times

### Don'ts
❌ Over-promise capabilities
❌ Bash other tools/approaches
❌ Go too deep into Ansible internals
❌ Forget to share the repo URL
❌ Rush through the demo
❌ Assume everyone knows Ansible

### Opening Hook
"Show of hands - who's been paged at 2 AM for a service that was down? [pause] Who's fixed the same issue more than once? [pause] That's why I built ANSAI."

### Closing
"The code is on GitHub, MIT licensed. Try it this weekend on a test service. If you have questions, open an issue - we're building this as a community. Thanks!"

---

## Post-Talk Follow-Up

Within 24 hours:
- [ ] Share slides/demo code via GitHub
- [ ] Post link to recording (if recorded)
- [ ] Respond to all questions you couldn't answer live
- [ ] Gather feedback from attendees
- [ ] Update docs based on feedback
- [ ] Add talk to COMMUNITY_TALKS.md in repo

---

**Good luck on Friday! You've got this! 🚀**

Remember: The demo might fail. That's okay. Talk through what you expected to happen, show the code, and move on. The audience is rooting for you.

