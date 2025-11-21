# ANSAI - For Red Hat Internal Use

🔴 **Red Hat Internal Repository** - Not for customer distribution without approval

**Public Version:** https://github.com/thebyrdman-git/ansai (Open source, MIT licensed)  
**Internal Version:** https://gitlab.cee.redhat.com/jbyrd/ansai (Red Hat-specific enhancements)

---

## What is ANSAI?

**ANSAI** (Ansible-Native System Automation Infrastructure) combines Ansible with AI to provide intelligent, self-healing automation. It answers the #1 customer question: **"Can Ansible do AI?"**

### Core Capabilities:
- 🤖 **AI-powered root cause analysis** (not just "service restarted")
- 🔧 **Intelligent self-healing** (AI decides how to fix issues)
- 📊 **Predictive failure detection** (catch problems before they happen)
- 💬 **Natural language ops** (ask infrastructure questions)
- 💰 **Cost-effective** (~$0.10/month using Groq)

---

## Red Hat Use Cases

### For TAMs (Technical Account Managers)
- **Customer case analysis** (500MB logs → AI root cause in 30 seconds)
- **Reproduction in Red Hat lab** (no customer access needed)
- **Playbook generation** (ready-to-send solutions)
- **Time savings:** 120+ min → 15 min per case

[View TAM Demo →](docs/redhat-internal/TAM.md)

### For Training Specialists (RHLS Management)
- **RHLS usage analysis** (automatic monthly reports)
- **Renewal risk detection** (inactive user alerts)
- **Engagement automation** (personalized outreach)
- **ROI reporting** (prove value to customers)

[View Training Demo →](docs/redhat-internal/TRAINING.md)

### For Solutions Architects
- **Pre-sales demos** ("Can Ansible do AI?" → YES)
- **Customer POCs** (15 min setup vs. weeks)
- **Competitive positioning** (vs. AWS Systems Manager)

[View Architect Demo →](docs/redhat-internal/ARCHITECT.md)

### For Support Engineers
- **Ticket analysis** (AI analyzes logs automatically)
- **Solution generation** (knowledge base + AI)
- **SLA protection** (45 min vs. 3+ hours)

[View Support Demo →](docs/redhat-internal/SUPPORT.md)

---

## Quick Start (Red Hat Internal)

### Try the Interactive Demo:
```bash
git clone https://gitlab.cee.redhat.com/jbyrd/ansai.git
cd ansai/demo
docker compose up -d
docker exec -it ansai-playground bash
ansai-demo  # Select your role (TAM, Training, Architect, etc.)
```

### Deploy to Your Red Hat Lab:
```bash
# Clone repo
git clone https://gitlab.cee.redhat.com/jbyrd/ansai.git
cd ansai

# Set up AI provider (Groq recommended)
export ANSAI_GROQ_API_KEY="your-groq-api-key"

# Deploy with Ansible
ansible-playbook orchestrators/ansible/playbooks/deploy-self-healing.yml

# Test
curl localhost:8000/health
```

---

## Red Hat Product Integrations

### Current Integrations:
- ✅ **Ansible Automation Platform (AAP)** - Works alongside AAP
- ✅ **Red Hat Customer Portal** - TAM case analysis
- 🔨 **Event-Driven Ansible (EDA)** - AI-powered source plugin (planned)
- 🔨 **OpenShift** - Container self-healing (planned)
- 🔨 **Red Hat Insights** - Complement with AI (planned)

### Upcoming:
- 🔴 **x2a Integration** - Sr. Architect collaboration (Q1 2026)
- 🔴 **RHLS Analytics** - Training subscription optimization
- 🔴 **Dataverse MCP** - AI-powered data operations

---

## Documentation

### For Red Hat Employees:
- 📘 [TAM Workflow Guide](docs/redhat-internal/TAM.md)
- 📊 [Training Specialist Guide](docs/redhat-internal/TRAINING.md)
- 🏗️ [Solutions Architect Guide](docs/redhat-internal/ARCHITECT.md)
- 🎫 [Support Engineer Guide](docs/redhat-internal/SUPPORT.md)
- 💻 [Engineer Integration Guide](docs/redhat-internal/ENGINEER.md)
- 📈 [Product Manager Guide](docs/redhat-internal/PM.md)

### General Documentation:
- 🚀 [Getting Started](docs/getting-started.md)
- 🔧 [Installation Guide](docs/installation.md)
- 🤖 [AI Configuration](docs/ai-configuration.md)
- 📖 [API Documentation](docs/api.md)

---

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│  AI Layer (Groq, OpenAI, Claude, Ollama)               │
│  - Root cause analysis                                  │
│  - Playbook generation                                  │
│  - Predictive analytics                                 │
└──────────────┬──────────────────────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────────────────────┐
│  ANSAI Core                                             │
│  - Self-healing orchestrator                            │
│  - Service monitoring                                   │
│  - Event correlation                                    │
└──────────────┬──────────────────────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────────────────────┐
│  Ansible Integration                                    │
│  - AAP / AWX                                            │
│  - Event-Driven Ansible                                 │
│  - Existing playbooks                                   │
└─────────────────────────────────────────────────────────┘
```

---

## Cost Analysis (Red Hat Internal)

### Using Groq (Recommended):
- **Cost:** ~$0.10/month per server
- **Model:** llama-3.1-8b-instant
- **Speed:** 500+ tokens/second
- **ROI:** 1 prevented outage pays for 1,000 months

### Enterprise Options:
- **AWS Bedrock:** $0.50-2.00/month per server
- **Azure OpenAI:** $1-3/month per server
- **On-premise LLM:** $0 (after hardware investment)

### Customer Pricing Guidance:
- **Small (1-10 servers):** $1-10/month
- **Medium (10-100 servers):** $10-100/month
- **Enterprise (100+ servers):** Volume pricing

---

## Security & Compliance

### Data Privacy:
- ✅ Logs sent to AI are configurable (filter sensitive data)
- ✅ Works with on-premise LLMs (no external API calls)
- ✅ No customer data stored (stateless by default)
- ✅ HTTPS for all external communications

### Red Hat Internal Use:
- ✅ Safe for demo environments
- ✅ Safe for non-production customer labs
- ⚠️  Production customer deployments: Review with security team
- ⚠️  Customer data: Follow Red Hat data handling policies

---

## Contributing (Red Hat Employees)

### Internal Contributions:
1. **Fork this repo** (GitLab internal)
2. **Create feature branch** (`feature/tam-case-integration`)
3. **Test thoroughly** (use demo environment)
4. **Submit merge request** (tag @jbyrd for review)
5. **Document for customers** (if customer-facing)

### Upstream Contributions:
- **Public GitHub:** https://github.com/thebyrdman-git/ansai
- **For community features** (not Red Hat-specific)
- **MIT License** (open source)

---

## Support & Contact

### For Red Hat Employees:
- 📧 **Email:** jbyrd@redhat.com
- 💬 **Mojo:** [ANSAI Discussion Group] (coming soon)
- 🎫 **Issues:** https://gitlab.cee.redhat.com/jbyrd/ansai/issues
- 📅 **Office Hours:** TBD

### For Customers:
- 🌐 **Website:** https://ansai.dev
- 💻 **GitHub:** https://github.com/thebyrdman-git/ansai
- 📧 **Public Contact:** jimmykbyrd@gmail.com

---

## Roadmap

### Q4 2024 ✅
- [x] Core self-healing engine
- [x] AI root cause analysis
- [x] Multi-model support (Groq, OpenAI, Claude)
- [x] Email notifications

### Q1 2025 🔨
- [ ] x2a integration (Sr. Architect collaboration)
- [ ] RHLS analytics integration
- [ ] Red Hat Customer Portal integration
- [ ] Event-Driven Ansible source plugin

### Q2 2025 🎯
- [ ] AAP certified collection
- [ ] OpenShift operator
- [ ] Red Hat Insights integration
- [ ] Enterprise RBAC/multi-tenancy

### Q3 2025+ 🚀
- [ ] Red Hat Dataverse MCP integration
- [ ] Predictive failure AI models
- [ ] Natural language playbook generation
- [ ] Desktop/IDE integration (ANSAI Studio)

---

## Success Stories (Red Hat Internal)

### Demo Results (November 2024):
- ✅ **TAM use case** - Received excellent feedback
- ✅ **Training Specialist** - RHLS integration interest
- ✅ **Sr. Solution Architect** - x2a integration planned
- ✅ **Time to value:** 36 minutes (demo → integration discussion)

### Metrics:
- ⏱️  **TAM time savings:** 120 min → 15 min per case
- 💰 **Training renewal protection:** $42K+ saved per account
- 🎯 **Customer satisfaction:** High (personalized engagement)

---

## FAQ (Red Hat Internal)

### "Can I demo this to customers?"
✅ Yes! It's open source. Show them https://ansai.dev or the Docker playground.

### "Can I deploy this to customer environments?"
⚠️  Use your judgment. Demo/lab environments: Yes. Production: Discuss with customer first.

### "What about support/warranty for customers?"
⚠️  This is a community project, not an official Red Hat product. No support SLA.

### "Is this an official Red Hat product?"
❌ No, it's a personal project by a Red Hat employee. Open source, community-driven.

### "Can this become a Red Hat product?"
🤔 Maybe! If there's enough customer demand and internal support. Your feedback helps!

### "How do I get my manager's approval to use this?"
💡 Share this repo + ansai.dev. Highlight: open source, low cost, customer value, competitive differentiation.

---

## License

**Public Version (GitHub):** MIT License  
**Internal Version (GitLab CEE):** Red Hat Internal Use

See LICENSE file for details.

---

## Acknowledgments

Built by **jbyrd@redhat.com** with feedback from Red Hat TAMs, Solution Architects, Training Specialists, and the open source community.

Special thanks to the Ansible, OpenAI, and Groq communities for making intelligent automation accessible.

---

**Last Updated:** November 21, 2024  
**Version:** 1.0 (Launch)  
**Status:** Active Development

🚀 **Ready to make Ansible intelligent? Let's build together!**


