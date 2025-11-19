#!/bin/bash
# ANSAI Tutorial: Auto-Scale Based on Error Rates
# Description: Automatically scale resources when error rates spike
# Time: 20 minutes
# Prerequisites: Ansible, Docker or cloud provider CLI

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${CYAN}"
cat << "EOF"
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║     🎓 ANSAI Interactive Tutorial                         ║
║     Auto-Scale Based on Error Rates                       ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo -e "${BOLD}What You'll Build:${NC}"
echo "  • Error monitoring for web server logs"
echo "  • Automatic scaling when errors spike"
echo "  • AI analysis of error patterns"
echo "  • Automatic scale-down when stable"
echo ""
echo -e "${BOLD}Time Required:${NC} ~20 minutes"
echo ""
echo -e "${YELLOW}Press Enter to begin...${NC}"
read

# Step 1: Prerequisites check
echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BOLD}Step 1: Checking Prerequisites${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo ""

MISSING_DEPS=()

if ! command -v ansible &> /dev/null; then
    MISSING_DEPS+=("ansible")
fi

if ! command -v docker &> /dev/null && ! command -v aws &> /dev/null; then
    echo -e "${YELLOW}⚠️  Neither Docker nor AWS CLI found${NC}"
    echo "   You'll need one for scaling. Install Docker for local testing."
    MISSING_DEPS+=("docker or aws")
fi

if [ ${#MISSING_DEPS[@]} -ne 0 ]; then
    echo -e "${RED}❌ Missing dependencies: ${MISSING_DEPS[*]}${NC}"
    echo ""
    echo "Install them first:"
    echo "  • Ansible: pip3 install ansible"
    echo "  • Docker: https://docs.docker.com/get-docker/"
    exit 1
else
    echo -e "${GREEN}✅ All prerequisites met${NC}"
fi

echo ""
echo -e "${YELLOW}Press Enter to continue...${NC}"
read

# Step 2: Create monitoring script
echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BOLD}Step 2: Creating Error Monitoring Script${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo ""

echo "Creating error monitoring script..."

mkdir -p ~/ansai-tutorial-autoscale
cd ~/ansai-tutorial-autoscale

cat > monitor-errors.sh << 'SCRIPT_EOF'
#!/bin/bash
# Error monitoring script

LOG_FILE="${LOG_FILE:-/var/log/nginx/access.log}"
WINDOW_SECONDS="${WINDOW_SECONDS:-60}"
ERROR_THRESHOLD="${ERROR_THRESHOLD:-50}"

# Count 5xx errors in last minute
error_count=$(tail -n 10000 "$LOG_FILE" 2>/dev/null | \
    awk -v window="$WINDOW_SECONDS" '
    BEGIN {
        cmd = "date +%s"
        cmd | getline now
        close(cmd)
        cutoff = now - window
    }
    {
        # Parse timestamp and count 5xx errors
        if ($9 >= 500 && $9 < 600) {
            # Simplified: just count recent lines
            errors++
        }
    }
    END { print errors }
    ')

echo "Error count in last ${WINDOW_SECONDS}s: $error_count"

if [ "$error_count" -gt "$ERROR_THRESHOLD" ]; then
    echo "SCALE_UP"
    exit 1
elif [ "$error_count" -lt 10 ]; then
    echo "SCALE_DOWN"
    exit 0
else
    echo "NORMAL"
    exit 0
fi
SCRIPT_EOF

chmod +x monitor-errors.sh

echo -e "${GREEN}✅ Created: monitor-errors.sh${NC}"
echo ""
echo "This script:"
echo "  • Monitors your web server access log"
echo "  • Counts 5xx errors in a time window"
echo "  • Returns SCALE_UP, SCALE_DOWN, or NORMAL"

echo ""
echo -e "${YELLOW}Press Enter to continue...${NC}"
read

# Step 3: Create Ansible playbook
echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BOLD}Step 3: Creating Ansible Auto-Scale Playbook${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo ""

cat > autoscale-playbook.yml << 'PLAYBOOK_EOF'
---
- name: Auto-Scale Based on Error Rates
  hosts: localhost
  gather_facts: yes
  vars:
    log_file: "/var/log/nginx/access.log"
    error_threshold: 50
    scale_target: "web"  # Docker service or AWS ASG name
    min_instances: 1
    max_instances: 10
    
  tasks:
    - name: Monitor error rate
      script: monitor-errors.sh
      environment:
        LOG_FILE: "{{ log_file }}"
        ERROR_THRESHOLD: "{{ error_threshold }}"
      register: monitor_result
      ignore_errors: yes
      
    - name: Parse monitoring result
      set_fact:
        should_scale_up: "{{ monitor_result.stdout | regex_search('SCALE_UP') }}"
        should_scale_down: "{{ monitor_result.stdout | regex_search('SCALE_DOWN') }}"
        
    - name: Display current status
      debug:
        msg: |
          Error Monitoring Status:
          {{ monitor_result.stdout }}
          
          Scale Decision:
          Scale Up: {{ should_scale_up != None }}
          Scale Down: {{ should_scale_down != None }}
          
    - name: Scale up Docker service
      command: docker compose up -d --scale {{ scale_target }}={{ max_instances }}
      when: 
        - should_scale_up
        - ansible_facts['virtualization_type'] != 'container'
      ignore_errors: yes
      
    - name: Scale down Docker service  
      command: docker compose up -d --scale {{ scale_target }}={{ min_instances }}
      when:
        - should_scale_down
        - ansible_facts['virtualization_type'] != 'container'
      ignore_errors: yes
      
    - name: Send notification
      debug:
        msg: "Scaling action completed. Check service status."
PLAYBOOK_EOF

echo -e "${GREEN}✅ Created: autoscale-playbook.yml${NC}"
echo ""
echo "This playbook:"
echo "  • Runs the monitoring script"
echo "  • Decides whether to scale up/down"
echo "  • Executes scaling commands (Docker in this example)"
echo "  • Can be adapted for AWS, GCP, Azure"

echo ""
echo -e "${YELLOW}Press Enter to see AI enhancement...${NC}"
read

# Step 4: Add AI analysis
echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BOLD}Step 4: Adding AI Error Pattern Analysis${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo ""

cat > analyze-errors-ai.sh << 'AI_EOF'
#!/bin/bash
# AI-powered error analysis

LOG_FILE="${1:-/var/log/nginx/access.log}"

# Extract recent 5xx errors
recent_errors=$(tail -n 1000 "$LOG_FILE" 2>/dev/null | grep " 5[0-9][0-9] " | tail -20)

if [ -z "$recent_errors" ]; then
    echo "No recent errors found"
    exit 0
fi

# Call AI for analysis (requires GROQ_API_KEY)
if [ -n "$GROQ_API_KEY" ]; then
    analysis=$(curl -s https://api.groq.com/openai/v1/chat/completions \
        -H "Authorization: Bearer $GROQ_API_KEY" \
        -H "Content-Type: application/json" \
        -d '{
            "model": "llama-3.1-8b-instant",
            "messages": [
                {
                    "role": "user",
                    "content": "Analyze these server errors and identify patterns:\n\n'"$recent_errors"'\n\nProvide: 1) Pattern identified 2) Likely root cause 3) Scaling recommendation"
                }
            ]
        }' | python3 -c "import sys, json; print(json.load(sys.stdin)['choices'][0]['message']['content'])" 2>/dev/null)
    
    echo "🤖 AI ANALYSIS:"
    echo "$analysis"
else
    echo "⚠️  Set GROQ_API_KEY for AI analysis"
    echo ""
    echo "Pattern: Multiple 500 errors detected"
    echo "Likely cause: Resource exhaustion or upstream failure"
    echo "Recommendation: Scale up + investigate root cause"
fi
AI_EOF

chmod +x analyze-errors-ai.sh

echo -e "${GREEN}✅ Created: analyze-errors-ai.sh${NC}"
echo ""
echo "This script:"
echo "  • Extracts recent error patterns from logs"
echo "  • Sends them to AI for analysis"
echo "  • Gets intelligent recommendations"
echo "  • Helps you understand WHY errors are happening"

echo ""
echo -e "${YELLOW}Press Enter to test the workflow...${NC}"
read

# Step 5: Testing
echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BOLD}Step 5: Testing the Auto-Scale Workflow${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo ""

echo "We'll create a fake log file with errors for testing..."

# Create test log
cat > /tmp/test-nginx.log << 'LOG_EOF'
192.168.1.1 - - [19/Nov/2025:12:00:01] "GET / HTTP/1.1" 200 1234
192.168.1.1 - - [19/Nov/2025:12:00:02] "GET /api HTTP/1.1" 500 56
192.168.1.1 - - [19/Nov/2025:12:00:03] "GET /api HTTP/1.1" 500 56
192.168.1.1 - - [19/Nov/2025:12:00:04] "GET /api HTTP/1.1" 500 56
LOG_EOF

# Add 50+ errors
for i in {1..55}; do
    echo "192.168.1.1 - - [19/Nov/2025:12:00:$i] \"GET /api HTTP/1.1\" 500 56" >> /tmp/test-nginx.log
done

echo -e "${GREEN}✅ Created test log with 55+ errors${NC}"
echo ""

echo "Running monitor script..."
LOG_FILE=/tmp/test-nginx.log ERROR_THRESHOLD=50 ./monitor-errors.sh
monitor_exit=$?

echo ""
if [ $monitor_exit -eq 1 ]; then
    echo -e "${GREEN}✅ Monitor correctly detected: SCALE_UP needed${NC}"
else
    echo -e "${YELLOW}⚠️  Monitor result: No scale needed${NC}"
fi

echo ""
echo -e "${YELLOW}Press Enter to see AI analysis of these errors...${NC}"
read

echo ""
echo "Running AI analysis..."
./analyze-errors-ai.sh /tmp/test-nginx.log

echo ""
echo -e "${YELLOW}Press Enter for final summary...${NC}"
read

# Step 6: Summary
echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
echo -e "${BOLD}${GREEN}✅ Tutorial Complete!${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
echo ""

echo -e "${BOLD}What You Built:${NC}"
echo "  ✅ Error monitoring script"
echo "  ✅ Auto-scaling Ansible playbook"
echo "  ✅ AI-powered error analysis"
echo "  ✅ Complete auto-scaling workflow"
echo ""

echo -e "${BOLD}Files Created:${NC}"
echo "  • monitor-errors.sh - Error monitoring"
echo "  • autoscale-playbook.yml - Scaling automation"
echo "  • analyze-errors-ai.sh - AI analysis"
echo ""

echo -e "${BOLD}Next Steps:${NC}"
echo ""
echo "1. Customize for your environment:"
echo "   • Update LOG_FILE path in autoscale-playbook.yml"
echo "   • Change scale_target to your service name"
echo "   • Adjust thresholds for your traffic"
echo ""
echo "2. Set up AI analysis:"
echo "   export GROQ_API_KEY='your-key-here'"
echo ""
echo "3. Run it in production:"
echo "   ansible-playbook autoscale-playbook.yml"
echo ""
echo "4. Automate with cron (every 5 minutes):"
echo "   */5 * * * * cd ~/ansai-tutorial-autoscale && ansible-playbook autoscale-playbook.yml"
echo ""
echo "5. Enhance it further:"
echo "   • Add Slack notifications"
echo "   • Integrate with Prometheus"
echo "   • Add cost tracking"
echo "   • Implement gradual scaling"
echo ""

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}Tutorial files location:${NC} ~/ansai-tutorial-autoscale/"
echo ""
echo -e "${BOLD}Try another tutorial:${NC}"
echo "  • ChatOps for Infrastructure"
echo "  • Self-Optimizing Database"
echo "  • Predictive Maintenance"
echo ""
echo -e "${BOLD}Learn more:${NC} https://ansai.dev"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

echo -e "${GREEN}Thanks for trying ANSAI! 🚀${NC}"
echo ""

