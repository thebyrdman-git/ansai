# Context Switch - Multi-Environment Orchestration

## Purpose

Switch between different work contexts (work, personal, finance, etc.) with automatic environment configuration, security policies, and tool integration. Think of it as "profiles" for your entire automation infrastructure.

## What It Demonstrates

- **Context Management:** Separate configurations for different life/work domains
- **Environment Orchestration:** Automatic environment setup when switching contexts
- **Security Patterns:** Context-specific security policies and data isolation
- **Hook System:** Extensible pre/post-switch hooks for custom actions
- **Multi-Tenant Patterns:** Run multiple isolated environments on one system

## Prerequisites

- Bash 4.0+
- Optional: `ansai-rules-generate` for automatic IDE configuration generation (if you use Cursor or similar IDEs)
- Optional: Custom hooks in `~/.config/ansai/hooks/`

## Configuration

### Initial Setup

1. Create the configuration directory:
```bash
mkdir -p ~/.config/ansai/hooks
```

2. Create a `contexts.yaml` file (optional, for custom contexts):
```yaml
# ~/.config/ansai/contexts.yaml
contexts:
  work:
    description: "Professional work projects"
    security_level: strict
    data_location: ~/work-data
    allowed_apis: []
    
  personal:
    description: "Personal projects and learning"
    security_level: standard
    data_location: ~/personal-data
    allowed_apis: [openai, anthropic]
    
  finance:
    description: "Financial automation"
    security_level: high
    data_location: ~/finance-data
    privacy_mode: local-only
    encryption: required
```

### Hook System

Create executable hooks for context-specific actions:

```bash
# Pre-switch hook example
# ~/.config/ansai/hooks/pre-switch-work.sh
#!/bin/bash
echo "Connecting to VPN..."
nmcli connection up work-vpn

echo "Mounting encrypted drive..."
cryptsetup open /dev/sdb1 work-data

echo "Starting required services..."
systemctl --user start work-services.target
```

```bash
# Post-switch hook example
# ~/.config/ansai/hooks/post-switch-finance.sh
#!/bin/bash
echo "Setting privacy mode..."
export ANSAI_PRIVACY_MODE=strict

echo "Disabling external APIs..."
export ANSAI_ALLOW_EXTERNAL_APIS=false

echo "Loading encrypted vault..."
ansai-vault-read finance/secrets
```

Make hooks executable:
```bash
chmod +x ~/.config/ansai/hooks/*.sh
```

## Usage Examples

### Example 1: Basic Context Switching

```bash
# Switch to work context
ansai-context-switch work

# Output:
# ✅ Context switched to: work
# 💼 Work context active
#    Focus: Professional projects with strict security
```

### Example 2: Check Current Context

```bash
# See what context you're in
ansai-context-switch --current

# Output:
# Current context: personal
```

### Example 3: List Available Contexts

```bash
# See all configured contexts
ansai-context-switch --list

# Output:
# Available contexts:
#   - work
#   - personal
#   - finance
#   - home
#   - content
#   - learning
#   - health
#   - family
#   - maintenance
#   - entertainment
#   - general
```

### Example 4: Context-Aware Script

```bash
#!/bin/bash
# my-automation-script.sh

# Check current context before running
current_context=$(cat ~/.config/ansai/current-context 2>/dev/null || echo "none")

if [[ "$current_context" != "work" ]]; then
    echo "Error: This script requires work context"
    echo "Run: ansai-context-switch work"
    exit 1
fi

# Safe to proceed with work-related automation
echo "Running in work context..."
```

### Example 5: Automated Context Switching in Workflows

```bash
#!/bin/bash
# daily-routines.sh

# Morning routine - switch to work context
if [[ $(date +%H) -ge 8 ]] && [[ $(date +%H) -lt 17 ]]; then
    ansai-context-switch work
    echo "Good morning! Switched to work context."
fi

# Evening routine - switch to personal context
if [[ $(date +%H) -ge 17 ]]; then
    ansai-context-switch personal
    echo "Good evening! Switched to personal context."
fi
```

### Example 6: Context-Specific Data Access

```bash
#!/bin/bash
# backup-script.sh

# Get current context
context=$(cat ~/.config/ansai/current-context 2>/dev/null || echo "general")

# Set backup destination based on context
case "$context" in
    work)
        BACKUP_DEST="/mnt/work-backup"
        ENCRYPTION_KEY="work-key"
        ;;
    personal)
        BACKUP_DEST="/mnt/personal-backup"
        ENCRYPTION_KEY="personal-key"
        ;;
    finance)
        BACKUP_DEST="/mnt/finance-backup"
        ENCRYPTION_KEY="finance-key"
        PRIVACY_MODE="strict"
        ;;
    *)
        BACKUP_DEST="/mnt/general-backup"
        ;;
esac

# Run backup with context-specific settings
echo "Backing up $context data to $BACKUP_DEST..."
```

## Real-World Use Cases

1. **Work/Life Separation**: Automatic VPN connection, security policies, and data isolation for work vs personal
2. **Privacy-First Finance**: Switch to finance context that disables external APIs and encrypts all data
3. **Compliance Mode**: Work context with strict logging, audit trails, and limited API access
4. **Content Creation**: Load media tools, mount storage drives, connect to creative cloud services
5. **Home Automation**: IoT device access, home network configuration, smart home integrations
6. **Development Environments**: Different SDKs, API keys, and configurations per project type

## Context Examples

### Work Context
**Use case:** Professional projects with strict security  
**Features:**
- VPN auto-connect
- Encrypted data drives
- Limited external API access
- Audit logging enabled
- Company compliance policies

### Finance Context
**Use case:** Personal finance automation  
**Features:**
- Privacy-first (all data stays local)
- No external APIs by default
- Encrypted storage required
- Budget analysis tools
- Transaction tracking

### Home Context
**Use case:** Home automation and IoT  
**Features:**
- Home network access
- IoT device control
- Energy monitoring
- Smart home integrations
- Home Assistant connection

### Learning Context
**Use case:** Education and skill development  
**Features:**
- Note-taking tools
- Learning trackers
- Course material organization
- Study timer integration
- Progress tracking

## Integration Patterns

### With Your IDE (Optional Example)

If you use an IDE that supports configuration files (like Cursor, VS Code, JetBrains, etc.), you can auto-generate IDE-specific settings when switching contexts:

```bash
# Example hook to update IDE configuration
# ~/.config/ansai/hooks/post-switch-work.sh
#!/bin/bash

# For Cursor IDE users:
if command -v ansai-rules-generate >/dev/null 2>&1; then
    ansai-rules-generate work > ~/work-projects/.cursorrules
    echo "Updated Cursor rules for work context"
fi

# For VS Code users:
if [[ -f ~/.vscode-config-generator ]]; then
    ~/.vscode-config-generator work > ~/work-projects/.vscode/settings.json
    echo "Updated VS Code settings for work context"
fi

# For any IDE - you write your own generator!
```

### With Environment Variables

```bash
# Hook to set environment variables
# ~/.config/ansai/hooks/post-switch-finance.sh
#!/bin/bash
export ANSAI_PRIVACY_MODE=strict
export ANSAI_ALLOW_EXTERNAL_APIS=false
export ANSAI_DATA_DIR=~/finance-data

# Update shell profile
echo "export ANSAI_CONTEXT=finance" >> ~/.bashrc.d/ansai-context
```

### With System Services

```bash
# Hook to manage systemd services
# ~/.config/ansai/hooks/pre-switch-home.sh
#!/bin/bash
systemctl --user start home-assistant
systemctl --user start mqtt-broker
systemctl --user start zigbee2mqtt
```

## Advanced Features

### Custom Context Definition

Create your own contexts in `contexts.yaml`:

```yaml
contexts:
  gaming:
    description: "Gaming and streaming setup"
    security_level: standard
    hooks:
      pre_switch:
        - "discord-start"
        - "obs-studio-start"
      post_switch:
        - "gaming-profile-load"
    environment:
      DISPLAY: ":0"
      GAMING_MODE: "true"
```

### Context Inheritance

```yaml
contexts:
  base_work:
    security_level: strict
    vpn: required
    
  client_a:
    inherits: base_work
    data_location: ~/clients/client-a
    compliance: "HIPAA"
    
  client_b:
    inherits: base_work
    data_location: ~/clients/client-b
    compliance: "SOC2"
```

### Context History and Rollback

```bash
# Track context history
echo "$(date -Is) $CONTEXT" >> ~/.config/ansai/context-history.log

# Rollback to previous context
previous=$(tail -n 2 ~/.config/ansai/context-history.log | head -n 1 | awk '{print $2}')
ansai-context-switch "$previous"
```

## Building Blocks Demonstrated

- ✅ **Multi-Environment Orchestration:** Seamless switching between isolated environments
- ✅ **Security Patterns:** Context-specific security policies and data isolation
- ✅ **Hook System:** Extensible pre/post actions for custom workflows
- ✅ **Configuration Management:** YAML-based context definitions
- ✅ **State Management:** Current context persistence and tracking

## Integration with Other ANSAI Workflows

- **ansai-budget-analyzer**: Automatically switches to finance context for privacy
- **ansai-vault-read**: Accesses context-specific vault paths
- **ansai-compliance-check**: Enforces context-specific compliance rules
- **ansai-dr-test**: Uses context-aware backup locations
- **ansai-email-processor**: Different email accounts per context

## Common Patterns

### Morning Work Routine

```bash
#!/bin/bash
# morning-routine.sh
ansai-context-switch work
# VPN connects automatically via pre-switch hook
# Work drives mount automatically
# Compliance mode enabled
echo "Work environment ready!"
```

### Evening Personal Projects

```bash
#!/bin/bash
# evening-routine.sh
ansai-context-switch personal
# Work VPN disconnects via hook
# Personal API keys loaded
# Creative tools enabled
echo "Personal environment ready!"
```

### Finance Sunday

```bash
#!/bin/bash
# finance-review.sh
ansai-context-switch finance
# Privacy mode enforced
# External APIs disabled
# Encrypted vault unlocked
ansai-budget-analyzer monthly-report
ansai-context-switch personal
```

## Security Considerations

1. **Data Isolation**: Each context should have separate data directories
2. **API Key Separation**: Never share API keys across work/personal contexts
3. **Audit Trails**: Log all context switches for compliance
4. **Encryption**: Use encrypted storage for sensitive contexts (work, finance, health)
5. **VPN/Network**: Automatic VPN connection for work contexts

## Troubleshooting

**Context switch fails:**
```bash
# Check current state
ansai-context-switch --current

# Verify hook errors
bash -x ~/.config/ansai/hooks/pre-switch-work.sh

# Check permissions
ls -la ~/.config/ansai/hooks/
```

**Hook not running:**
```bash
# Ensure hook is executable
chmod +x ~/.config/ansai/hooks/post-switch-finance.sh

# Test hook directly
~/.config/ansai/hooks/post-switch-finance.sh
```

## Contributing

Want to enhance context-switch? Ideas:
- Context groups (switch multiple contexts at once)
- Time-based automatic switching
- Location-based context switching (GPS)
- Context recommendations based on calendar
- Context isolation verification

## License

MIT License - Free to use and modify

---

**Part of the ANSAI Framework**  
Learn more: https://ansai.dev

