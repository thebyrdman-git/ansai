# 🌟 ANSAI + Community Roles

**ANSAI builds on the incredible work of the Ansible community.** Instead of reinventing the wheel, ANSAI adds AI-powered intelligence to proven, battle-tested roles from top contributors.

This page showcases how to enhance popular Ansible Galaxy roles with ANSAI's AI capabilities for self-healing, intelligent monitoring, and predictive maintenance.

---

## 🎯 Why Use Community Roles?

- ✅ **Battle-tested**: Used by thousands of deployments
- ✅ **Well-documented**: Comprehensive guides and examples
- ✅ **Actively maintained**: Regular updates and bug fixes
- ✅ **Best practices**: Written by experts

**ANSAI's value:** Add AI analysis, self-healing, and predictive capabilities on top.

---

## 🚀 Featured Integrations

### 1. Intelligent Docker Management

**Base Role:** [`geerlingguy.docker`](https://galaxy.ansible.com/geerlingguy/docker) by Jeff Geerling  
**Downloads:** 10M+ | **Stars:** 1.2k+

**What it does:** Installs and configures Docker on any Linux system.

**ANSAI Enhancement:** AI-powered container health monitoring with automatic healing.

```yaml
# Install Docker using community role
- hosts: servers
  roles:
    - geerlingguy.docker

# Add ANSAI AI-powered monitoring
- hosts: servers
  roles:
    - ansai.self_heal
  vars:
    monitored_services:
      - name: docker
        type: container_runtime
        critical: true
        ai_analysis_enabled: true
        healing_strategies:
          - service_restart
          - cleanup_dead_containers
          - prune_volumes
```

**What ANSAI Adds:**
- 🤖 **AI Root Cause Analysis**: "Container failed due to OOM (out of memory). Current memory limit: 512MB. Typical usage: 480MB. Recommendation: Increase to 1GB."
- 🛡️ **Auto-Healing**: Restarts failed containers, cleans up resources
- 📊 **Predictive Alerts**: "Container memory usage trending up. Will hit limit in 4 hours."

**Credit:** Docker role by [Jeff Geerling](https://github.com/geerlingguy), one of the most prolific Ansible contributors with 100+ roles.

---

### 2. Self-Healing Nginx

**Base Role:** [`geerlingguy.nginx`](https://galaxy.ansible.com/geerlingguy/nginx)  
**Downloads:** 8M+ | **Stars:** 850+

**What it does:** Installs, configures, and manages Nginx web server.

**ANSAI Enhancement:** AI-powered analysis of 500 errors and automatic recovery.

```yaml
# Standard Nginx deployment
- hosts: webservers
  roles:
    - role: geerlingguy.nginx
      nginx_vhosts:
        - server_name: "example.com"
          root: "/var/www/html"

# Add ANSAI intelligent monitoring
- hosts: webservers
  roles:
    - ansai.self_heal
  vars:
    monitored_services:
      - name: nginx
        port: 80
        critical: true
        ai_analysis_enabled: true
        log_analysis:
          error_log: /var/log/nginx/error.log
          access_log: /var/log/nginx/access.log
```

**AI Analysis Example:**

```
🤖 NGINX FAILURE ANALYSIS

ROOT CAUSE: 
Worker processes exhausted due to upstream timeout. PHP-FPM
not responding, causing all workers to block.

WHY IT FAILED:
• PHP-FPM pool exhausted (50/50 workers busy)
• Slow database queries (avg 12s response time)
• Nginx worker_processes = 4 (insufficient for load)

RECOMMENDED FIX:
1. Increase PHP-FPM pm.max_children from 50 to 100
2. Optimize slow queries (top 3 queries identified)
3. Increase nginx worker_processes to 8

PREVENTION:
Add upstream timeout (proxy_read_timeout 30s) to fail fast
instead of blocking workers.
```

---

### 3. PostgreSQL with Predictive Tuning

**Base Role:** [`geerlingguy.postgresql`](https://galaxy.ansible.com/geerlingguy/postgresql)  
**Downloads:** 2M+ | **Stars:** 450+

**What it does:** Installs and configures PostgreSQL database.

**ANSAI Enhancement:** AI-driven performance tuning and failure prediction.

```yaml
# Deploy PostgreSQL
- hosts: databases
  roles:
    - role: geerlingguy.postgresql
      postgresql_databases:
        - name: production_db
      postgresql_users:
        - name: app_user
          password: "{{ vault_db_password }}"

# Add ANSAI AI tuning
- hosts: databases
  roles:
    - ansai.self_heal
    - ansai.ai_tuning
  vars:
    monitored_services:
      - name: postgresql
        port: 5432
        critical: true
        ai_tuning_enabled: true
        metrics_collection:
          - cache_hit_ratio
          - active_connections
          - slow_queries
```

**AI Tuning Example:**

```
🤖 AI DATABASE TUNING RECOMMENDATIONS

CURRENT PERFORMANCE:
• Cache hit ratio: 87% (target: >95%)
• Active connections: 180/200 (90% utilization)
• Slow queries: 45/hour (queries >1s)

RECOMMENDED CONFIG CHANGES:
shared_buffers: 4GB → 8GB (you have 32GB RAM)
effective_cache_size: 8GB → 24GB
work_mem: 4MB → 16MB
maintenance_work_mem: 64MB → 512MB

EXPECTED IMPACT:
• Cache hit ratio: 87% → 96%
• Query performance: +40% faster
• Connection overhead: -25%

APPLY? [Y/n]
```

---

### 4. Prometheus + Grafana Monitoring with AI Insights

**Base Roles:**
- [`cloudalchemy.prometheus`](https://galaxy.ansible.com/cloudalchemy/prometheus) by Cloud Alchemy
- [`cloudalchemy.grafana`](https://galaxy.ansible.com/cloudalchemy/grafana)

**Downloads:** 5M+ combined | **Community:** 200+ contributors

**What they do:** Deploy complete monitoring stack with Prometheus and Grafana.

**ANSAI Enhancement:** AI-powered anomaly detection and intelligent alerting.

```yaml
# Deploy monitoring stack
- hosts: monitoring
  roles:
    - cloudalchemy.prometheus
    - cloudalchemy.grafana
    - ansai.ai_insights
  vars:
    prometheus_scrape_configs:
      - job_name: 'node'
        static_configs:
          - targets: ['localhost:9100']
    
    # ANSAI AI enhancement
    ansai_ai_analysis:
      enable_anomaly_detection: true
      alert_reduction: true  # AI reduces alert noise
      predictive_alerts: true
```

**AI Alert Intelligence:**

Traditional Alert Fatigue:
```
[12:01] CPU High (85%)
[12:02] Memory High (88%)
[12:03] Disk I/O High
[12:04] Network errors detected
[12:05] Response time degraded
```

**ANSAI AI-Consolidated Alert:**
```
🤖 INCIDENT CORRELATION

ROOT CAUSE: Single issue causing cascade
Database backup job started at 12:00, consuming resources

IMPACT:
✗ CPU spike (backup compression)
✗ Memory usage (backup buffer)  
✗ Disk I/O (backup writes)
✗ Network (backup to S3)
✗ App response time (resource contention)

ACTION: Normal behavior during scheduled backup
RECOMMENDATION: Move backup to off-peak hours (3 AM)

Alert count: 5 alerts → 1 insight
```

**Credit:** Prometheus/Grafana roles by [Cloud Alchemy](https://github.com/cloudalchemy), the monitoring experts in the Ansible community.

---

### 5. MySQL Replication with Intelligent Failover

**Base Role:** [`geerlingguy.mysql`](https://galaxy.ansible.com/geerlingguy/mysql)  
**Downloads:** 5M+ | **Stars:** 600+

**What it does:** Installs MySQL/MariaDB with replication support.

**ANSAI Enhancement:** AI-detected replication lag with automatic failover.

```yaml
# Deploy MySQL replication
- hosts: mysql_primary
  roles:
    - role: geerlingguy.mysql
      mysql_replication_role: 'master'

- hosts: mysql_replicas
  roles:
    - role: geerlingguy.mysql
      mysql_replication_role: 'slave'
      mysql_replication_master: "{{ groups['mysql_primary'][0] }}"

# Add ANSAI intelligent failover
- hosts: mysql_primary:mysql_replicas
  roles:
    - ansai.self_heal
    - ansai.replication_monitor
  vars:
    replication_monitoring:
      lag_threshold: 30  # seconds
      ai_analysis: true
      auto_failover: true
```

**AI Failover Decision:**

```
🤖 REPLICATION LAG DETECTED

PRIMARY: db-primary-01
REPLICA: db-replica-02
LAG: 450 seconds (critical)

AI ANALYSIS:
Replication lag due to long-running query on replica:
  Query: UPDATE users SET last_login WHERE...
  Duration: 7 minutes
  Blocking: 1,200 subsequent queries

TRADITIONAL APPROACH: Fail over immediately
  Risk: Replica is inconsistent, query mid-flight

AI RECOMMENDATION: Wait 45 seconds
  Reasoning: Query will complete in ~60s based on execution plan
  Safer: Let query finish, then verify consistency
  
Monitoring query progress... [=========>  ] 85%
Query completed. Replication caught up.
❌ Failover not needed. Crisis averted.
```

---

### 6. Security Hardening with AI Compliance

**Base Role:** [`geerlingguy.security`](https://galaxy.ansible.com/geerlingguy/security)  
**Downloads:** 3M+ | **Stars:** 500+

**What it does:** Applies security hardening (firewall, SSH, fail2ban).

**ANSAI Enhancement:** AI-powered security audit and compliance reporting.

```yaml
# Apply security hardening
- hosts: all
  roles:
    - role: geerlingguy.security
      security_ssh_port: 2222
      security_sudoers_passwordless: []

# Add ANSAI AI security audit
- hosts: all
  roles:
    - ansai.security_audit
  vars:
    security_frameworks:
      - CIS
      - NIST
      - PCI-DSS
    ai_remediation: true
```

**AI Security Report:**

```
🤖 AI SECURITY AUDIT RESULTS

COMPLIANCE: CIS Benchmark Level 1

✅ PASSED (45 checks)
⚠️  WARNINGS (3 checks)
❌ FAILED (2 checks)

CRITICAL FINDINGS:

1. [FAIL] Unencrypted passwords in /opt/app/config.ini
   Risk: High - Credentials exposed
   
   AI RECOMMENDATION:
   Move passwords to environment variables or Ansible Vault.
   
   Auto-fix available:
   $ ansai-vault-migrate /opt/app/config.ini

2. [FAIL] SSH accepts password authentication
   Risk: Medium - Brute force attacks possible
   
   AI RECOMMENDATION:
   Set 'PasswordAuthentication no' in /etc/ssh/sshd_config
   Ensure SSH keys are deployed first.
   
   Auto-fix: [Y/n]

3. [WARN] PostgreSQL listening on 0.0.0.0
   Risk: Low - Database exposed to network
   
   AI CONTEXT:
   Database is behind firewall (port 5432 blocked).
   Risk mitigated but not eliminated.
   
   Consider: Bind to 127.0.0.1 + SSH tunnel for admin access
```

---

### 7. Node.js App Deployment with Smart Restarts

**Base Role:** [`geerlingguy.nodejs`](https://galaxy.ansible.com/geerlingguy/nodejs)  
**Downloads:** 4M+ | **Stars:** 400+

**What it does:** Installs Node.js, npm, and manages Node applications.

**ANSAI Enhancement:** Zero-downtime deployments with AI-verified health checks.

```yaml
# Deploy Node.js app
- hosts: appservers
  roles:
    - role: geerlingguy.nodejs
      nodejs_version: "18.x"
    - role: ansai.app_deploy
  vars:
    app_name: my-api
    app_repo: https://github.com/company/api.git
    app_port: 3000
    ansai_smart_deploy:
      health_check: "http://localhost:3000/health"
      ai_verification: true
      rollback_on_errors: true
```

**AI Deployment Verification:**

```
🚀 DEPLOYING: my-api v2.3.1

[1/6] Pull latest code... ✅
[2/6] Install dependencies... ✅  
[3/6] Run tests... ✅
[4/6] Start new instance on port 3001... ✅
[5/6] Health check... ✅

🤖 AI DEPLOYMENT VERIFICATION

New version health:
  ✅ /health returns 200
  ✅ Response time: 45ms (vs 38ms old version)
  ✅ Memory usage: 120MB (vs 115MB old version)
  ⚠️  ERROR RATE: 2.5% (vs 0.1% old version)

AI ANALYSIS:
New version is returning errors on /api/users/search endpoint.
Error: "Cannot read property 'map' of undefined"

This is a REGRESSION. Rolling back deployment.

[6/6] Rollback... ✅

DEPLOYMENT CANCELLED.
Old version still running. Zero downtime.

Check code at: src/controllers/userController.js:47
```

---

## 🎓 How to Use These Examples

### Step 1: Install Community Role

```bash
ansible-galaxy install geerlingguy.docker
ansible-galaxy install geerlingguy.nginx
ansible-galaxy install geerlingguy.postgresql
ansible-galaxy install cloudalchemy.prometheus
```

### Step 2: Install ANSAI

```bash
curl -sSL https://raw.githubusercontent.com/thebyrdman-git/ansai/main/install.sh | bash
```

### Step 3: Combine in Your Playbook

```yaml
- hosts: servers
  roles:
    # Use proven community role for setup
    - geerlingguy.docker
    
    # Add ANSAI intelligence on top
    - ansai.self_heal
  vars:
    monitored_services:
      - name: docker
        ai_analysis_enabled: true
```

### Step 4: Get AI-Powered Insights

When something fails, you get detailed AI analysis instead of just "service down."

---

## 🙏 Community Acknowledgments

ANSAI is built on the shoulders of giants. Special thanks to:

### 🌟 Jeff Geerling ([@geerlingguy](https://github.com/geerlingguy))
- **Contribution:** 100+ high-quality Ansible roles
- **Impact:** 50M+ downloads across all roles
- **Notable:** Author of "Ansible for DevOps" book
- **ANSAI Integration:** Docker, Nginx, MySQL, PostgreSQL, Security, Node.js

### 🌟 Cloud Alchemy Team ([@cloudalchemy](https://github.com/cloudalchemy))
- **Contribution:** Monitoring and observability stack roles
- **Impact:** Industry standard for Prometheus/Grafana deployment
- **Notable:** 200+ community contributors
- **ANSAI Integration:** Prometheus, Grafana, Alertmanager, Exporters

### 🌟 Ansible Community
- **60,000+ roles** on Ansible Galaxy
- **Thousands of contributors** worldwide
- **ANSAI's role:** Adding AI intelligence to your existing automation

---

## 💡 Philosophy

**ANSAI doesn't replace the Ansible ecosystem. It enhances it.**

- ✅ Use battle-tested roles from the community
- ✅ Add AI for root cause analysis
- ✅ Add self-healing capabilities
- ✅ Add predictive intelligence
- ✅ Keep everything open source

**The result:** Smarter automation that thinks, not just executes.

---

## 🚀 Next Steps

1. **Browse [Ansible Galaxy](https://galaxy.ansible.com/)** for roles you need
2. **Install ANSAI**: `curl -sSL https://ansai.dev/install.sh | bash`
3. **Combine them** in your playbooks
4. **Get AI-powered insights** when things go wrong

**[View Full Documentation →](../index.md)** | **[Try ANSAI Now →](../index.md#try-ansai-right-now-no-installation)**

---

<div style="text-align: center; padding: 2rem; background: #f8f9fa; border-radius: 8px;">

**Standing on the shoulders of giants.**  
**Adding AI to proven solutions.**  
**Making infrastructure intelligent.**

**That's ANSAI.**

</div>

