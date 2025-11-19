# 🎓 ANSAI Interactive Tutorials

**Learn by building. Step-by-step, executable tutorials.**

Each tutorial is an interactive script that walks you through building a real ANSAI workflow. Copy-paste to run, or study the code to understand how it works.

---

## 📚 Available Tutorials

### 🏗️ Infrastructure Automation

1. **[Auto-Scale Based on Error Rates →](01-auto-scale-on-errors.sh)**  
   Automatically scale resources when error rates spike
   
2. **[ChatOps for Infrastructure →](02-chatops-infrastructure.sh)**  
   Control your infrastructure from Slack/Discord
   
3. **[Multi-Cloud Orchestration →](03-multi-cloud-orchestration.sh)**  
   Deploy to AWS with automatic DigitalOcean fallback
   
4. **[Cost Optimization Scheduling →](04-cost-optimization-scheduling.sh)**  
   Shutdown dev environments at night, save 50%

### 🔒 Security & Compliance

5. **[Compliance Auto-Remediation →](05-compliance-remediation.sh)**  
   Automatically fix security misconfigurations
   
6. **[Chaos Engineering Testing →](06-chaos-engineering.sh)**  
   Test self-healing with random service failures

### 🤖 Advanced AI Ops

7. **[Self-Optimizing Database →](07-database-tuning.sh)**  
   AI-powered PostgreSQL/MySQL configuration tuning
   
8. **[Predictive Maintenance →](08-predictive-maintenance.sh)**  
   Detect and fix issues before they happen

---

## 🚀 How to Use

### Option 1: Run Directly (Easiest)

```bash
# Download and run any tutorial
curl -sSL https://raw.githubusercontent.com/thebyrdman-git/ansai/main/docs/examples/tutorials/01-auto-scale-on-errors.sh | bash
```

### Option 2: Download and Customize

```bash
# Download tutorial
curl -O https://raw.githubusercontent.com/thebyrdman-git/ansai/main/docs/examples/tutorials/01-auto-scale-on-errors.sh

# Make it executable
chmod +x 01-auto-scale-on-errors.sh

# Review the code
cat 01-auto-scale-on-errors.sh

# Run it
./01-auto-scale-on-errors.sh
```

### Option 3: Clone All Tutorials

```bash
# Clone ANSAI repository
git clone https://github.com/thebyrdman-git/ansai.git
cd ansai/docs/examples/tutorials

# Run any tutorial
./01-auto-scale-on-errors.sh
```

---

## 📖 Tutorial Format

Each tutorial follows this structure:

1. **Introduction**: What you'll build and why it's useful
2. **Prerequisites**: What you need before starting
3. **Step-by-Step**: Interactive guided implementation
4. **Testing**: Verify it works
5. **Customization**: How to adapt it to your needs
6. **Next Steps**: Related tutorials and documentation

Tutorials are designed to be:
- ✅ **Interactive**: Prompts and confirmations
- ✅ **Educational**: Explanations at each step
- ✅ **Practical**: Real, working code
- ✅ **Customizable**: Easy to adapt to your environment

---

## 🎯 Learning Paths

### Path 1: Getting Started with ANSAI
1. Start: [ChatOps for Infrastructure](02-chatops-infrastructure.sh)
2. Then: [Auto-Scale Based on Error Rates](01-auto-scale-on-errors.sh)
3. Finally: [Compliance Auto-Remediation](05-compliance-remediation.sh)

### Path 2: Advanced AI Operations
1. Start: [Self-Optimizing Database](07-database-tuning.sh)
2. Then: [Predictive Maintenance](08-predictive-maintenance.sh)
3. Finally: [Multi-Cloud Orchestration](03-multi-cloud-orchestration.sh)

### Path 3: Security & Reliability
1. Start: [Compliance Auto-Remediation](05-compliance-remediation.sh)
2. Then: [Chaos Engineering Testing](06-chaos-engineering.sh)
3. Finally: [Cost Optimization Scheduling](04-cost-optimization-scheduling.sh)

---

## 💡 Tips for Success

### Before Starting

```bash
# 1. Install ANSAI
curl -sSL https://raw.githubusercontent.com/thebyrdman-git/ansai/main/install.sh | bash

# 2. Set up AI provider
export ANSAI_GROQ_API_KEY="your-key-here"  # Get free key at console.groq.com

# 3. Verify installation
ansai-self-test
```

### During Tutorials

- **Read the code**: Don't just run it, understand it
- **Customize**: Replace example values with your real ones
- **Experiment**: Try variations and see what happens
- **Ask questions**: Use GitHub Discussions

### After Completing

- **Share your results**: Post in Show & Tell
- **Contribute improvements**: Submit PRs
- **Build on it**: Combine tutorials for more complex workflows

---

## 🐛 Troubleshooting

### Tutorial won't run

```bash
# Check permissions
ls -l tutorial-name.sh

# Make executable
chmod +x tutorial-name.sh

# Check for dependencies
which ansible
which python3
```

### AI not working

```bash
# Verify API key
echo $ANSAI_GROQ_API_KEY

# Test Groq API
curl https://api.groq.com/openai/v1/models \
  -H "Authorization: Bearer $ANSAI_GROQ_API_KEY"
```

### Ansible errors

```bash
# Check Ansible version
ansible --version

# Verify inventory
ansible-inventory --list

# Test connection
ansible all -m ping
```

---

## 🤝 Contributing Tutorials

**Built a great workflow? Share it as a tutorial!**

### Tutorial Template

```bash
#!/bin/bash
# Tutorial: [Your Topic]
# Description: [What users will learn]
# Time: [Estimated completion time]
# Prerequisites: [What's needed]

set -e

# [Your tutorial code here]
```

### Submission Guidelines

1. **Clear objectives**: State what users will learn
2. **Interactive**: Include prompts and explanations
3. **Tested**: Run it on a fresh system
4. **Documented**: Comments explaining each step
5. **Safe**: No destructive operations without confirmation

**[Submit Your Tutorial →](https://github.com/thebyrdman-git/ansai/pulls)**

---

## 📊 Tutorial Statistics

- **Total Tutorials**: 8
- **Average Time**: 15-30 minutes
- **Difficulty Range**: Beginner to Advanced
- **Languages**: Bash, Python, YAML
- **Community Contributions**: Coming soon!

---

## 🌟 Most Popular

Based on community feedback:

1. 🥇 **ChatOps for Infrastructure** - Control servers from Slack
2. 🥈 **Auto-Scale on Errors** - Dynamic resource scaling
3. 🥉 **Self-Optimizing Database** - AI-powered tuning

---

## 📚 Additional Resources

- **Documentation**: [ansai.dev](https://ansai.dev)
- **Examples**: [View all examples](../index.md)
- **Community Roles**: [ANSAI + Ansible Galaxy](../COMMUNITY_ROLES.md)
- **Getting Started**: [Quick Start Guide](../../GETTING_STARTED.md)

---

## 💬 Get Help

- **Questions**: [GitHub Discussions](https://github.com/thebyrdman-git/ansai/discussions)
- **Issues**: [Report bugs](https://github.com/thebyrdman-git/ansai/issues)
- **Ideas**: [Suggest tutorials](https://github.com/thebyrdman-git/ansai/discussions/categories/ideas)

---

**Happy learning! Build intelligent automation.** 🚀

