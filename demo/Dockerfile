# ANSAI Interactive Playground
# Try AI-powered self-healing without installing anything
# 
# Usage:
#   docker-compose up -d
#   docker exec -it ansai-playground /bin/bash
#   ansai-demo

FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
    container=docker \
    ANSAI_DEMO_MODE=true

# Install core dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-flask \
    ansible \
    curl \
    jq \
    systemd \
    systemd-sysv \
    sudo \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Configure systemd for container use
RUN cd /lib/systemd/system/sysinit.target.wants/ && \
    ls | grep -v systemd-tmpfiles-setup | xargs rm -f && \
    rm -f /lib/systemd/system/multi-user.target.wants/* \
    /etc/systemd/system/*.wants/* \
    /lib/systemd/system/local-fs.target.wants/* \
    /lib/systemd/system/sockets.target.wants/*udev* \
    /lib/systemd/system/sockets.target.wants/*initctl* \
    /lib/systemd/system/basic.target.wants/* \
    /lib/systemd/system/anaconda.target.wants/*

# Create demo user
RUN useradd -m -s /bin/bash ansai && \
    echo "ansai ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Install Python packages
RUN pip3 install flask requests psutil

# Create demo Flask application
RUN mkdir -p /opt/demo-app
COPY demo/demo-flask-app.py /opt/demo-app/app.py 2>/dev/null || \
    echo '#!/usr/bin/env python3\nimport os\nimport time\nimport random\nfrom flask import Flask, jsonify\n\napp = Flask(__name__)\nstart_time = time.time()\nrequest_count = 0\n\n@app.route("/health")\ndef health():\n    global request_count\n    request_count += 1\n    \n    # Simulate failure after 20 requests (for demo)\n    if os.environ.get("ANSAI_DEMO_MODE") == "true" and request_count > 20:\n        time.sleep(100)  # Hang to simulate timeout\n    \n    uptime = int(time.time() - start_time)\n    return jsonify({\n        "status": "healthy",\n        "uptime_seconds": uptime,\n        "requests": request_count\n    })\n\n@app.route("/")\ndef index():\n    return jsonify({\n        "message": "ANSAI Demo Application",\n        "endpoints": ["/health", "/crash"]\n    })\n\n@app.route("/crash")\ndef crash():\n    """Endpoint to simulate a crash for testing ANSAI self-healing"""\n    os._exit(1)\n\nif __name__ == "__main__":\n    app.run(host="0.0.0.0", port=5000)' > /opt/demo-app/app.py

RUN chmod +x /opt/demo-app/app.py

# Create systemd service for demo app
RUN echo '[Unit]\nDescription=ANSAI Demo Flask Application\nAfter=network.target\n\n[Service]\nType=simple\nUser=ansai\nWorkingDirectory=/opt/demo-app\nExecStart=/usr/bin/python3 /opt/demo-app/app.py\nRestart=no\nRestartSec=3\nStandardOutput=journal\nStandardError=journal\n\n[Install]\nWantedBy=multi-user.target' > /etc/systemd/system/demo-app.service

# Enable the demo service
RUN systemctl enable demo-app.service

# Copy ANSAI files
WORKDIR /opt/ansai
COPY orchestrators/ ./orchestrators/
COPY bin/ ./bin/
COPY demo/try-ansai.sh ./demo/try-ansai.sh
COPY demo/playground-demo.sh ./demo/playground-demo.sh 2>/dev/null || echo "#!/bin/bash\necho 'Demo script'" > ./demo/playground-demo.sh

# Make scripts executable
RUN chmod +x bin/* demo/*.sh

# Create symlinks for easy access
RUN ln -s /opt/ansai/demo/playground-demo.sh /usr/local/bin/ansai-demo && \
    ln -s /opt/ansai/demo/try-ansai.sh /usr/local/bin/try-ansai

# Set up ANSAI self-healing (demo mode)
RUN mkdir -p /etc/ansai /var/log/ansai && \
    chown -R ansai:ansai /etc/ansai /var/log/ansai /opt/ansai

# Create demo welcome script
RUN echo '#!/bin/bash\ncat << "EOF"\n\n╔═══════════════════════════════════════════════════════╗\n║                                                       ║\n║     🤖 ANSAI Interactive Playground                   ║\n║     AI-Powered Self-Healing in Action                ║\n║                                                       ║\n╚═══════════════════════════════════════════════════════╝\n\n✨ This is a live demo environment where you can:\n\n  1. Run a Flask application\n  2. Crash it (intentionally)\n  3. Watch ANSAI detect and heal it\n  4. See AI root cause analysis\n\n📚 Quick Commands:\n\n  ansai-demo     - Run the interactive demo\n  systemctl status demo-app   - Check app status\n  journalctl -u demo-app -f   - Watch app logs\n  curl localhost:5000/crash   - Crash the app manually\n\n🚀 Get Started:\n\n  Type: ansai-demo\n\n💡 Note: AI analysis requires ANSAI_GROQ_API_KEY environment variable.\n     Without it, youll see demo mode (simulated AI output).\n\nEOF\n' > /usr/local/bin/welcome && chmod +x /usr/local/bin/welcome

# Add welcome to bashrc
RUN echo 'welcome' >> /home/ansai/.bashrc

WORKDIR /home/ansai
USER ansai

VOLUME ["/sys/fs/cgroup"]
EXPOSE 5000 8000

CMD ["/sbin/init"]
