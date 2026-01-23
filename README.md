# 🚀 ANSAI: AI-Powered Automation Infrastructure

**ANSAI = Ansible + AI**

Stop scripting. Start thinking. Your infrastructure makes intelligent decisions.

## 🎯 Why ANSAI?

**Without AI, it's just Ansible.** With ANSAI, your automation:

- 🧠 **Analyzes root causes** (not just "service failed")
- 📊 **Predicts failures** before they happen
- 💰 **Optimizes costs** automatically
- 💬 **Understands natural language** ("why is CPU high?")
- 🔍 **Correlates events** across your entire stack
- 🎯 **Routes intelligently** based on cost, performance, load

**The Difference:**

| Traditional Automation | ANSAI (AI-Powered) |
|------------------------|---------------------|
| Restart on failure | Root cause analysis |
| Static playbooks | Intelligent routing |
| Manual log analysis | AI pattern recognition |
| React to problems | Predict and prevent |
| Follow scripts | Make decisions |

## 🤖 AI-Powered Building Blocks

### 1. AI-Powered Service Healing
Not just restart-on-failure. AI analyzes logs, identifies root causes, correlates events.
**Learns what "normal" looks like.**

### 2. AI Orchestration Engine
AI makes routing decisions based on cost, performance, load. Optimizes workflows automatically.
**Learns from every execution.**

### 3. AI Log Analysis
AI reads your logs, finds anomalies, correlates events across services.
**Tells you what matters.**

### 4. Multi-Model LLM Access
Route to OpenAI, Claude, Groq, or local models. AI picks the best model for the task.
**Automatic cost optimization.**

### 5. Natural Language Interface
Talk to your infrastructure. Ask questions. Give commands.
**AI understands context and intent.**

## 🚀 Quick Start

### One-Line Installation

```bash
curl -sSL https://ansai.dev/install.sh | bash
```

You can also run `./prereqs.sh` to verify prerequisites (Git, Python, Ansible, SSH, curl) before launching the installer. On macOS this helper automatically installs Homebrew (if needed) and installs missing dependencies so the installer can finish cleanly.

### Installer updates

- Prompts now accept Enter to confirm defaults so you can breeze through the guided experience.
- `curl -sSL https://ansai.dev/install.sh | bash` now performs the prerequisite check (Git, Python, pip, curl/wget, SSH, Ansible) before cloning the repo.
- Mac hosts automatically install Homebrew via the helper when Ansible is missing, ensuring the required tooling is present before the install continues.

Or from GitHub directly:
```bash
curl -sSL https://raw.githubusercontent.com/thebyrdman-git/ansai/main/install.sh | bash
```

**The installer:**
- ✅ Installs ANSAI to `~/.ansai`
- ✅ Adds ANSAI to your PATH
- ✅ Installs required components (Ansible plus LiteLLM/Fabric AI backends)
- ✅ Creates config directories
- ✅ Prompts for AI backend setup

### Quick Deploy (After Installation)

```bash
# 1. Start AI backend (LiteLLM example)
export OPENAI_API_KEY="your-key"
litellm --config ~/.config/ansai/litellm_config.yaml --port 4000 &

# 2. Configure target server
cat > ~/.ansai/orchestrators/ansible/inventory/hosts.yml << 'EOF'
all:
  children:
    servers:
      hosts:
        my-server:
          ansible_host: 192.168.1.100
          ansible_user: your-username
EOF

# 3. Deploy AI-powered monitoring
cd ~/.ansai/orchestrators/ansible
ansible-playbook playbooks/deploy-ai-powered-monitoring.yml
```

**That's it.** Your AI-powered automation is thinking for you.

**[📚 Full Getting Started Guide](https://ansai.dev/GETTING_STARTED/)** (0 to AI in 5 minutes)

---

## ✨ What ANSAI Can Do (Phase 1)

### AI-Powered Infrastructure Resilience
Phase 1 demonstrates AI-powered automation with real-world examples:

- **🛡️ AI-Powered Service Healing**: Not just restart - AI analyzes logs for root causes
- **🐛 AI Error Analysis**: AI correlates frontend errors with backend events
- **🎨 AI Asset Monitoring**: Intelligent detection of missing resources and patterns
- **❤️ Predictive Health**: AI learns what's normal, alerts on anomalies
- **🧪 Intelligent Testing**: AI-generated test scenarios based on real usage
- **📚 AI Documentation**: Natural language queries about your infrastructure
- **⚙️ Smart Workflows**: AI-optimized CI/CD based on code changes

## 🗺️ Building Blocks: What You Can Create

Think of these as **example creations** - patterns we're building to inspire you. But you're not limited to these. Build whatever solves YOUR problems.

### Phase 1: Infrastructure Resilience Blocks (✅ Available Now)
**What we built to show what's possible:**
- Self-healing service patterns
- Error monitoring and capture
- External health checking
- Automated diagnostics and remediation

**What YOU could build with these:**
- Auto-scaling based on health metrics
- Custom healing strategies for your apps
- Integration with your monitoring stack
- Multi-environment health dashboards

### Phase 2: System Administration Blocks (🚧 Community-Requested)
**Patterns we're adding based on what YOU asked for:**
- Disk space management patterns
- Certificate lifecycle automation
- Memory optimization strategies
- Database maintenance workflows
- Security update automation

**What YOU could build:**
- Custom cleanup policies for your data
- Multi-CA certificate orchestration
- Application-specific memory tuning
- Backup-test-restore pipelines
- Compliance scanning workflows

### Phase 3: Workflow Orchestration Blocks (📋 Requested)
**Building blocks for complex automation:**
- Multi-step workflow engine
- Event-driven triggers
- Rollback and recovery patterns
- Dependency resolution
- Cross-service coordination

**What YOU could build:**
- Blue-green deployment automation
- Data pipeline orchestration
- Disaster recovery procedures
- Multi-region failover
- Custom deployment strategies

### Phase 4: Infrastructure Pattern Library (📋 Requested)
**Pre-built patterns you can customize:**
- Web server configurations
- Database cluster patterns
- Load balancer setups
- Environment templates
- Compliance frameworks

**What YOU could build:**
- Your company's golden paths
- Industry-specific patterns
- Custom compliance rules
- Organization standards
- Reusable infrastructure modules

### Phase 5: Integration Building Blocks (💡 Vision)
**Connect ANSAI to your ecosystem:**
- Cloud provider APIs
- Monitoring tool hooks
- Communication platforms
- Ticketing systems
- Custom APIs

**What YOU could build:**
- ChatOps commands
- Custom dashboards
- Automated incident response
- Cross-platform orchestration
- Your own integration ecosystem

### Phase 6: Intelligence Patterns (💡 Vision)
**Smart automation building blocks:**
- Anomaly detection patterns
- Predictive maintenance
- Cost optimization logic
- Performance tuning algorithms
- Capacity forecasting

**What YOU could build:**
- ML-powered scaling
- Predictive alerting
- Cost-aware automation
- Self-optimizing systems
- Custom intelligence layers

---

**The Pattern**: We build example blocks → Community builds amazing things → We learn and improve → Repeat

**Show us what you build!** The best community creations become official examples.

## 🚀 Quick Start

### Install ANSAI

```bash
# Clone the repository
git clone https://github.com/thebyrdman-git/ansai.git
cd ansai

# Review configuration
nano orchestrators/ansible/roles/universal_self_heal/defaults/main.yml

# Deploy v1.0 (Infrastructure Resilience)
cd orchestrators/ansible
ansible-playbook playbooks/deploy-complete-monitoring.yml
```

### Your First Automated Service (5 minutes)

```yaml
# Add to monitored_services in defaults/main.yml
monitored_services:
  - name: "nginx"
    description: "Web Server"
  - name: "postgresql"
    description: "Database"
```

```bash
# Deploy
ansible-playbook playbooks/deploy-self-healing.yml

# Monitor
sudo journalctl -u universal-self-heal@nginx.service -f
```

That's it! Your services are now self-healing with intelligent diagnostics.

## 📊 Use Cases

### For DevOps Teams
- Reduce MTTR from hours to seconds
- Automate repetitive operational tasks
- Build intelligent runbooks that execute automatically
- Create consistent automation patterns across teams

### For SREs
- Decrease on-call burden by 60-80%
- Implement intelligent alerting with auto-remediation
- Build resilient systems that heal themselves
- Focus on innovation, not firefighting

### For System Administrators
- Automate routine maintenance tasks
- Prevent issues before they become incidents
- Standardize configurations across environments
- Scale your impact without scaling headcount

### For Small Teams & Homelabs
- Enterprise-grade automation without enterprise complexity
- Production reliability for side projects
- Learn automation best practices
- Build professional infrastructure

## 🏗️ Architecture

ANSAI is built on three core principles:

### 1. Modular Components
Each ANSAI module is self-contained and can be deployed independently:
- Infrastructure Resilience
- System Administration
- Workflow Orchestration
- Integration Hub

### 2. Ansible-Native
Leverage your existing Ansible knowledge:
- Familiar playbook structure
- Standard Ansible modules
- Integrates with existing automation
- Use Ansible Vault for secrets

### 3. Event-Driven Design
React intelligently to system events:
- systemd OnFailure hooks
- Webhook triggers
- Scheduled checks
- API events

## 🤝 Community Creations

**We want to see what YOU build!** ANSAI is a platform for creativity.

### Share Your Builds

- **🎨 Show & Tell**: [Built something cool? Show us!](https://github.com/thebyrdman-git/ansai/discussions/categories/show-and-tell)
- **💡 Request Building Blocks**: [What pieces do you need?](https://github.com/thebyrdman-git/ansai/discussions/categories/ideas)
- **🐛 Report Issues**: [Something broken?](https://github.com/thebyrdman-git/ansai/issues)
- **💻 Contribute Patterns**: [Share your creations](CONTRIBUTING.md)
- **📚 Improve Examples**: Documentation and tutorial PRs welcome
- **⭐ Star & Share**: Help others discover the platform

### How We Learn From You

1. You build something amazing
2. Share it with the community
3. Others learn and iterate
4. Best patterns become official examples
5. Everyone benefits

**The best ANSAI creations come from the community, not from us.**

## 📖 Documentation

- **[Complete Documentation](docs/)**: Full guides and references
- **[Self-Healing Infrastructure](docs/self-healing/)**: v1.0 feature documentation
- **[Phase 1 Launch Strategy](docs/LAUNCH_STRATEGY.md)**: Community growth plan
- **[Community Priorities](docs/COMMUNITY_PRIORITIES.md)**: What's coming next
- **[Scaling Strategy](docs/SCALING_STRATEGY.md)**: Long-term vision

## 🎯 Community Builds

**Early adopters are already building amazing things:**

> *"I combined the self-healing blocks with custom Slack notifications and built a ChatOps system that lets my team restart services from mobile. Took 2 hours to build what would've been weeks of custom dev."*
> — Early Adopter

> *"We used ANSAI patterns to build our entire deployment pipeline. Self-healing was just the starting point - now we have automated rollbacks, database migrations, and compliance checks all using the same framework."*
> — Production User

> *"I built a custom cost optimization workflow by combining ANSAI's orchestration with AWS APIs. It automatically scales down dev environments overnight and scales them back up in the morning. Saved 40% on our AWS bill."*
> — Community Member

**What will YOU build?** Share it in [Show & Tell](https://github.com/thebyrdman-git/ansai/discussions/categories/show-and-tell)!

## 📈 Building Progress

- **Phase 1**: ✅ Infrastructure Resilience Blocks - Released & Production-Ready
- **Phase 2**: 🚧 System Administration Blocks - In Development (Community-Requested)
- **Phase 3+**: 📋 Workflow, Patterns, Integrations, Intelligence - Roadmap

**Community Growth** (Phase 1 Goals)
- ⭐ Platform Adopters: 50+ stars
- 🎨 Community Creations: 10+ shared builds
- 👥 Active Builders: 5+ contributors
- 💬 Community Members: 100+
- 🚀 Production Deployments: 20+

## 🛠️ Technical Stack

- **Core**: Ansible, Python 3.9+, systemd
- **Monitoring**: Custom scripts, systemd timers
- **External Integration**: Healthchecks.io, SMTP
- **Testing**: Bash test suite, GitHub Actions
- **Documentation**: MkDocs Material

## 📜 License

MIT License - see [LICENSE](LICENSE) for details.

**Free and open source forever.** No vendor lock-in, no premium features, no bait-and-switch.

## 🙏 Acknowledgments

Built with:
- **Ansible**: The automation language that makes ANSAI possible
- **systemd**: Reliable service management and event hooks
- **Open Source Community**: Inspiration, feedback, and contributions

---

## 🚀 Get Started Today

```bash
git clone https://github.com/thebyrdman-git/ansai.git
cd ansai/orchestrators/ansible
ansible-playbook playbooks/deploy-complete-monitoring.yml
```

**Questions? Feedback? Ideas?**
- 💬 [GitHub Discussions](https://github.com/thebyrdman-git/ansai/discussions)
- 🐛 [Issue Tracker](https://github.com/thebyrdman-git/ansai/issues)
- 📧 [Community](https://github.com/thebyrdman-git/ansai/discussions)

---

**Build your automation. Your way.** 🚀

*ANSAI: The building blocks. Your creativity. Infinite possibilities.*
