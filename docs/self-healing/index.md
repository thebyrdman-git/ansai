# 🛡️ ANSAI Self-Healing Infrastructure

## Overview

ANSAI Self-Healing is a comprehensive, production-ready monitoring and auto-remediation system that ensures your infrastructure stays healthy 24/7. Following the **Everything-as-Code** philosophy, it deploys via Ansible and automatically detects, fixes, and reports on system issues.

## 🎯 Core Philosophy

> **"The system heals itself, then tells you what it fixed."**

ANSAI Self-Healing embodies three key principles:

1. **Config-as-Code**: All monitoring rules and healing strategies are versioned and repeatable
2. **Automated Remediation**: Common failures are fixed automatically before you notice
3. **Transparent Reporting**: Detailed email alerts explain what broke, how it was fixed, and why

## 📦 Components

### 1. Universal Service Healing
Monitors all systemd services and automatically attempts to fix failures using intelligent strategies:

- **Service restarts** with exponential backoff
- **Port conflict detection** and resolution
- **Configuration validation** before restart
- **Database health checks** and repair
- **Environment variable verification**
- **Email alerts** with fix details

[Learn more →](UNIVERSAL_SELF_HEALING.md)

### 2. JavaScript Error Monitoring
Comprehensive JavaScript error detection and reporting:

- **Static validation** of template syntax
- **Runtime error capture** from browsers
- **Automatic email alerts** when errors exceed threshold
- **Error aggregation** and reporting

[Learn more →](JS_ERROR_MONITORING.md)

### 3. CSS Error Monitoring
Detects missing CSS files and loading issues:

- **Missing file detection** in templates
- **Syntax validation** for CSS files
- **Runtime loading failure** capture
- **Automatic alerting** and reporting

[Learn more →](CSS_ERROR_MONITORING.md)

### 4. External Monitoring (Healthchecks.io)
Dead man's switch for complete coverage:

- **External monitoring** of server availability
- **Heartbeat reporting** for all services
- **Failure detection** when server is completely down
- **Multiple notification channels**

[Learn more →](HEALTHCHECKS_SETUP.md)

### 5. System Admin Self-Healing *(Coming Soon)*
Automated system administration tasks:

- **Disk space monitoring** and cleanup
- **Memory management** and optimization
- **System updates** automation
- **Certificate monitoring** and renewal
- **Database maintenance** and optimization
- **Network health** monitoring
- **Security audit** scanning

## 🚀 Quick Start

### Prerequisites

- Ansible 2.9+
- Target host with systemd
- Email (SMTP) credentials for alerts
- SSH access to target hosts

### 1. Deploy Complete Monitoring Stack

```bash
cd /home/jbyrd/ansai/orchestrators/ansible
ansible-playbook playbooks/deploy-complete-monitoring.yml
```

### 2. Configure Email Alerts

Edit `roles/universal_self_heal/defaults/main.yml`:

```yaml
owner_email: "your-email@example.com"
smtp_server: "smtp.gmail.com"
smtp_port: 587
smtp_user: "your-email@example.com"
smtp_password: "your-app-password"
```

### 3. Define Services to Monitor

```yaml
monitored_services:
  - name: "traefik"
    requires_db: false
    has_config: true
  - name: "passgo"
    requires_db: true
    has_config: false
  - name: "story-stages"
    requires_db: true
    has_config: false
```

### 4. Set Up External Monitoring

1. Create account at [healthchecks.io](https://healthchecks.io)
2. Create a new check
3. Copy the ping URL
4. Add to `roles/healthchecks_monitoring/defaults/main.yml`

```yaml
healthcheck_ping_url: "https://hc-ping.com/your-unique-uuid"
```

[Complete setup guide →](COMPLETE_MONITORING_STACK.md)

## 📊 Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    ANSAI Self-Healing                        │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   Service    │  │      JS      │  │     CSS      │      │
│  │   Healing    │  │  Monitoring  │  │  Monitoring  │      │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘      │
│         │                 │                  │               │
│         └─────────────────┼──────────────────┘               │
│                           │                                  │
│                    ┌──────▼───────┐                         │
│                    │   Email      │                         │
│                    │   Alerts     │                         │
│                    └──────────────┘                         │
│                                                               │
│  ┌──────────────────────────────────────────────────────┐  │
│  │           External Healthchecks.io                    │  │
│  │  (Dead Man's Switch for Server-Level Failures)        │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

## 🎓 Use Cases

### Production Web Applications

**Problem**: Your Flask app crashes at 2 AM due to database lock.

**ANSAI Solution**: 
1. Detects service failure within seconds
2. Checks database health
3. Repairs SQLite locks automatically
4. Restarts service
5. Emails you with full diagnostic report

### JavaScript Errors

**Problem**: Syntax error in template breaks user experience.

**ANSAI Solution**:
1. Static validation catches error during deployment
2. If missed, runtime capture detects browser errors
3. Aggregates errors across users
4. Sends alert when threshold exceeded
5. Provides exact file/line/error details

### CSS Loading Failures

**Problem**: Missing CSS file causes broken UI.

**ANSAI Solution**:
1. Pre-deployment validation checks all CSS references
2. Runtime monitoring detects loading failures
3. Alerts you with specific file and location
4. Prevents future deployments with same issue

### Complete Server Failure

**Problem**: Server becomes unresponsive (power, network, kernel panic).

**ANSAI Solution**:
1. Healthchecks.io detects missed heartbeat
2. Sends you emergency alert via email/SMS/Slack
3. You can take manual action (reboot, investigate)
4. When server recovers, heartbeat resumes automatically

## 📈 Benefits

### Developer Experience
- **Less firefighting**: System fixes common issues automatically
- **Better sleep**: Confidence that systems are monitored 24/7
- **Faster debugging**: Detailed logs and fix reports
- **Proactive alerts**: Know about issues before users complain

### Operational Excellence
- **99.9% uptime**: Automatic recovery from common failures
- **Reduced MTTR**: Mean time to recovery drops from hours to seconds
- **Complete visibility**: Every service monitored and reported
- **Audit trail**: Full history of failures and fixes

### Cost Savings
- **Reduced on-call burden**: Fewer middle-of-night pages
- **Infrastructure efficiency**: Automated cleanup and optimization
- **Faster incident response**: Root cause analysis built-in
- **Preventive maintenance**: Catch issues before they cascade

## 🧪 Testing Each Service

ANSAI includes comprehensive testing workflows:

```bash
# Test Universal Self-Healing
cd /home/jbyrd/ansai/orchestrators/ansible
./tests/test-service-healing.sh

# Test JS Monitoring
./tests/test-js-monitoring.sh

# Test CSS Monitoring
./tests/test-css-monitoring.sh

# Test Healthchecks Integration
./tests/test-healthchecks.sh
```

Each test:
- ✅ Simulates real failures
- ✅ Verifies automatic remediation
- ✅ Confirms email alerts
- ✅ Validates logs and reports

## 📦 Packaging for Distribution

### GitHub Repository

The complete ANSAI Self-Healing stack is available on GitHub:

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/ansai.git
cd ansai/orchestrators/ansible

# Deploy to your infrastructure
ansible-playbook playbooks/deploy-complete-monitoring.yml
```

### Ansible Galaxy (Coming Soon)

Install directly from Ansible Galaxy:

```bash
ansible-galaxy collection install ansai.self_healing
```

## 🤝 Contributing

ANSAI Self-Healing is built following **ansai workflows** and **everything-as-code** principles. Contributions are welcome!

### Adding New Healing Strategies

1. Create a new role in `orchestrators/ansible/roles/`
2. Follow the template pattern from existing roles
3. Add comprehensive testing
4. Update documentation
5. Submit pull request

### Reporting Issues

Open an issue on GitHub with:
- Description of the failure scenario
- Logs from `/var/log/self-healing/`
- Email alert content
- Steps to reproduce

## 📚 Learn More

- [Universal Self-Healing Guide](UNIVERSAL_SELF_HEALING.md)
- [JavaScript Monitoring Guide](JS_ERROR_MONITORING.md)
- [CSS Monitoring Guide](CSS_ERROR_MONITORING.md)
- [Healthchecks Setup](HEALTHCHECKS_SETUP.md)
- [Complete Stack Deployment](COMPLETE_MONITORING_STACK.md)

## 🎯 Next Steps

1. **Deploy the basics**: Start with Universal Self-Healing
2. **Add monitoring**: Enable JS and CSS error detection
3. **Set up external**: Configure Healthchecks.io for complete coverage
4. **Customize alerts**: Adjust thresholds and notification preferences
5. **Extend healing**: Add your own auto-remediation strategies

---

**Built with ANSAI Everything-as-Code Philosophy** 🚀

*Because your infrastructure should heal itself.*

