# 💾 Disk Space Management Patterns

**Prevent "Disk Full" outages before they happen.**

This pattern goes beyond simple log rotation. It intelligently manages disk space based on usage trends, file types, and application priority.

## 🧠 The AI Advantage

Standard tools just delete files older than X days. **ANSAI** adds intelligence:

1. **Predictive Cleaning:** "Disk will fill up in 3 days at current rate -> Clean now."
2. **Context-Aware:** "Is this a temp file or a critical backup?"
3. **Safe Expansion:** "Volume is 90% full -> Auto-expand EBS volume (if cloud)."

## 🛠️ Implementation

### 1. The Cleanup Policy

Define rules in `defaults/main.yml`:

```yaml
disk_cleanup_rules:
  - path: /var/log/app
    pattern: "*.log"
    age: 7d
    strategy: "archive_then_delete"
  
  - path: /tmp/scratch
    pattern: "*"
    threshold_percent: 85
    strategy: "aggressive_delete"
```

### 2. The Playbook

```yaml
- name: Smart Disk Cleanup
  hosts: all
  roles:
    - role: sysadmin/disk_cleaner
      vars:
        dry_run: false
```

### 3. Intelligent Sensors

The monitoring agent watches for:
- Rapid fill rate (Log explosion?)
- Inode exhaustion (Too many small files?)
- Large orphaned files (Deleted but open?)

## 🤖 Example Workflow

1. **Sensor** detects `/var` is at 85%.
2. **AI Analyzer** checks growth rate. "It's growing 1% per hour."
3. **Decision Engine** triggers `disk_cleaner` role with `strategy: normal`.
4. **Validation** confirms disk usage dropped to 60%.
5. **Notification** sent to Slack: "Prevented disk outage on web-01. Cleaned 5GB of logs."


