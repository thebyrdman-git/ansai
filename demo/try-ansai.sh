#!/bin/bash
# ANSAI Interactive Demo
# See AI-powered self-healing in action without installing anything

set -e

echo "═══════════════════════════════════════════════════════"
echo "  🤖 ANSAI Interactive Demo"
echo "  See AI-powered self-healing in action"
echo "═══════════════════════════════════════════════════════"
echo ""

# Check for Groq API key
if [ -z "$GROQ_API_KEY" ]; then
    echo "⚠️  To see AI analysis, set your Groq API key:"
    echo "   export GROQ_API_KEY='your-key-here'"
    echo "   Get a free key at: https://console.groq.com"
    echo ""
    echo "📝 Demo will run in simulation mode (no real AI calls)"
    echo ""
    DEMO_MODE="simulation"
else
    echo "✅ Groq API key detected - real AI analysis enabled!"
    echo ""
    DEMO_MODE="live"
fi

# Create demo scenario
echo "🎬 Demo Scenario:"
echo "   Your Flask app is running on a production server."
echo "   It crashes due to a database connection issue."
echo "   Watch ANSAI detect, analyze, and heal it."
echo ""
read -p "Press Enter to start the demo..."
echo ""

# Simulate service failure
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "⏰ Time: 03:00 AM"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🔴 [ALERT] my-flask-app.service has stopped responding"
sleep 2

# ANSAI Detection
echo ""
echo "🔍 [ANSAI] Failure detected in 1.2 seconds"
echo "🤖 [ANSAI] Initiating AI root cause analysis..."
sleep 2

# AI Analysis (real or simulated)
if [ "$DEMO_MODE" = "live" ]; then
    echo ""
    echo "🧠 [AI] Analyzing service logs, system metrics, and recent changes..."
    
    # Call actual Groq API
    ANALYSIS=$(curl -s -X POST https://api.groq.com/openai/v1/chat/completions \
        -H "Authorization: Bearer $GROQ_API_KEY" \
        -H "Content-Type: application/json" \
        -d '{
            "model": "llama-3.1-8b-instant",
            "messages": [{
                "role": "system",
                "content": "You are analyzing a Flask app failure. Be concise."
            }, {
                "role": "user",
                "content": "Flask app crashed. Logs show: OperationalError: (psycopg2.OperationalError) FATAL: remaining connection slots are reserved. Last 50 connections exhausted. Previous restart 2 hours ago. Provide brief root cause, why it failed (2-3 bullets), and recommended fix."
            }],
            "temperature": 0.3,
            "max_tokens": 300
        }' | python3 -c "import sys, json; print(json.load(sys.stdin)['choices'][0]['message']['content'])" 2>/dev/null || echo "Simulating AI response...")
    
    sleep 1
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🤖 AI ROOT CAUSE ANALYSIS"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "$ANALYSIS"
else
    sleep 2
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🤖 AI ROOT CAUSE ANALYSIS (Simulated)"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "ROOT CAUSE:"
    echo "Flask app crashed due to PostgreSQL connection pool exhaustion."
    echo "All 50 available connections were consumed and not released."
    echo ""
    echo "WHY IT FAILED:"
    echo "• Connection pool configured for max 50 connections"
    echo "• No connection timeout set, causing hung connections"
    echo "• Previous restart 2 hours ago shows recurring pattern"
    echo "• Likely memory leak or missing connection.close() calls"
    echo ""
    echo "RECOMMENDED FIX:"
    echo "1. Add pool_timeout=30 to SQLAlchemy engine config"
    echo "2. Implement connection pooling with max_overflow=10"
    echo "3. Review code for unclosed database connections"
    echo "4. Add connection pool monitoring to dashboard"
    echo ""
    echo "PREVENTION:"
    echo "Set up monitoring for connection pool usage and alert when"
    echo "utilization exceeds 80%. Implement automatic connection"
    echo "recycling every hour."
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
sleep 2

# ANSAI Healing
echo ""
echo "⚡ [ANSAI] Executing healing strategy: service_restart + cleanup"
sleep 1
echo "   • Stopping my-flask-app.service..."
sleep 1
echo "   • Closing stale database connections..."
sleep 1
echo "   • Restarting my-flask-app.service..."
sleep 2
echo ""
echo "✅ [ANSAI] Service restored successfully!"
echo ""

# Results
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 HEALING SUMMARY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Total Time:              6.2 seconds"
echo "Detection:               1.2s"
echo "AI Analysis:             2.0s"  
echo "Healing:                 3.0s"
echo ""
echo "Status:                  ✅ RESOLVED"
echo "Root Cause Identified:   ✅ Yes (DB connection pool exhaustion)"
echo "Fix Applied:             ✅ Service restart + connection cleanup"
echo "Prevention Tips Sent:    ✅ Email report delivered"
echo ""
echo "Without ANSAI:"
echo "• You wake up to alerts at 3 AM"
echo "• Spend 15-30 minutes debugging"
echo "• Manually restart service"
echo "• Root cause still unknown"
echo ""
echo "With ANSAI:"
echo "• Fixed automatically in 6 seconds"
echo "• Root cause identified by AI"
echo "• Prevention steps provided"
echo "• You sleep through the night 😴"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ "$DEMO_MODE" = "simulation" ]; then
    echo "💡 Want to see REAL AI analysis?"
    echo "   1. Get a free Groq API key: https://console.groq.com"
    echo "   2. Export it: export GROQ_API_KEY='your-key'"
    echo "   3. Run this demo again!"
    echo ""
fi

echo "🚀 Ready to install ANSAI?"
echo ""
echo "   curl -sSL https://ansai.dev/install.sh | bash"
echo ""
echo "📚 Learn more: https://ansai.dev"
echo ""

