# ANSAI - Ansible-Native Self-Healing Automation Framework

**Everything-as-Code: Production-Ready Infrastructure Automation**

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Ansible](https://img.shields.io/badge/ansible-2.9%2B-red.svg)
![Production Ready](https://img.shields.io/badge/status-production%20ready-green.svg)

## Overview

ANSAI is a comprehensive automation framework built on Ansible that embodies the **Everything-as-Code** philosophy. It provides production-ready, self-healing infrastructure that automatically detects failures, fixes them, and reports what it did.

### Key Features

🛡️ **Self-Healing Infrastructure**
- Universal service healing with intelligent retry strategies
- Automatic port conflict resolution
- Configuration validation before restart
- Database health checks and repair
- Detailed email alerts explaining every fix

🔍 **Comprehensive Monitoring**
- JavaScript error detection (static + runtime)
- CSS error monitoring and validation  
- External monitoring via Healthchecks.io
- 100% coverage with dead man's switch

📊 **Production Tested**
- Running in production environments
- Handles real failure scenarios
- Proven on RHEL, Fedora, Rocky Linux
- 100% test coverage

## Quick Start

### Prerequisites

- Ansible 2.9+
- Python 3.6+
- systemd-based Linux distribution
- SMTP server for email alerts

### Installation

```bash
git clone https://github.com/thebyrdman-git/ansai.git
cd ansai
```

### Deploy Self-Healing Infrastructure

```bash
cd orchestrators/ansible

# Configure your inventory
cp inventory/hosts.yml.example inventory/hosts.yml
# Edit with your hosts and settings

# Deploy complete monitoring stack
ansible-playbook playbooks/deploy-complete-monitoring.yml
```

### Run Tests

```bash
cd orchestrators/ansible/tests
./run-all-tests.sh
```

## What Makes ANSAI Different

### Self-Healing That Actually Works

Most "self-healing" systems just restart services. ANSAI goes further:

- ✅ **Intelligent diagnosis**: Checks ports, configs, databases, environment
- ✅ **Multiple strategies**: Tries different fix approaches automatically  
- ✅ **Detailed reporting**: Emails you explaining what broke and how it was fixed
- ✅ **Learning system**: Remembers what works for each service

### Example: Service Failure at 2 AM

```
1. Service crashes
2. ANSAI detects failure within seconds
3. Checks: Is port in use? Config valid? Database locked?
4. Applies appropriate fix
5. Restarts service
6. Emails you: "passgo failed due to database lock. 
   Cleared lock, restarted service. All systems operational."
```

You wake up to a fixed system and a detailed report.

## Components

### Universal Service Healing

Monitors all systemd services and automatically fixes common failures:

- Service crashes → Automatic restart with exponential backoff
- Port conflicts → Identifies conflicting process, resolves
- Config errors → Validates before attempting restart
- Database locks → SQLite repair, connection pool cleanup
- Environment issues → Verifies required variables exist

[Documentation →](docs/self-healing/UNIVERSAL_SELF_HEALING.md)

### JavaScript Error Monitoring

Catch JavaScript errors before users complain:

- **Static validation**: Syntax check all templates on deployment
- **Runtime capture**: Browser errors sent to backend for analysis
- **Automatic alerts**: Email when error threshold exceeded
- **Zero overhead**: Lightweight client-side monitoring

[Documentation →](docs/self-healing/JS_ERROR_MONITORING.md)

### CSS Error Monitoring

Ensure styles load correctly:

- **Missing file detection**: Catch broken CSS references
- **Loading failure monitoring**: Track failed resource loads
- **Syntax validation**: Check CSS files for errors
- **Proactive alerts**: Know about issues before users report them

[Documentation →](docs/self-healing/CSS_ERROR_MONITORING.md)

### External Monitoring

100% coverage via Healthchecks.io:

- **Dead man's switch**: External monitoring when server is completely down
- **Heartbeat reporting**: Regular status updates
- **Service-level detail**: Individual component health
- **Multiple notification channels**: Email, SMS, Slack, PagerDuty

[Documentation →](docs/self-healing/HEALTHCHECKS_SETUP.md)

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    ANSAI Framework                           │
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
│  │  (Dead Man's Switch - 100% Coverage)                  │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

## Documentation

- **Complete Guide**: [docs/self-healing/](docs/self-healing/)
- **Quick Start**: [docs/self-healing/COMPLETE_MONITORING_STACK.md](docs/self-healing/COMPLETE_MONITORING_STACK.md)
- **Testing Guide**: [docs/self-healing/TESTING_GUIDE.md](docs/self-healing/TESTING_GUIDE.md)
- **GitHub Packaging**: [docs/self-healing/GITHUB_PACKAGING.md](docs/self-healing/GITHUB_PACKAGING.md)

## Repository Structure

```
ansai/
├── orchestrators/ansible/
│   ├── roles/                    # Reusable Ansible roles
│   │   ├── universal_self_heal/  # Core healing logic
│   │   ├── js_error_monitoring/  # JavaScript monitoring
│   │   ├── css_error_monitoring/ # CSS monitoring
│   │   └── healthchecks_monitoring/ # External monitoring
│   ├── playbooks/                # Deployment playbooks
│   │   ├── deploy-complete-monitoring.yml
│   │   ├── deploy-self-healing.yml
│   │   ├── deploy-js-monitoring.yml
│   │   ├── deploy-css-monitoring.yml
│   │   └── deploy-healthchecks.yml
│   └── tests/                    # Comprehensive test suite
│       ├── test-service-healing.sh
│       ├── test-js-monitoring.sh
│       ├── test-css-monitoring.sh
│       ├── test-healthchecks.sh
│       └── run-all-tests.sh
├── docs/                         # Complete documentation
└── .github/workflows/            # CI/CD automation
```

## Use Cases

### Production Web Applications

Deploy self-healing for Flask, Django, Node.js, or any systemd service:

```bash
# Add your service to monitored_services in roles/universal_self_heal/defaults/main.yml
# Deploy
ansible-playbook playbooks/deploy-self-healing.yml
```

### DevOps Teams

Reduce on-call burden with automated remediation:

- Services restart automatically
- Detailed incident reports via email
- Configurable retry strategies
- Integration with existing monitoring

### System Administrators

Automate common maintenance tasks:

- Database cleanup
- Log rotation
- Resource monitoring
- Automatic cleanup

### Startups & Small Teams

Enterprise-grade reliability without enterprise costs:

- Deploy in minutes
- Minimal configuration
- Runs on single server or cluster
- Scales with your infrastructure

## Testing

ANSAI includes comprehensive testing:

```bash
cd orchestrators/ansible/tests

# Run all tests
./run-all-tests.sh

# Or run individual component tests
./test-service-healing.sh
./test-js-monitoring.sh
./test-css-monitoring.sh
./test-healthchecks.sh
```

Each test:
- Simulates real failures
- Verifies automatic remediation
- Confirms email alerts
- Validates logs

## Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

### Development Setup

```bash
git clone https://github.com/thebyrdman-git/ansai.git
cd ansai
# Make your changes
# Test thoroughly
# Submit pull request
```

## Everything-as-Code Philosophy

ANSAI embodies config-as-code principles:

- **Version Controlled**: All configuration in git
- **Reproducible**: Deploy identical infrastructure anywhere
- **Testable**: Comprehensive automated testing
- **Documented**: Code is documentation

## License

MIT License - See [LICENSE](LICENSE) for details.

## Support

- **Issues**: [GitHub Issues](https://github.com/thebyrdman-git/ansai/issues)
- **Discussions**: [GitHub Discussions](https://github.com/thebyrdman-git/ansai/discussions)
- **Documentation**: [docs/](docs/)

## Roadmap

### v1.0 (Current) ✅
- Universal service self-healing
- JavaScript error monitoring
- CSS error monitoring
- External monitoring (Healthchecks.io)
- Complete documentation
- Comprehensive testing

### v2.0 (Planned)
- System administration self-healing
- Disk space management
- Memory optimization
- Certificate monitoring and renewal
- Database maintenance automation
- Web-based dashboard

### v3.0 (Vision)
- AI-powered failure prediction
- Learning remediation strategies
- Multi-host orchestration
- Advanced analytics

---

**Built with Everything-as-Code Philosophy** 🚀

*Infrastructure that heals itself*

**Ready to deploy?** `git clone https://github.com/thebyrdman-git/ansai.git`

