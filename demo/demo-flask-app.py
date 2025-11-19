#!/usr/bin/env python3
"""
ANSAI Demo Flask Application
Simulates a real web service that can fail for testing self-healing
"""
import os
import sys
import time
import random
from flask import Flask, jsonify, request

app = Flask(__name__)
start_time = time.time()
request_count = 0
crash_triggered = False

@app.route("/")
def index():
    """Main endpoint with API documentation"""
    global request_count
    request_count += 1
    
    return jsonify({
        "app": "ANSAI Demo Application",
        "version": "1.0.0",
        "status": "running",
        "uptime_seconds": int(time.time() - start_time),
        "total_requests": request_count,
        "endpoints": {
            "/": "API documentation (this page)",
            "/health": "Health check endpoint",
            "/crash": "Trigger immediate crash (simulates failure)",
            "/hang": "Simulate connection pool timeout",
            "/memory": "Trigger memory spike"
        },
        "demo_info": "This app demonstrates ANSAI's AI-powered self-healing capabilities"
    })

@app.route("/health")
def health():
    """Health check endpoint - monitors app status"""
    return jsonify({
        "status": "healthy",
        "uptime_seconds": int(time.time() - start_time),
        "requests_served": request_count,
        "timestamp": time.strftime("%Y-%m-%d %H:%M:%S")
    })

@app.route("/crash")
def crash():
    """Simulate an application crash"""
    print("💥 CRASH TRIGGERED VIA /crash ENDPOINT", file=sys.stderr, flush=True)
    print("This simulates an unhandled exception or fatal error", file=sys.stderr, flush=True)
    time.sleep(0.1)  # Give time for response
    os._exit(1)  # Hard exit to simulate crash

@app.route("/hang")
def hang():
    """Simulate a connection pool timeout (hangs indefinitely)"""
    print("⏱️  HANG TRIGGERED - Simulating database connection pool exhaustion", file=sys.stderr, flush=True)
    time.sleep(300)  # Hang for 5 minutes (systemd will kill it)
    return jsonify({"status": "this won't be reached"})

@app.route("/memory")
def memory_spike():
    """Simulate memory spike"""
    print("📈 MEMORY SPIKE TRIGGERED", file=sys.stderr, flush=True)
    # Allocate 100MB of memory
    data = " " * (100 * 1024 * 1024)
    return jsonify({
        "status": "memory_allocated",
        "size_mb": 100,
        "note": "Memory allocated but not released (simulates leak)"
    })

@app.errorhandler(Exception)
def handle_exception(e):
    """Log all exceptions"""
    print(f"❌ UNHANDLED EXCEPTION: {str(e)}", file=sys.stderr, flush=True)
    return jsonify({
        "error": "Internal server error",
        "message": str(e)
    }), 500

if __name__ == "__main__":
    print("=" * 60)
    print("🚀 ANSAI Demo Application Starting")
    print("=" * 60)
    print(f"Endpoints available:")
    print(f"  http://0.0.0.0:5000/        - API docs")
    print(f"  http://0.0.0.0:5000/health  - Health check")
    print(f"  http://0.0.0.0:5000/crash   - Trigger crash")
    print(f"  http://0.0.0.0:5000/hang    - Simulate timeout")
    print("=" * 60)
    
    app.run(
        host="0.0.0.0",
        port=5000,
        debug=False  # Disable debug mode for realistic behavior
    )

