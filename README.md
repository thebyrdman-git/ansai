# ANSAI - Ansible-Native Automation & Intelligence Framework

**Everything-as-Code: Comprehensive Automation for Modern Infrastructure**

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Ansible](https://img.shields.io/badge/ansible-2.9%2B-red.svg)
![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)

## Overview

ANSAI is a comprehensive automation framework built on Ansible that embodies the **Everything-as-Code** philosophy. It provides production-ready automation patterns, intelligent workflows, and self-healing infrastructure for modern DevOps teams.

### Vision

ANSAI aims to be your complete automation toolkit:

- 🛡️ **Self-Healing Infrastructure** - Automatic failure detection and remediation (v1.0)
- 🔄 **Workflow Orchestration** - Complex multi-service automation (coming soon)
- 🏗️ **Infrastructure-as-Code** - Reusable deployment patterns (coming soon)
- 🔗 **Service Integration** - Pre-built connectors and patterns (coming soon)
- 📊 **Observability** - Comprehensive monitoring and analytics (coming soon)

## Current Release: v1.0 - Self-Healing Infrastructure

The first production release focuses on self-healing infrastructure - a foundational capability that makes everything else more reliable.

### Self-Healing Features

🛡️ **Universal Service Healing**
- Automatic service restart with intelligent retry strategies
- Port conflict detection and resolution
- Configuration validation before restart
- Database health checks and repair
- Detailed email alerts explaining every fix

🔍 **Comprehensive Monitoring**
- JavaScript error detection (static + runtime)
- CSS error monitoring and validation  
- External monitoring via Healthchecks.io
- 100% coverage with dead man's switch

📊 **Production Proven**
- Running in production environments
- Handles real failure scenarios
- Tested on RHEL, Fedora, Rocky Linux
- 100% test coverage

### Why Self-Healing First?

Self-healing is the foundation for reliable automation:

- ✅ **Reduces operational burden** - Systems fix themselves
- ✅ **Enables confidence** - Deploy knowing systems will recover
- ✅ **Provides visibility** - Detailed reports on what broke and how it was fixed
- ✅ **Scales automation** - Can't scale if you're constantly firefighting

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

### Deploy Self-Healing (v1.0)

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

## Architecture

ANSAI is designed as a modular, composable framework:

```
┌─────────────────────────────────────────────────────────────┐
│                    ANSAI Framework                           │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌───────────────────────────────────────────────────┐      │
│  │        Self-Healing Infrastructure (v1.0)         │      │
│  ├───────────────────────────────────────────────────┤      │
│  │  Service Healing  │  JS Monitor  │  CSS Monitor  │      │
│  │  External Monitor │  Email Alerts │  Testing     │      │
│  └───────────────────────────────────────────────────┘      │
│                                                               │
│  ┌───────────────────────────────────────────────────┐      │
│  │     Workflow Orchestration (Coming in v2.0)       │      │
│  │  Multi-service workflows, dependencies, rollbacks │      │
│  └───────────────────────────────────────────────────┘      │
│                                                               │
│  ┌───────────────────────────────────────────────────┐      │
│  │    Infrastructure Patterns (Coming in v2.0)       │      │
│  │  Web apps, databases, load balancers, networking  │      │
│  └───────────────────────────────────────────────────┘      │
│                                                               │
│  ┌───────────────────────────────────────────────────┐      │
│  │      Service Integrations (Coming in v3.0)        │      │
│  │  APIs, message queues, data pipelines, webhooks   │      │
│  └───────────────────────────────────────────────────┘      │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

## Core Principles

### Everything-as-Code

All automation is version-controlled and reproducible:

- **Config-as-Code**: All configuration in git
- **Infrastructure-as-Code**: Declarative infrastructure
- **Test-as-Code**: Automated testing
- **Documentation-as-Code**: Generated from source

### Composability

Build complex automation from simple, reusable components:

- Modular Ansible roles
- Chainable workflows
- Standard interfaces
- Mix and match capabilities

### Production-First

Built for real-world production use:

- Battle-tested patterns
- Comprehensive testing
- Detailed documentation
- Security-focused

### Intelligent Automation

Goes beyond basic automation:

- Self-healing capabilities
- Context-aware decisions
- Learning from failures
- Proactive optimization

## What's in v1.0

### Components

- **Universal Service Healing**: Monitors and heals systemd services
- **JavaScript Monitoring**: Static + runtime error detection
- **CSS Monitoring**: Resource loading and validation
- **External Monitoring**: Healthchecks.io integration for complete coverage

### Documentation

- Complete setup guides
- Architecture documentation
- Testing guides
- Troubleshooting references

### Testing

- Comprehensive test suite
- Real failure simulation
- Automated validation
- 100% coverage

[Complete v1.0 Documentation →](docs/self-healing/)

## Roadmap

### v1.0 (Current) ✅
**Self-Healing Infrastructure**
- Universal service healing
- JavaScript & CSS monitoring
- External monitoring (Healthchecks.io)
- Complete documentation
- Comprehensive testing

### v2.0 (Planned)
**System Administration Automation**
- Disk space management
- Memory optimization
- System updates automation
- Certificate monitoring & renewal
- Database maintenance
- Network health monitoring
- Security audit automation

**Enhanced Workflows**
- Multi-service orchestration
- Dependency management
- Rollback capabilities
- Blue-green deployments

### v3.0 (Vision)
**Intelligent Automation**
- AI-powered failure prediction
- Learning remediation strategies
- Automatic optimization
- Predictive scaling

**Service Integrations**
- Pre-built API connectors
- Message queue integration
- Data pipeline patterns
- Webhook automation

**Enterprise Features**
- Multi-tenant support
- Role-based access control
- Audit logging
- Compliance reporting

## Use Cases

### Self-Healing Infrastructure (v1.0)

**Production Web Applications**
```bash
# Monitor Flask, Django, Node.js, or any systemd service
ansible-playbook playbooks/deploy-self-healing.yml
```

**DevOps Teams**
- Reduce on-call burden with automated remediation
- Get detailed incident reports via email
- Integrate with existing monitoring

**System Administrators**
- Automate common maintenance
- Ensure service reliability
- Track system health

### Future Capabilities

**Workflow Orchestration (v2.0)**
- Deploy multi-tier applications
- Coordinate database migrations
- Manage blue-green deployments

**Infrastructure Patterns (v2.0)**
- Web application stacks
- Database clusters
- Load balancer configuration
- Network automation

**Service Integration (v3.0)**
- Connect to external APIs
- Process message queues
- Automate data pipelines
- Trigger webhooks

## Repository Structure

```
ansai/
├── orchestrators/ansible/
│   ├── roles/                    # Reusable Ansible roles
│   │   ├── universal_self_heal/  # Core healing logic (v1.0)
│   │   ├── js_error_monitoring/  # JS monitoring (v1.0)
│   │   ├── css_error_monitoring/ # CSS monitoring (v1.0)
│   │   └── healthchecks_monitoring/ # External monitoring (v1.0)
│   ├── playbooks/                # Deployment playbooks
│   │   └── deploy-*.yml         # Self-healing playbooks (v1.0)
│   ├── tests/                    # Comprehensive test suite
│   │   └── test-*.sh            # Component tests (v1.0)
│   └── inventory/                # Example inventory
├── docs/                         # Complete documentation
│   └── self-healing/            # v1.0 documentation
└── .github/workflows/            # CI/CD automation
```

## Documentation

- **v1.0 Self-Healing**: [docs/self-healing/](docs/self-healing/)
- **Quick Start**: [docs/self-healing/COMPLETE_MONITORING_STACK.md](docs/self-healing/COMPLETE_MONITORING_STACK.md)
- **Testing Guide**: [docs/self-healing/TESTING_GUIDE.md](docs/self-healing/TESTING_GUIDE.md)
- **API Reference**: Coming with v2.0

## Testing

ANSAI includes comprehensive testing for all components:

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

## Contributing

We welcome contributions! ANSAI is designed to be community-driven.

### Areas for Contribution

**v1.0 Improvements**
- Additional healing strategies
- More monitoring integrations
- Enhanced testing
- Documentation improvements

**v2.0 Development**
- Workflow orchestration patterns
- Infrastructure templates
- System administration automation

**v3.0 Features**
- Service integrations
- AI/ML capabilities
- Advanced analytics

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## Community

- **Issues**: [GitHub Issues](https://github.com/thebyrdman-git/ansai/issues)
- **Discussions**: [GitHub Discussions](https://github.com/thebyrdman-git/ansai/discussions)
- **Roadmap**: [GitHub Projects](https://github.com/thebyrdman-git/ansai/projects)

## Philosophy

ANSAI is built on core principles:

1. **Everything-as-Code** - All automation is version-controlled
2. **Composability** - Build complex from simple components  
3. **Production-First** - Battle-tested, not experimental
4. **Intelligence** - Automation that learns and adapts
5. **Community-Driven** - Open source, collaborative development

## License

MIT License - See [LICENSE](LICENSE) for details.

## Getting Started

### For Self-Healing (v1.0)

```bash
git clone https://github.com/thebyrdman-git/ansai.git
cd ansai/orchestrators/ansible
cp inventory/hosts.yml.example inventory/hosts.yml
# Edit inventory with your hosts
ansible-playbook playbooks/deploy-complete-monitoring.yml
```

### Stay Updated

- ⭐ Star the repository
- 👀 Watch for releases
- 📬 Join discussions
- 🤝 Contribute

---

**ANSAI: Comprehensive Automation for Modern Infrastructure** 🚀

*Currently featuring production-ready self-healing infrastructure (v1.0)*

**Ready to deploy?** `git clone https://github.com/thebyrdman-git/ansai.git`
