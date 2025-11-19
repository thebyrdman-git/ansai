# 🎨 Build Inspiration & Tutorials

Ready to build? Here are 8 interactive tutorials to get you started with ANSAI.

---

## 🚀 Infrastructure Automation

??? example "Auto-scale based on error rates"
    **Goal:** Automatically scale up resources when error rates spike, then scale down when stable.

    **Blocks Used:**
    - 📊 **Log Analysis:** Monitor Nginx/Apache logs for 500 errors.
    - 🤖 **Orchestration:** Trigger scaling action based on threshold.
    - 💬 **Notification:** Alert team of scaling event.

    **How to Build:**
    1.  **Create Log Monitor:** Use `ansai-log-analyzer` to tail logs and count 5xx errors/minute.
    2.  **Set Threshold:** If errors > 50/min, trigger `scale_up.yml` playbook.
    3.  **Scale Up:** Playbook spins up new container/instance or increases resource limits.
    4.  **Scale Down:** If errors < 10/min for 15 mins, trigger `scale_down.yml`.

    **Code Snippet:**
    ```yaml
    - name: Check Error Rate
      shell: "tail -n 1000 /var/log/nginx/access.log | grep ' 500 ' | wc -l"
      register: error_count

    - name: Scale Up
      command: docker compose up -d --scale web=5
      when: error_count.stdout | int > 50
    ```

??? example "ChatOps for infrastructure management"
    **Goal:** Control your infrastructure directly from Slack/Discord.

    **Blocks Used:**
    - 💬 **Natural Language:** Interpret "Restart web server" commands.
    - 🤖 **Orchestration:** Execute Ansible playbooks securely.
    - 🛡️ **Security:** Validate user permissions.

    **How to Build:**
    1.  **Setup Webhook:** Create a simple Flask/FastAPI endpoint to receive Slack slash commands.
    2.  **Parse Intent:** Use `LiteLLM` to parse "Fix the database" into specific intent `db_restart`.
    3.  **Execute:** Trigger `ansible-playbook playbooks/db-restart.yml`.
    4.  **Reply:** Send "Database restarting..." back to Slack.

    **Code Snippet:**
    ```python
    @app.route('/slack/command', methods=['POST'])
    def handle_command():
        command = request.form.get('text')
        # AI parses intent
        action = ai.parse_intent(command) 
        if action == 'restart_web':
            subprocess.run(['ansible-playbook', 'restart-web.yml'])
            return "Restarting web server..."
    ```

??? example "Multi-cloud orchestration with fallback"
    **Goal:** Deploy to AWS; if it fails, automatically deploy to DigitalOcean.

    **Blocks Used:**
    - 🎯 **Orchestration:** Workflow logic with error handling.
    - ☁️ **Cloud Modules:** AWS and DigitalOcean Ansible collections.
    - 📧 **Notification:** Report fallback status.

    **How to Build:**
    1.  **Try Primary:** Run `deploy-aws.yml` inside a `block`.
    2.  **Catch Failure:** Use `rescue` to catch deployment errors.
    3.  **Execute Fallback:** Run `deploy-do.yml` in the rescue block.
    4.  **Verify:** Check health of fallback endpoint.

    **Code Snippet:**
    ```yaml
    - block:
        - name: Deploy to AWS
          include_tasks: aws-deploy.yml
      rescue:
        - name: Fallback to DigitalOcean
          include_tasks: do-deploy.yml
          vars:
            region: nyc1
        - name: Notify Team
          slack:
            msg: "AWS Deployment failed. Failed over to DigitalOcean."
    ```

??? example "Cost optimization with intelligent scheduling"
    **Goal:** Shutdown dev environments at 7 PM and start them at 8 AM to save 50% costs.

    **Blocks Used:**
    - ⏰ **Scheduling:** Cron or Systemd timers.
    - ☁️ **Cloud Modules:** AWS/GCP instance state management.
    - 🤖 **AI Prediction:** (Optional) Don't shutdown if devs are still active.

    **How to Build:**
    1.  **Define Schedule:** Create variables for `start_time` and `stop_time`.
    2.  **Check Activity:** (Optional) Check SSH logs for active sessions.
    3.  **Stop Instances:** Run playbook to stop tagged `env:dev` instances.
    4.  **Start Instances:** Run playbook to start them in the morning.

    **Code Snippet:**
    ```yaml
    - name: Stop Dev Instances
      ec2_instance:
        state: stopped
        filters:
          "tag:Environment": dev
      when: 
        - ansible_date_time.hour == "19"
        - active_ssh_sessions == 0
    ```

---

## 🛡️ Security & Compliance

??? example "Compliance-as-code with auto-remediation"
    **Goal:** Automatically fix security misconfigurations (e.g., open SSH ports, root login).

    **Blocks Used:**
    - 🔍 **Audit:** Scan config files for violations.
    - 🤖 **Orchestration:** Apply hardening roles.
    - 📊 **Reporting:** Generate compliance report.

    **How to Build:**
    1.  **Scan:** Check `/etc/ssh/sshd_config` for `PermitRootLogin yes`.
    2.  **Remediate:** Use `lineinfile` to set it to `no`.
    3.  **Reload:** Restart SSH service.
    4.  **Report:** Log the remediation action.

    **Code Snippet:**
    ```yaml
    - name: Secure SSH
      lineinfile:
        path: /etc/ssh/sshd_config
        regexp: '^PermitRootLogin'
        line: 'PermitRootLogin no'
      notify: Restart SSH
    ```

??? example "Automated disaster recovery testing"
    **Goal:** Randomly kill a service in staging to test if self-healing works (Chaos Engineering).

    **Blocks Used:**
    - 🎲 **Chaos:** Randomly select and stop services.
    - 🛡️ **Self-Healing:** Verify the system recovers.
    - 📊 **Reporting:** Measure Time To Recovery (TTR).

    **How to Build:**
    1.  **Select Target:** Randomly pick `web`, `db`, or `cache`.
    2.  **Disrupt:** `systemctl stop <target>`.
    3.  **Wait:** Wait 2 minutes.
    4.  **Verify:** Check if service is back up (self-healing should have kicked in).
    5.  **Alert:** If not back up, fail the test.

    **Code Snippet:**
    ```yaml
    - name: Chaos Monkey - Stop Service
      service:
        name: "{{ item }}"
        state: stopped
      with_random_choice:
        - nginx
        - postgresql
    ```

---

## 🧠 Advanced AI Ops

??? example "Self-optimizing database tuning"
    **Goal:** Adjust Postgres/MySQL config based on actual load patterns.

    **Blocks Used:**
    - 📊 **Metrics:** Prometheus/CloudWatch data.
    - 🤖 **AI Analysis:** Analyze performance vs config.
    - ⚙️ **Config Mgmt:** Update `postgresql.conf`.

    **How to Build:**
    1.  **Gather Data:** Collect cache hit ratio, active connections, memory usage.
    2.  **AI Analyze:** Ask LLM "Given these metrics and 32GB RAM, suggest `work_mem` setting."
    3.  **Tune:** Apply new config if different from current.
    4.  **Restart:** Gracefully reload DB.

    **Code Snippet:**
    ```yaml
    - name: AI Tune Config
      shell: "ansai-tune-db --metrics current_metrics.json"
      register: new_config

    - name: Apply Config
      template:
        src: postgresql.conf.j2
        dest: /etc/postgresql/13/main/postgresql.conf
    ```

??? example "Predictive maintenance with ML"
    **Goal:** Detect disk filling up trends and expand storage BEFORE it hits 100%.

    **Blocks Used:**
    - 📈 **Trend Analysis:** Linear regression on disk usage.
    - ☁️ **Cloud Modules:** Expand EBS volume.
    - 📂 **Filesystem:** Resize file system online.

    **How to Build:**
    1.  **Analyze:** Check disk usage over last 7 days.
    2.  **Predict:** "Will usage hit 95% in next 24 hours?"
    3.  **Expand:** If yes, modify AWS volume size `+20%`.
    4.  **Resize:** Run `resize2fs`.

    **Code Snippet:**
    ```yaml
    - name: Predict Disk Full
      script: predict_disk_growth.py
      register: prediction

    - name: Expand Volume
      ec2_vol:
        id: "{{ volume_id }}"
        size: "{{ current_size * 1.2 }}"
      when: prediction.stdout == "critical"
    ```

---

## 🧱 Ready to build?

**[Download the Core Building Blocks](index.md#quick-start){ .md-button .md-button--primary }**

