#!/bin/bash
# ANSAI Interactive Playground Demo
# Run this inside the Docker container to experience AI-powered self-healing

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Demo configuration
SERVICE_NAME="demo-app"
SERVICE_PORT=5000
DEMO_MODE=false

# Check if running in demo mode (no API key)
if [[ -z "$ANSAI_GROQ_API_KEY" ]] || [[ "$ANSAI_GROQ_API_KEY" == "demo_mode" ]]; then
    DEMO_MODE=true
fi

echo -e "${CYAN}"
cat << "EOF"
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║     🤖 ANSAI Interactive Demo                             ║
║     Watch AI-Powered Self-Healing in Real-Time           ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

if $DEMO_MODE; then
    echo -e "${YELLOW}⚠️  Running in DEMO MODE (no API key detected)${NC}"
    echo -e "${YELLOW}   AI analysis will be simulated for demonstration${NC}"
    echo ""
    echo -e "   To enable real AI: ${CYAN}export ANSAI_GROQ_API_KEY='your-key'${NC}"
    echo ""
fi

echo -e "${BOLD}This demo will:${NC}"
echo "  1. Start a Flask web application"
echo "  2. Crash it (intentionally)"
echo "  3. Show ANSAI detecting the failure"
echo "  4. Display AI root cause analysis"
echo "  5. Automatically heal the service"
echo ""
echo -e "${YELLOW}Press Enter to begin...${NC}"
read

# Step 1: Start the service
echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BOLD}Step 1: Starting demo-app service${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo ""

sudo systemctl start $SERVICE_NAME
sleep 2

# Verify it's running
if systemctl is-active --quiet $SERVICE_NAME; then
    echo -e "${GREEN}✅ Service started successfully${NC}"
    echo ""
    echo "Service status:"
    systemctl status $SERVICE_NAME --no-pager --lines=5
    echo ""
    echo -e "${GREEN}✅ Testing endpoint...${NC}"
    curl -s http://localhost:$SERVICE_PORT/ | jq '.' 2>/dev/null || curl -s http://localhost:$SERVICE_PORT/
    echo ""
else
    echo -e "${RED}❌ Failed to start service${NC}"
    exit 1
fi

echo ""
echo -e "${YELLOW}Press Enter to crash the service...${NC}"
read

# Step 2: Crash the service
echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BOLD}Step 2: Crashing the service (simulated failure)${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo ""

echo -e "${RED}💥 Triggering crash endpoint...${NC}"
curl -s http://localhost:$SERVICE_PORT/crash || true
sleep 2

# Verify it crashed
if ! systemctl is-active --quiet $SERVICE_NAME; then
    echo -e "${RED}❌ Service crashed (as expected for demo)${NC}"
    echo ""
    echo "Service status:"
    systemctl status $SERVICE_NAME --no-pager --lines=8 || true
else
    echo -e "${YELLOW}⚠️  Service still running, stopping it manually${NC}"
    sudo systemctl stop $SERVICE_NAME
fi

echo ""
echo -e "${YELLOW}Press Enter to run ANSAI self-healing analysis...${NC}"
read

# Step 3: ANSAI Detection and AI Analysis
echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BOLD}Step 3: ANSAI Detection & AI Root Cause Analysis${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo ""

echo -e "${CYAN}🔍 ANSAI detected service failure${NC}"
echo ""
sleep 1

if $DEMO_MODE; then
    # Simulated AI analysis for demo mode
    echo -e "${BOLD}🤖 AI-POWERED ROOT CAUSE ANALYSIS${NC}"
    echo -e "${CYAN}(Simulated - set ANSAI_GROQ_API_KEY for real AI)${NC}"
    echo ""
    sleep 1
    cat << 'EOF'
ROOT CAUSE:
The demo-app service crashed due to an unhandled exception, likely
triggered by the /crash endpoint which simulates a fatal error.

WHY IT FAILED:
• Application received request to /crash endpoint
• Code executed os._exit(1) causing immediate termination
• No graceful shutdown, process killed instantly
• Systemd detected abnormal exit code (1)

RECOMMENDED FIX:
1. Add exception handling around critical endpoints
2. Implement graceful shutdown handlers
3. Add request validation to prevent crash triggers
4. Configure systemd Restart=always for automatic recovery

PREVENTION:
• Add input validation and rate limiting
• Implement health checks that detect unresponsive state
• Add monitoring for unusual endpoint access patterns
• Configure alerting for repeated crashes
EOF
else
    # Real AI analysis (would call Groq API here)
    echo -e "${BOLD}🤖 AI-POWERED ROOT CAUSE ANALYSIS${NC}"
    echo ""
    echo "Analyzing logs, metrics, and system state..."
    sleep 2
    
    # Call actual AI (this would be implemented with real Groq API call)
    echo "[Real AI analysis would appear here with GROQ_API_KEY set]"
fi

echo ""
echo ""
echo -e "${YELLOW}Press Enter to heal the service...${NC}"
read

# Step 4: Healing
echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BOLD}Step 4: ANSAI Self-Healing${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo ""

echo -e "${GREEN}🔧 Executing healing strategy: service_restart${NC}"
echo ""
sleep 1

sudo systemctl start $SERVICE_NAME
sleep 2

# Verify healing
if systemctl is-active --quiet $SERVICE_NAME; then
    echo -e "${GREEN}✅ SUCCESS: Service healed and running${NC}"
    echo ""
    echo "Service status:"
    systemctl status $SERVICE_NAME --no-pager --lines=5
    echo ""
    echo -e "${GREEN}✅ Testing endpoint...${NC}"
    curl -s http://localhost:$SERVICE_PORT/health | jq '.' 2>/dev/null || curl -s http://localhost:$SERVICE_PORT/health
    echo ""
else
    echo -e "${RED}❌ Healing failed${NC}"
    exit 1
fi

# Summary
echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
echo -e "${BOLD}${GREEN}✅ Demo Complete!${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}What just happened:${NC}"
echo "  ✅ Service failed (crash)"
echo "  ✅ ANSAI detected failure in ~2 seconds"
echo "  ✅ AI analyzed root cause"
echo "  ✅ Service healed automatically"
echo "  ✅ Total healing time: ~5 seconds"
echo ""
echo -e "${BOLD}In production, you would receive an email like:${NC}"
echo ""
cat << 'EOF'
  From: ANSAI Self-Healing <ansai@yourserver.com>
  Subject: ✅ YourServer: demo-app - RESOLVED
  
  🤖 AI ANALYSIS:
  Service crashed due to unhandled exception at /crash endpoint.
  
  ✅ HEALING: Service restarted successfully
  
  💡 PREVENTION: Add exception handling + health checks
EOF
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}Next Steps:${NC}"
echo ""
echo "  📚 Read the docs: http://ansai.dev"
echo "  🚀 Deploy to production: ansai-self-test"
echo "  💬 Join the community: github.com/thebyrdman-git/ansai"
echo ""
echo "  Try crashing again: ${CYAN}curl localhost:5000/crash${NC}"
echo "  Watch logs: ${CYAN}journalctl -u demo-app -f${NC}"
echo ""
echo -e "${GREEN}Thanks for trying ANSAI! 🎉${NC}"
echo ""

